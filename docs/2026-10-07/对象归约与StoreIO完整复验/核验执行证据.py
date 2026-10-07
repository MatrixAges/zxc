from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
assert len(baseline["inputs"]) == 5274
for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "执行证据.json")).read_text())
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["exit_code"] == 1 and evidence["passed"] is False
    assert evidence["steps_passed"] == 102 and evidence["steps_total"] == 105
    assert evidence["zig_tests_passed"] == 188 and evidence["zig_tests_total"] == 192
    assert evidence["store_zig_tests"] == 39 and evidence["node_test_blocks"] == 7
    assert evidence["cached_summary_entries"] == 23
    assert len(evidence["binaries"]) == 20
    assert len({binary["path"] for binary in evidence["binaries"]}) == 20
    log = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(log).hexdigest() == evidence["log_sha256"]
    assert evidence["summary"].encode() in log
    assert sum("'capacity.test." in error["text"] for error in evidence["errors"]) == 4
    for binary in evidence["binaries"]:
        assert hashlib.sha256(Path(binary["path"]).read_bytes()).hexdigest() == binary["sha256"]
    for artifact in evidence["artifacts"]:
        raw = (doc / artifact["saved"]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == artifact["sha256"]
        assert raw == Path(artifact["executed_source"]).read_bytes()
    assert len(evidence["store_runs"]) == 7
    assert {(run["mode"], run["test"]) for run in evidence["store_runs"]} == {(store_mode, test_name) for store_mode in ["write", "service"] for test_name in ["continuity_test", "failure_test", "allocation_test"]} | {("readonly", "readonly_test")}
    for run in evidence["store_runs"]:
        raw = (doc / run["log"]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == run["log_sha256"]
        assert f"All {run['tests']} tests passed".encode() in raw
        assert "ℹ pass 1".encode() in raw and b"not ok" not in raw

runs = json.loads((doc / "嵌套归约当前复现.json").read_text())
assert len(runs) == 4
assert {(run["mode"], Path(run["binary"]["path"]).name) for run in runs} == {(mode, name) for mode in ["Debug", "ReleaseSafe"] for name in ["object-reduce-nested-source", "object-reduce-nested-library"]}
for run in runs:
    assert run["exit_code"] == 1 and run["observed_count"] == 128
    raw = (doc / run["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == run["log_sha256"]
    assert b"8 passed; 0 skipped; 2 failed" in raw
    assert len(run["statistics"]) == 2
    for item in run["statistics"]:
        assert item["count"] == 128 and item["capacity"] > 4096
        assert f"capacity={item['capacity']} allocated={item['allocated']} allocations={item['allocations']}".encode() in raw
    assert hashlib.sha256(Path(run["binary"]["path"]).read_bytes()).hexdigest() == run["binary"]["sha256"]

print("PASS: unchanged 5274 package files; both complete original aggregate failures recorded; 78 Store IO checks passed; exact four current capacity reproductions")
