from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())

assert len(baseline["inputs"]) == 5317

for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"]

names = {f"loop-initial-{name}-{route}" for name in ["map", "filter", "local", "nested", "tuple", "shared", "borrowed", "repeated"] for route in ["source", "library"]}

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "证据.json")).read_text())

    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["includes_uncommitted_test_drafts"] is True
    assert evidence["exit_code"] == 0 and evidence["passed"] is True
    assert evidence["steps_passed"] == evidence["steps_total"] == 78
    assert evidence["tests_passed"] == evidence["tests_total"] == 128
    assert len(evidence["logged_zig_test_binaries"]) == 16
    assert {Path(item["path"]).name for item in evidence["logged_zig_test_binaries"]} == names
    assert evidence["errors"] == []

    raw = (doc / evidence["log"]).read_bytes()

    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]

    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

    for item in evidence["artifacts"]:
        data = (doc / item["saved"]).read_bytes()

        assert hashlib.sha256(data).hexdigest() == item["sha256"]
        assert Path(item["executed_source"]).read_bytes() == data

observation = json.loads((doc / "分配观察证据.json").read_text())
assert observation["compile_exit_code"] == observation["execution_exit_code"] == 0
assert hashlib.sha256(Path(observation["binary"]).read_bytes()).hexdigest() == observation["binary_sha256"]
assert hashlib.sha256(Path(observation["program"]).read_bytes()).hexdigest() == observation["program_sha256"]

print("PASS: frozen 5317 inputs; all 32 actual ownership consumers, 256 checks; allocator-control observation verified")
