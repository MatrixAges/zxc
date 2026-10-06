import hashlib
import json
from pathlib import Path
import re
import subprocess
import tarfile


directory = Path(__file__).resolve().parent
project = directory.parents[2]
baseline = json.loads((directory / "输入清单.json").read_text())
final = json.loads((directory / "最终输入清单.json").read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for manifest in [baseline, final]:
    fixed = Path(manifest["cwd"])

    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=fixed, text=True).strip() == manifest["source"]
    assert subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=fixed, text=True).strip() == manifest["source_tree"]
    status = subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=all"], cwd=fixed, text=True)
    assert {line[3:] for line in status.splitlines()} == {item["path"] for item in manifest["inputs"]}

    for item in manifest["inputs"]:
        for root in [fixed, project, directory / "草稿"]:
            assert digest(root / item["path"]) == item["sha256"], item["path"]

    assert len(manifest["inputs"]) == 14
    assert sum(manifest["cases"].values()) == manifest["new_unique_cases"] == 247

    for name, count in manifest["cases"].items():
        assert len((project / name).read_text().splitlines()) == count

assert baseline["inputs"] == final["inputs"]
assert sorted(final["cases"].values()) == [16, 16, 19, 30, 66, 100]

for label, manifest, steps, leaves in [
    ("首次Debug", baseline, 54, [19, 100, 66, 30, 16, 16]),
    ("Debug", final, 54, [19, 100, 66, 30, 16, 16]),
    ("ReleaseSafe", final, 54, [19, 100, 66, 30, 16, 16]),
    ("相邻Debug", final, 34, [4]),
]:
    result = json.loads((directory / (label + "执行结果.json")).read_text())
    log = directory / (label + "原始日志.txt")
    text = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", text)
    observed = [int(item[1]) for item in re.finditer(r"\brun test\b[^\n]*? (\d+) pass \((\d+) total\)", text)]

    assert result["terminal_exit_code"] == 0
    assert result["source"] == manifest["source"] and result["inputs"] == manifest["inputs"]
    assert digest(log) == result["log_sha256"]
    assert summary and int(summary[1]) == int(summary[2]) == result["build_steps"] == steps
    assert int(summary[3]) == int(summary[4]) == result["actual_test_passes"] == sum(leaves)
    assert observed == result["leaf_declaration_counts"] == leaves
    assert result["cached_test_steps"] == 0
    assert not re.search(r"\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)", text)
    assert result["new_unique_cases"] == (0 if label == "相邻Debug" else 247)

inventory = json.loads((directory / "原文核对.json").read_text())
lock = json.loads((project / "packages/test/upstream/lock.json").read_text())
assert inventory["revision"] == lock["revision"]
assert digest(Path(inventory["archive"])) == inventory["archive_sha256"] == lock["archive_sha256"]
indexed = {item["path"]: item["sha256"] for item in map(json.loads, (project / "packages/test/upstream/index/built-ins.jsonl").read_text().splitlines())}
reviews = list(map(json.loads, (project / "packages/test/upstream/reviews/built_ins/string/index.jsonl").read_text().splitlines()))
assert len(reviews) == len(inventory["files"]) == 26
assert {item["path"] for item in reviews} == {item["path"] for item in inventory["files"]}

with tarfile.open(inventory["archive"]) as archive:
    prefix = archive.getmembers()[0].name.split("/")[0]

    for item in reviews:
        path = Path(inventory["source_root"]) / item["path"]

        assert digest(path) == item["sha256"] == indexed[item["path"]]
        assert archive.extractfile(prefix + "/" + item["path"]).read() == path.read_bytes()
        assert item["status"] == "excluded" and item["cases"] == []
        assert item["reason"] and item["contract"]

host = json.loads((directory / "原文结果.json").read_text())
metadata = json.loads((directory / "原文元数据.json").read_text())
assert host["files"] == 26 and host["executions"] == len(host["results"]) == 52
assert host["revision"] == inventory["revision"]
assert all(item["passed"] and item["sha256"] == indexed[item["path"]] for item in host["results"])
assert len({(item["path"], item["strict"]) for item in host["results"]}) == 52
assert {item["path"] for item in metadata} == {item["path"] for item in reviews}
assert all(item["flags"] == [] for item in metadata)

outputs = json.loads((directory / "产物清单.json").read_text())
assert len(outputs) == 22

for name, item in outputs.items():
    assert digest(directory / name) == digest(Path(item["build_output_path"])) == item["sha256"]

for name in ["bytes", "decoded", "composed", "logical_and", "logical_or"]:
    for kind in (["program", "cases", "abi"] if name == "decoded" else ["program", "cases"]):
        assert digest(directory / "生成产物/Debug" / name / (kind + ".txt")) == digest(directory / "生成产物/ReleaseSafe" / name / (kind + ".txt"))

    source = (directory / "生成产物/Debug" / name / "program.txt").read_text()
    imports = set(re.findall(r'@import\("([^"\n]+)"\)', source))
    assert imports == ({"std", "zxc_standard", "zxc_abi"} if name == "decoded" else {"std"})
    assert "return error.IndexOutOfBounds" in source
    ids = re.findall(r'^test "([^"\n]+)"', (directory / "生成产物/Debug" / name / "cases.txt").read_text(), re.MULTILINE)
    rows = list(map(json.loads, (project / ("packages/test/tests/built_ins/string/index/" + name + "/cases.jsonl")).read_text().splitlines()))
    assert ids == [item["id"] for item in rows]

assert ".index = 18446744073709551615" in (directory / "生成产物/Debug/bytes/cases.txt").read_text()
assert "(in).read and " in (directory / "生成产物/Debug/logical_and/program.txt").read_text()
assert "(!(in).read) or " in (directory / "生成产物/Debug/logical_or/program.txt").read_text()
assert all(item["exit_code"] == 0 for item in json.loads((directory / "源码检查.json").read_text()))
matrix = json.loads((directory / "目录矩阵原始报告.txt").read_text())
assert matrix["catalog_cases"] == 80872 and matrix["unreviewed"] == 50843
assert matrix["reviewed"] == {"equivalent": 103, "adapted": 752, "excluded": 1899}

print(json.dumps({"new_unique_cases": 247, "runtime_cases": 228, "frontend_cases": 19, "reviewed_files": 26, "host_executions": 52, "actual_passes_per_mode": 247, "adjacent_passes": 4, "generated_files": 22, "unreviewed": 50843}, ensure_ascii=False))
