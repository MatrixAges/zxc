from pathlib import Path
import hashlib
import json
import re
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
first = json.loads((doc / "首轮基线.json").read_text())

assert len(baseline["inputs"]) == len(first["inputs"]) == 5304

old = {item["path"]: item["sha256"] for item in first["inputs"]}
changed = []

for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"]

    if old[item["path"]] != item["sha256"]:
        changed.append(item["path"])

assert changed == ["packages/test/tests/collections/object_reduce/effects/main.zx"]

names = {f"object-reduce-{name}-{route}" for name in ["plain", "spread", "select", "nested", "subject", "field_call", "escape_call", "root_call", "nested_object", "checked", "initial_call"] for route in ["source", "library"]}
expected_tests = set()

for name in ["root.zig", "failure.zig"]:
    path = root / "packages/test/tests/collections/object_reduce/effects" / name
    expected_tests.update(re.findall(r'test "([^"]+)"', path.read_text()))

assert len(expected_tests) == 18

for mode in ["Debug", "ReleaseSafe"]:
    for label in ["首轮" + mode, mode]:
        evidence = json.loads((doc / (label + "证据.json")).read_text())

        assert evidence["source_commit"] == baseline["source_commit"]
        assert evidence["packages_tree"] == baseline["packages_tree"]
        assert evidence["includes_uncommitted_test_drafts"] is True

        raw = (doc / evidence["log"]).read_bytes()

        assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
        assert evidence["summary"].encode() in raw

        if label.startswith("首轮"):
            assert evidence["exit_code"] == 1 and evidence["passed"] is False
            assert evidence["steps_passed"] == 99 and evidence["steps_total"] == 105
            assert evidence["tests_passed"] == evidence["tests_total"] == 212
            assert {Path(item["path"]).name for item in evidence["logged_zig_test_binaries"]} == names
            assert b"naming: source 0, bytes 9..16: type names must use PascalCase" in raw
        else:
            assert evidence["exit_code"] == 0 and evidence["passed"] is True
            assert evidence["steps_passed"] == evidence["steps_total"] == 105
            assert evidence["tests_passed"] is None and evidence["tests_total"] is None
            assert evidence["cached_summary_entries"] == 99
            assert evidence["errors"] == []

        for item in evidence["logged_zig_test_binaries"]:
            assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

        for item in evidence["artifacts"]:
            data = (doc / item["saved"]).read_bytes()
            assert hashlib.sha256(data).hexdigest() == item["sha256"]
            assert Path(item["executed_source"]).read_bytes() == data

    children = json.loads((doc / (mode + "副作用证据.json")).read_text())

    assert len(children) == 2 and {item["route"] for item in children} == {"source", "library"}

    for child in children:
        assert child["checks"] == 18
        assert child["execution"]["status"] == 0
        assert child["execution"]["signal"] is None and child["execution"]["error"] is None
        assert hashlib.sha256(Path(child["binary"]).read_bytes()).hexdigest() == child["binary_sha256"]

        for item in child["artifacts"]:
            data = (doc / item["saved"]).read_bytes()
            assert hashlib.sha256(data).hexdigest() == item["sha256"]
            assert Path(item["original"]).read_bytes() == data

        raw = (doc / "执行物" / (mode + "-" + child["route"]) / "execution.log.txt").read_text()
        actual = set(re.findall(r"^\d+/18 \w+\.test\.(.*?)\.\.\.OK$", raw, re.M))

        assert actual == expected_tests
        assert "All 18 tests passed." in raw

print("PASS: frozen 5304 inputs; 424 original checks actually passed before import-only fixture correction; both final full gates; 72 new native checks in four real consumers")
