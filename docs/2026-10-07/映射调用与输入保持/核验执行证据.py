from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
fingerprints = json.loads((doc / "执行源码指纹.json").read_text())
base = json.loads((doc / "开始基线.json").read_text())

for item in fingerprints["inputs"] + base["preserved_outputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

source = (doc / "上游原文.js.txt").read_bytes()
original = json.loads((doc / "上游原文执行证据.json").read_text())
assert hashlib.sha256(source).hexdigest() == original["sha256"] == "23922dd9f5638f24fd122946a44fa67866ef0341976d34d219540880b9c09060"
assert original["assertion_count"] == 10
assert len(original["executions"]) == 2
assert [run["strict"] for run in original["executions"]] == [False, True]
for run in original["executions"]:
    assert len(run["assertions"]) == 5
    assert [item["actual"] for item in run["assertions"]] == [1, 2, 3, 4, 4]
    assert all(item["actual"] == item["expected"] for item in run["assertions"])

rows = [json.loads(line) for line in (root / "packages/test/tests/built_ins/list/predicates/observations/map.jsonl").read_text().splitlines()]
assert len(rows) == 59 and len({row["id"] for row in rows}) == 59
upstream = next(row for row in rows if row["id"].endswith("/original_unchanged"))
assert upstream["input"] == [1, 2, 3, 4]
assert upstream["probe"] == {"rule": "above", "threshold": 2, "value": False, "failure": 0}
assert upstream["expected"] == {"value": [False, False, True, True], "calls": 4, "visited": [1, 2, 3, 4], "input": [1, 2, 3, 4]}
review_path = "packages/test/upstream/reviews/built_ins/array/predicate_native.jsonl"
previous = (doc / "原始文件" / (review_path + ".txt")).read_bytes()
current = (root / review_path).read_bytes()
assert current.startswith(previous)
added = [json.loads(line) for line in current[len(previous):].splitlines()]
assert len(added) == 1 and added[0]["status"] == "adapted"
assert added[0]["sha256"] == original["sha256"]
assert added[0]["cases"] == [upstream["id"]]
assert {item["field"]: item["expected"] for item in added[0]["assertions"]} == upstream["expected"]

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "门禁证据.json")).read_text())
    assert evidence["exit_code"] == 0 and evidence["zig_tests"] == 464 and evidence["node_test_blocks"] == 6
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["summary"].encode() in raw
    assert len(evidence["runs"]) == 6
    assert {(run["method"], run["route"]) for run in evidence["runs"]} == {(method, route) for method in ["every", "some", "map"] for route in ["source", "library"]}
    for run in evidence["runs"]:
        execution = json.loads((doc / run["execution"]).read_text())
        assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
        assert (execution["native_identity"] is None) == (run["route"] == "source")
        log = (doc / run["log"]).read_bytes()
        assert hashlib.sha256(log).hexdigest() == run["log_sha256"]
        assert f"All {run['tests']} tests passed".encode() in log
        for artifact in run["artifacts"]:
            data = (doc / artifact["saved"]).read_bytes()
            assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
            assert data == Path(artifact["executed_source"]).read_bytes()

for item in base["inputs"]:
    assert (doc / "草稿" / item["path"]).read_bytes() == (root / item["path"]).read_bytes()

matrix = json.loads((doc / "矩阵审计.json").read_text())
assert matrix["catalog_cases"] == 128424 and matrix["unreviewed"] == 50634
print("PASS: original five assertions, unchanged every/some outputs, 59 map cases, both routes and modes, 928 Zig checks, exact source fingerprints")
