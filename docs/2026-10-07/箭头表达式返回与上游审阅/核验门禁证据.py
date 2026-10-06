import hashlib
import json
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
manifest = json.loads((doc / "输入清单.json").read_text())
fixed = Path(manifest["cwd"]).parents[1]
paths = json.loads((doc / "正式路径清单.json").read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert len(paths) == 10 and len(manifest["inputs"]) == 37
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=fixed, text=True).strip() == manifest["source"]
assert subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=fixed, text=True).strip() == manifest["source_tree"]
status = subprocess.check_output(["git", "status", "--porcelain", "-z", "--untracked-files=all"], cwd=fixed).decode().split("\0")
assert {line[3:] for line in status if line} == {item["path"] for item in manifest["inputs"]}
for item in manifest["inputs"]:
    for parent in [root, fixed]:
        assert digest(parent / item["path"]) == item["sha256"]
    if item["path"] in paths:
        assert digest(doc / "草稿" / item["path"]) == item["sha256"]

for label in ["箭头Debug", "箭头ReleaseSafe"]:
    result = json.loads((doc / (label + "执行结果.json")).read_text())
    raw = (doc / (label + "原始日志.txt")).read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", raw)
    assert result["exit_code"] == 0 and result["inputs"] == manifest["inputs"]
    assert result["source"] == manifest["source"] and result["source_tree"] == manifest["source_tree"]
    assert result["cwd"] == manifest["cwd"]
    assert summary and int(summary[1]) == int(summary[2]) == 46
    assert len(re.findall(r"run test \S+ cached", raw)) == 4

records = json.loads((doc / "实际执行结果.json").read_text())
assert len(records) == 8
for mode in ["Debug", "ReleaseSafe"]:
    selected = [item for item in records if item["mode"] == mode]
    assert len(selected) == 4 and sum(item["actual_passes"] for item in selected) == 114
    assert {item["actual_passes"] for item in selected} == {18, 60}
for item in records:
    raw = (doc / item["raw_log"]).read_text()
    rows = [json.loads(line) for line in (root / "packages/test/tests" / (item["suite"] + ".jsonl")).read_text().splitlines()]
    ids = {row["id"] for row in rows}
    assert item["exit_code"] == 0 and item["emit_exit_code"] == 0
    assert digest(Path(item["argv"][0])) == item["binary_sha256"]
    assert digest(doc / item["raw_log"]) == item["log_sha256"]
    assert set(item["case_ids"]) == ids and len(ids) == item["actual_passes"]
    assert set(re.findall(r"\d+/\d+ cases\.test\.(.+)\.\.\.OK", raw)) == ids
    assert "All " + str(len(ids)) + " tests passed." in raw
outputs = json.loads((doc / "产物清单.json").read_text())
assert len(outputs) == 16
for name, item in outputs.items():
    assert digest(doc / name) == item["sha256"]
    assert item["tested_output_paths"] and all(digest(Path(path)) == item["sha256"] for path in item["tested_output_paths"])
for kind in ["legacy", "increment", "square", "object_key"]:
    for name in ["program", "cases"]:
        assert digest(doc / "生成产物/Debug" / kind / (name + ".txt")) == digest(doc / "生成产物/ReleaseSafe" / kind / (name + ".txt"))
    source = (doc / "生成产物/Debug" / kind / "program.txt").read_text()
    assert set(re.findall(r'@import\("([^"\n]+)"\)', source)) == {"std"}
upstream = json.loads((doc / "上游原文清单.json").read_text())
assert len(upstream["cases"]) == 3
assert all(digest(doc / item["raw_path"]) == item["sha256"] for item in upstream["cases"])
node = json.loads((doc / "上游执行结果.json").read_text())
assert node["runs"] == len(node["records"]) == 6
assert all(item["status"] == "passed" and len(item["assertions"]) == 1 for item in node["records"])
foreign = json.loads((doc / "原有修改清单.json").read_text())
assert len(foreign) == 11 and all(digest(root / item["path"]) == item["sha256"] for item in foreign)
typecheck = json.loads((doc / "类型检查结果.json").read_text())
assert typecheck["exit_code"] == 0 and digest(root / typecheck["source"]) == typecheck["source_sha256"]
matrix = json.loads((doc / "目录矩阵原始报告.txt").read_text())
assert matrix["catalog_cases"] == 82989 and matrix["unreviewed"] == 50776
print(json.dumps({"formal_paths": len(paths), "new_catalog_cases": 54, "new_reviews": 3, "original_node_runs": node["runs"], "actual_tests_per_mode": 114, "raw_outputs": len(outputs)}))
