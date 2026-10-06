import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
project = directory.parents[2]
baseline = json.loads((directory / "输入清单.json").read_text())
integrated = json.loads((directory / "合并复验输入.json").read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fixed_inputs(manifest):
    fixed = Path(manifest["frozen_worktree"])

    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=fixed, text=True).strip() == manifest["source"]
    assert subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=fixed, text=True).strip() == manifest["source_tree"]
    status = subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=all"], cwd=fixed, text=True)
    assert {line[3:] for line in status.splitlines()} == {item["path"] for item in manifest["inputs"]}

    for item in manifest["inputs"]:
        for root in [fixed, project, directory / "草稿"]:
            assert digest(root / item["path"]) == item["sha256"], item["path"]

        source = project / item["path"]
        assert len(re.findall(r'^test "', source.read_text(), re.MULTILINE)) == item["tests"]

    assert sum(item["tests"] for item in manifest["inputs"]) == manifest["tests"] == 62
    assert manifest["new_declaration_counts"] == {"growth": 10, "prefix": 9, "propagation": 34, "resources": 9}


fixed_inputs(baseline)
fixed_inputs(integrated)
assert baseline["inputs"] == integrated["inputs"]

expectations = {
    "Debug": (baseline, 29, [34, 9, 10, 9]),
    "ReleaseSafe": (baseline, 29, [34, 9, 10, 9]),
    "相邻Debug": (baseline, 39, [5, 8, 2, 3, 12, 15, 24, 3]),
    "合并Debug": (integrated, 48, [5, 8, 2, 3, 12, 15, 24, 3, 34, 9, 10, 9]),
    "合并ReleaseSafe": (integrated, 29, [34, 9, 10, 9]),
}

for label, (manifest, steps, leaves) in expectations.items():
    result = json.loads((directory / (label + "执行结果.json")).read_text())
    log = directory / (label + "原始日志.txt")
    text = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", text)
    observed = [int(item[1]) for item in re.finditer(r"\brun test\b[^\n]*? (\d+) pass \((\d+) total\)", text)]

    assert result["terminal_exit_code"] == 0
    assert result["source"] == manifest["source"] and result["inputs"] == manifest["inputs"]
    assert digest(log) == result["log_sha256"]
    assert summary and int(summary[1]) == int(summary[2]) == steps
    assert int(summary[3]) == int(summary[4]) == sum(leaves)
    assert observed == leaves == result["leaf_declaration_counts"]
    assert result["actual_test_steps"] == len(leaves)
    assert result["actual_test_passes"] == sum(leaves) and result["build_steps"] == steps
    assert result["cached_test_steps"] == 0
    assert not re.search(r"\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)", text)
    assert result["new_unique_declarations"] == (0 if label == "相邻Debug" else 62)

outputs = json.loads((directory / "产物清单.json").read_text())
assert len(outputs) == 12

for name, output in outputs.items():
    assert digest(directory / name) == digest(Path(output["build_output_path"])) == output["sha256"]

for left, right in [("Debug", "ReleaseSafe"), ("合并Debug", "合并ReleaseSafe")]:
    for name in ["type_query", "query_abi", "parser_options"]:
        assert digest(directory / "生成产物" / left / (name + ".txt")) == digest(directory / "生成产物" / right / (name + ".txt"))

comparison = json.loads((directory / "生成对照.json").read_text())

for label in ["Debug", "ReleaseSafe", "合并Debug", "合并ReleaseSafe"]:
    source = (directory / "生成产物" / label / "type_query.txt").read_text()
    imports = sorted(set(re.findall(r'@import\("([^"\n]+)"\)', source)))

    assert imports == comparison[label]["imports"] == ["integers", "std", "zxc_abi"]
    assert source.count("ArrayList(bool)") == comparison[label]["array_list_bool"] == 1
    assert source.count(".deinit(") == comparison[label]["deinit"] == 1
    assert source.count(".toOwnedSlice(") == comparison[label]["toOwnedSlice"] == (0 if label.startswith("合并") else 1)
    assert "generated_parser: bool = true" in (directory / "生成产物" / label / "parser_options.txt").read_text()

first = json.loads((directory / "首次探测结果.json").read_text())
assert first["terminal_exit_code"] == 0 and first["tests"] == 61
assert digest(directory / "首次Debug探测.txt") == first["log_sha256"]
assert "61/61 tests passed" in (directory / "首次Debug探测.txt").read_text()
assert json.loads((directory / "首次输入清单.json").read_text())["tests"] == 61
assert all(item["exit_code"] == 0 for item in json.loads((directory / "源码检查.json").read_text()))
matrix = json.loads((directory / "目录矩阵原始报告.txt").read_text())
assert matrix["catalog_cases"] == 80625 and matrix["unreviewed"] == 50869

print(json.dumps({"new_unique_declarations": 62, "baseline_passes_per_mode": 62, "adjacent_passes": 72, "integrated_debug_passes": 134, "integrated_safe_passes": 62, "cached_test_steps": 0, "inputs_verified": len(baseline["inputs"])}, ensure_ascii=False))
