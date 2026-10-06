import hashlib
import json
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
previous = json.loads((doc / "输入清单.json").read_text())
repaired = json.loads((doc / "修复输入清单.json").read_text())
paths = json.loads((doc / "提交路径清单.json").read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert len(previous["inputs"]) == 37 and len(repaired["inputs"]) == len(paths) == 27
assert {item["path"] for item in repaired["inputs"]} == set(paths)
old_hashes = {item["path"]: item["sha256"] for item in previous["inputs"]}
assert all(old_hashes[item["path"]] == item["sha256"] for item in repaired["inputs"])
for manifest in [previous, repaired]:
    fixed = Path(manifest["cwd"]).parents[1]
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=fixed, text=True).strip() == manifest["source"]
    assert subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=fixed, text=True).strip() == manifest["source_tree"]
    status = subprocess.check_output(["git", "status", "--porcelain", "-z", "--untracked-files=all"], cwd=fixed).decode().split("\0")
    assert {line[3:] for line in status if line} == {item["path"] for item in manifest["inputs"]}
    for item in manifest["inputs"]:
        for parent in [root, fixed, doc / "草稿"]:
            assert digest(parent / item["path"]) == item["sha256"], item["path"]

measured = {}
for label, manifest in [("Debug", previous), ("ReleaseSafe", previous), ("修复Debug", repaired), ("修复ReleaseSafe", repaired)]:
    result = json.loads((doc / (label + "执行结果.json")).read_text())
    raw = (doc / (label + "原始日志.txt")).read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded(?: \(\d+ failed\))?; (\d+)/(\d+) tests passed", raw)
    assert summary
    leaves = [{"name": item[1], "passes": int(item[2]), "failures": int(item[3] or 0), "total": int(item[4])} for item in re.finditer(r"run test (\S+) (\d+) pass(?:, (\d+) fail)? \((\d+) total\)", raw[summary.start():])]
    assert sum(item["passes"] for item in leaves) == int(summary[3])
    assert sum(item["total"] for item in leaves) == int(summary[4])
    assert not re.search(r"\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)", raw)
    assert result["source"] == manifest["source"] and result["source_tree"] == manifest["source_tree"]
    assert result["inputs"] == manifest["inputs"] and result["cwd"] == manifest["cwd"]
    expected = {"detached-reader-" + mode + "-" + route: 8 for mode in ["object", "tuple", "optional", "projection", "nested", "concat", "reference", "reverse"] for route in ["source", "library"]}
    if label.startswith("修复"):
        assert result["exit_code"] == 0 and int(summary[1]) == int(summary[2])
        assert int(summary[3]) == int(summary[4]) == 128 and len(leaves) == 16
        assert all(item["failures"] == 0 for item in leaves)
    else:
        expected.update({"arrow-bodies-cases": 60, **{"arrow-bodies-returns-" + name: 18 for name in ["increment", "square", "object_key"]}})
        assert result["exit_code"] == 1 and int(summary[3]) == 240 and int(summary[4]) == 242 and len(leaves) == 20
        assert {item["name"] for item in leaves if item["failures"]} == {"detached-reader-nested-source", "detached-reader-nested-library"}
        assert sum(item["failures"] for item in leaves) == 2
    assert {item["name"]: item["total"] for item in leaves} == expected
    measured[label] = {"exit_code": result["exit_code"], "successful_steps": int(summary[1]), "total_steps": int(summary[2]), "actual_passes": int(summary[3]), "actual_total": int(summary[4]), "leaves": leaves, "cached_test_steps": 0, "log_sha256": digest(doc / (label + "原始日志.txt"))}

outputs = json.loads((doc / "产物清单.json").read_text())
assert len(outputs) == 128
for name, item in outputs.items():
    assert digest(doc / name) == item["sha256"]
    assert item["tested_output_paths"] and all(digest(Path(path)) == item["sha256"] for path in item["tested_output_paths"])
for mode in ["object", "tuple", "optional", "projection", "nested", "concat", "reference", "reverse"]:
    for first, second in [("Debug", "ReleaseSafe"), ("修复Debug", "修复ReleaseSafe")]:
        for name in ["source", "source_abi", "library", "library_abi"]:
            assert digest(doc / "生成产物" / first / mode / (name + ".txt")) == digest(doc / "生成产物" / second / mode / (name + ".txt"))
    for label in ["Debug", "ReleaseSafe", "修复Debug", "修复ReleaseSafe"]:
        assert digest(doc / "生成产物" / label / mode / "source_abi.txt") == digest(doc / "生成产物" / label / mode / "library_abi.txt")
        for route in ["source", "library"]:
            source = (doc / "生成产物" / label / mode / (route + ".txt")).read_text()
            assert set(re.findall(r'@import\("([^"\n]+)"\)', source)) == {"std", "zxc_abi"}
            if mode == "nested":
                calls = re.findall(r"function_\d+_buffered\(", source)
                if label.startswith("修复"):
                    assert len(calls) >= 2
                else:
                    assert len(calls) == 0
for name, item in json.loads((doc / "失效产物清单.json").read_text()).items():
    assert digest(doc / name) == item["sha256"]
replays = json.loads((doc / "生成重放记录.json").read_text())
assert len(replays) == 32 and all(item["exit_code"] == 0 for item in replays)
for name in ["增长核查结果.json", "修复增长核查结果.json"]:
    growth = json.loads((doc / name).read_text())
    assert len(growth) == 10 and all(item["exit_code"] == 0 for item in growth)
    for item in growth:
        assert digest(Path(item["argv"][0])) == item["binary_sha256"]
        if name.startswith("修复"):
            assert digest(doc / "草稿/核查/growth_probe.zig") == item["probe_source_sha256"]
        label = "修复ReleaseSafe" if name.startswith("修复") else "ReleaseSafe"
        assert item["program_source_sha256"] == outputs["生成产物/" + label + "/" + item["mode"] + "/source.txt"]["sha256"]
foreign = json.loads((doc / "原有修改清单.json").read_text())
assert len(foreign) == 11 and all(digest(root / item["path"]) == item["sha256"] for item in foreign)
matrix = json.loads((doc / "目录矩阵原始报告.txt").read_text())
assert matrix["catalog_cases"] == 82989 and matrix["unreviewed"] == 50776
result_path = doc / "门禁核对结果.json"
if not result_path.exists() or json.loads(result_path.read_text()) != measured:
    result_path.write_text(json.dumps(measured, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"source": repaired["source"], "identical_inputs": len(paths), "actual_tests_per_mode": 128, "raw_outputs": len(outputs), "old_failures_per_mode": 2}))
