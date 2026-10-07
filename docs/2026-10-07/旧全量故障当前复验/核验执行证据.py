from pathlib import Path
import hashlib
import json
import sys

snapshot = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
state = json.loads((doc / "运行状态.json").read_text())

for item in baseline["inputs"]:
    assert hashlib.sha256((snapshot / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

assert state["source_commit"] == baseline["source_commit"]
assert state["packages_tree"] == baseline["packages_tree"]

for label, expected in [("ScannerDebug", (18, 11, 5)), ("ScannerReleaseSafe", (18, 11, 5)), ("CompilerDebug", (28, 372, 3)), ("CompilerReleaseSafe", (28, 372, 3))]:
    steps, tests, binaries = expected
    evidence = json.loads((doc / f"{label}证据.json").read_text())

    assert state["gates"][label]["exit_code"] == evidence["exit_code"] == 0
    assert evidence["passed"] and not evidence["errors"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["steps_passed"] == evidence["steps_total"] == steps
    assert evidence["tests_passed"] == evidence["tests_total"] == tests
    assert len(evidence["logged_zig_test_binaries"]) == binaries
    assert hashlib.sha256((doc / evidence["log"]).read_bytes()).hexdigest() == evidence["log_sha256"]

    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

    for item in evidence["artifacts"]:
        assert hashlib.sha256((doc / item["saved"]).read_bytes()).hexdigest() == item["sha256"]
        assert hashlib.sha256(Path(item["executed_source"]).read_bytes()).hexdigest() == item["sha256"]

    if label.startswith("Compiler"):
        assert len(evidence["formal_parser_options"]) == 2
        for option in evidence["formal_parser_options"]:
            assert option["generated_parser"]
            assert hashlib.sha256(Path(option["path"]).read_bytes()).hexdigest() == option["sha256"]
        assert "run test zx-integration-tests 20 pass (20 total)" in (doc / evidence["log"]).read_text()

audit = json.loads((doc / "目录审查结果.json").read_text())
assert (audit["catalog_cases"], audit["unreviewed"], audit["reviewed"]["adapted"]) == (128467, 50631, 811)
print("PASS: current source identity, all 766 checks, 16 actual binaries and both original integration allocation checks")
