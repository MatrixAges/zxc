from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
assert len(baseline["inputs"]) == 5270

for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

zig_tests = 0
process_checks = 0
node_blocks = 0

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{mode}执行证据.json").read_text())
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["exit_code"] == 0
    assert evidence["zig_tests"] == 26 and evidence["process_checks"] == 46
    assert evidence["node_iterate_test_blocks"] == 5
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["summary"].encode() in raw
    assert b"52/52 steps succeeded; 26/26 tests passed" in raw
    assert b"Process application entry: 46 checks passed" in raw
    assert "ℹ pass 5".encode() in raw
    assert evidence["cli_binaries"] and len(evidence["test_binaries"]) == 5

    for binary in evidence["test_binaries"] + evidence["cli_binaries"]:
        assert hashlib.sha256(Path(binary["path"]).read_bytes()).hexdigest() == binary["sha256"]

    for artifact in evidence["artifacts"]:
        data = (doc / artifact["saved"]).read_bytes()
        assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
        assert data == Path(artifact["executed_source"]).read_bytes()

    zig_tests += evidence["zig_tests"]
    process_checks += evidence["process_checks"]
    node_blocks += evidence["node_iterate_test_blocks"]

assert zig_tests == 52 and process_checks == 92 and node_blocks == 10
print("PASS: unchanged 5270 package files; both original aggregate gates; 52 Zig tests, 92 Process checks and 10 Node test blocks")
