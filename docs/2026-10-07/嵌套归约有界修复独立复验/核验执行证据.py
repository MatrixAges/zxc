from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
assert len(baseline["inputs"]) == 5292
for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "证据.json")).read_text())
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["exit_code"] == 0 and evidence["passed"] is True
    assert evidence["steps_passed"] == evidence["steps_total"] == 92
    assert evidence["tests_passed"] == evidence["tests_total"] == 192
    assert len(evidence["logged_zig_test_binaries"]) == 20
    assert len({binary["path"] for binary in evidence["logged_zig_test_binaries"]}) == 20
    assert evidence["errors"] == []
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["summary"].encode() in raw
    names = {Path(binary["path"]).name for binary in evidence["logged_zig_test_binaries"]}
    assert names == {f"object-reduce-{name}-{route}" for name in ["plain", "spread", "select", "nested", "field_call", "escape_call", "root_call", "nested_object", "checked", "initial_call"] for route in ["source", "library"]}
    for binary in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(binary["path"]).read_bytes()).hexdigest() == binary["sha256"]
    for artifact in evidence["artifacts"]:
        data = (doc / artifact["saved"]).read_bytes()
        assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
        assert data == Path(artifact["executed_source"]).read_bytes()

print("PASS: unchanged 5292 package files; both original full object-reduce gates; all 40 native binaries and 384 checks passed without changing thresholds")
