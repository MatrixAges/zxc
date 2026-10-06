import hashlib
import json
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
manifest = json.loads((doc / "输入清单.json").read_text())
fixed = Path(manifest["cwd"]).parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for file in ["输入清单.json", "最终输入清单.json"]:
    manifest = json.loads((doc / file).read_text())
    fixed = Path(manifest["cwd"]).parents[1]
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=fixed, text=True).strip() == manifest["source"]
    assert subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=fixed, text=True).strip() == manifest["source_tree"]
    status = subprocess.check_output(["git", "status", "--porcelain", "-z", "--untracked-files=all"], cwd=fixed).decode().split("\0")
    assert {line[3:] for line in status if line} == {item["path"] for item in manifest["inputs"]}
    assert len(manifest["inputs"]) == 15
    for item in manifest["inputs"]:
        for parent in [fixed, root, doc / "草稿"]:
            assert digest(parent / item["path"]) == item["sha256"], item["path"]

counts = json.loads((doc / "用例计数.json").read_text())
assert counts["frontend"] == 26
assert sum(item["total"] for item in counts["runtime"].values()) == 2037
assert sum(item["errors"] for item in counts["runtime"].values()) == 738
for name, count in counts["runtime"].items():
    rows = list(map(json.loads, (root / ("packages/test/tests/built_ins/list/range_extract/" + name + "/cases.jsonl")).read_text().splitlines()))
    assert len(rows) == len({item["id"] for item in rows}) == count["total"]
    assert sum("error" in row["expected"] for row in rows) == count["errors"]

measured = {}
for label in ["Debug", "ReleaseSafe", "相邻Debug", "最终Debug", "最终ReleaseSafe", "最终相邻Debug"]:
    manifest = json.loads((doc / ("最终输入清单.json" if label.startswith("最终") else "输入清单.json")).read_text())
    result = json.loads((doc / (label + "执行结果.json")).read_text())
    log = doc / (label + "原始日志.txt")
    text = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", text)
    leaves = [int(item[1]) for item in re.finditer(r"\brun test\b[^\n]*? (\d+) pass \((\d+) total\)", text)]
    assert result["exit_code"] == 0 and result["cwd"] == manifest["cwd"]
    assert result["source"] == manifest["source"] and result["source_tree"] == manifest["source_tree"] and result["inputs"] == manifest["inputs"]
    assert summary and int(summary[1]) == int(summary[2])
    assert int(summary[3]) == int(summary[4]) == sum(leaves)
    assert not re.search(r"\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)", text)
    if "相邻" not in label:
        assert sorted(leaves) == [26, 288, 288, 288, 288, 309, 576]
    else:
        assert sorted(leaves) == [1, 1, 2, 3, 8, 11, 28, 82]
    measured[label] = {"steps": int(summary[1]), "actual_passes": sum(leaves), "leaves": leaves, "cached_test_steps": 0, "log_sha256": digest(log)}

original = json.loads((doc / "原文三方核对.json").read_text())
assert len(original["checks"]) == 64 and digest(Path(original["archive"])) == original["archive_sha256"]
assert all(item["archive_matches"] and item["index_matches"] for item in original["checks"])
reviews = list(map(json.loads, (root / "packages/test/upstream/reviews/built_ins/array/slice_remaining.jsonl").read_text().splitlines()))
assert len(reviews) == 64
assert {r["path"]: r["sha256"] for r in reviews} == {r["path"]: r["sha256"] for r in original["checks"]}
assert all(r["status"] == "excluded" and r["cases"] == [] and r["reason"] and r["contract"] for r in reviews)
host = json.loads((doc / "原文结果.json").read_text())
assert host["files"] == 64 and host["executions"] == len(host["results"]) == 128
assert len({(r["path"], r["strict"]) for r in host["results"]}) == 128
assert all(r["passed"] for r in host["results"])

outputs = json.loads((doc / "产物清单.json").read_text())
assert len(outputs) == 48
for name, item in outputs.items():
    assert digest(doc / name) == digest(Path(item["build_output_path"])) == item["sha256"]
for prefix in ["", "最终"]:
    for name in counts["runtime"]:
        for kind in ["program", "cases"]:
            assert digest(doc / ("生成产物/" + prefix + "Debug") / name / (kind + ".txt")) == digest(doc / ("生成产物/" + prefix + "ReleaseSafe") / name / (kind + ".txt"))
        generated = (doc / ("生成产物/" + prefix + "Debug") / name / "program.txt").read_text()
        assert set(re.findall(r'@import\("([^"\n]+)"\)', generated)) == {"std"}
        assert "return error.IndexOutOfBounds" in generated and " or " in generated
        cases = (doc / ("生成产物/" + prefix + "Debug") / name / "cases.txt").read_text()
        rows = list(map(json.loads, (root / ("packages/test/tests/built_ins/list/range_extract/" + name + "/cases.jsonl")).read_text().splitlines()))
        assert re.findall(r'^test "([^"\n]+)"', cases, re.MULTILINE) == [r["id"] for r in rows]
        assert "18446744073709551615" in cases

foreign = json.loads((doc / "原有修改清单.json").read_text())
assert all(digest(root / item["path"]) == item["sha256"] for item in foreign)
matrix = json.loads((doc / "目录矩阵原始报告.txt").read_text())
assert matrix["catalog_cases"] == 82935 and matrix["unreviewed"] == 50779
assert matrix["reviewed"] == {"adapted": 752, "equivalent": 103, "excluded": 1963}
result_path = doc / "门禁核对结果.json"
if not result_path.exists() or json.loads(result_path.read_text()) != measured:
    result_path.write_text(json.dumps(measured, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"new_cases": 2063, "reviewed": 64, "host_executions": 128, "actual_tests": measured}, ensure_ascii=False))
