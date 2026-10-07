from pathlib import Path
import hashlib
import json
import re
import sys
import subprocess

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())

execution = Path(baseline["execution_root"])
assert subprocess.check_output(["git", "-C", str(execution), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"]

for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]
    assert hashlib.sha256((execution / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

state = json.loads((doc / "运行状态.json").read_text())

original = json.loads((doc / "上游原文执行证据.json").read_text())
assert hashlib.sha256((doc / "上游原文.js.txt").read_bytes()).hexdigest() == original["sha256"] == "aaf420899cff460dc57de5a7f30d014ca2e1b51ff6f63ec89b95babf617a795d"
harness = "\n".join((doc / "配套资源" / (name + ".txt")).read_text() for name in ["sta.js", "assert.js"])
assert hashlib.sha256(harness.encode()).hexdigest() == original["harness_sha256"]
assert original["assertion_count"] == 2
assert [item["strict"] for item in original["executions"]] == [False, True]

for item in original["executions"]:
    assert item["callback_formal_parameters"] == 0
    assert [entry["actual"] for entry in item["assertions"]] == [True]
    assert [entry["expected"] for entry in item["assertions"]] == [True]

catalogs = {}

for method, count in [("every", 88), ("some", 87), ("map", 59)]:
    path = "packages/test/tests/built_ins/list/predicates/observations/" + method + ".jsonl"
    rows = [json.loads(line) for line in (root / path).read_text().splitlines()]
    catalogs[method] = [item["id"] for item in rows]
    assert len(rows) == len(set(catalogs[method])) == count

    if method == "some":
        row = next(item for item in rows if item["id"].endswith("/original_zero_parameters"))
        assert row["input"] == [11, 12]
        assert row["probe"] == {"rule": "always", "threshold": 0, "value": True, "failure": 0}
        assert row["expected"] == {"value": True, "calls": 1, "visited": [11], "input": [11, 12]}

controls = json.loads((doc / "原断言与附加控制.json").read_text())
assert controls["upstream_assertions"] == [{"field":"value", "expected":True}]
assert controls["additional_zxc_controls"] == {"calls":1, "visited":[11], "input":[11,12]}

review = json.loads((doc / "审查更新身份.json").read_text())
previous = (doc / "原始文件" / (review["review_path"] + ".txt")).read_bytes()
published = (doc / "草稿" / review["review_path"]).read_bytes()
assert hashlib.sha256(previous).hexdigest() == review["executed_sha256"]
assert hashlib.sha256(published).hexdigest() == review["published_sha256"]
assert published.startswith(previous)
added = [json.loads(line) for line in published[len(previous):].splitlines()]
assert added == [review["record"]] and review["after_both_gate_exit_codes"] == [0, 0]
assert added[0]["status"] == "adapted" and added[0]["sha256"] == original["sha256"]
assert added[0]["cases"] == [row["id"]]
assert {item["field"]: item["expected"] for item in added[0]["assertions"]} == row["expected"]

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "门禁证据.json")).read_text())
    assert state["gates"][mode]["status"] == "terminal"
    assert state["gates"][mode]["exit_code"] == 0
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert len(evidence["formal_parser_options"]) == 1
    for option in evidence["formal_parser_options"]:
        assert option["generated_parser"]
        assert hashlib.sha256(Path(option["path"]).read_bytes()).hexdigest() == option["sha256"]
        assert hashlib.sha256((doc / option["saved"]).read_bytes()).hexdigest() == option["sha256"]
    assert evidence["exit_code"] == 0 and evidence["zig_tests"] == 468 and evidence["node_test_blocks"] == 6
    assert evidence["summary"] == "Build Summary: 38/38 steps succeeded"
    assert hashlib.sha256((doc / evidence["log"]).read_bytes()).hexdigest() == evidence["log_sha256"]
    assert len(evidence["runs"]) == 6
    assert {(item["method"], item["route"]) for item in evidence["runs"]} == {(method, route) for method in catalogs for route in ["source", "library"]}

    for run in evidence["runs"]:
        execution = json.loads((doc / run["execution"]).read_text())
        assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
        assert (execution["native_identity"] is None) == (run["route"] == "source")
        raw = (doc / run["log"]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == run["log_sha256"]
        observed = re.findall(r"^\d+/\d+ \S*\.test\.(.*?)\.\.\.OK$", raw.decode(), re.M)
        assert observed == run["test_names"] == catalogs[run["method"]]
        assert len(observed) == run["tests"]

        for item in run["artifacts"]:
            data = (doc / item["saved"]).read_bytes()
            assert hashlib.sha256(data).hexdigest() == item["sha256"]
            assert Path(item["executed_source"]).read_bytes() == data

before = json.loads((doc / "开始矩阵审计.json").read_text())
after = json.loads((doc / "矩阵审计.json").read_text())
assert (before["catalog_cases"], before["unreviewed"]) == (128467, 50631)
assert (after["catalog_cases"], after["unreviewed"]) == (128468, 50630)
assert after["reviewed"]["adapted"] == before["reviewed"]["adapted"] + 1
print("PASS: two original JS assertions, four native executions of the new some case, all 936 named predicate checks, frozen source and one adapted review")
