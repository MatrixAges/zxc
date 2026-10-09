from pathlib import Path

import hashlib
import itertools
import json
import re
import subprocess


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
root = Path(inputs["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
for group in ["packages", "formal_sha256"]:
    for name, identity in inputs[group].items():
        assert sha((root / name).read_bytes()) == identity, name
for group in ["tools", "external"]:
    for name, identity in inputs[group].items():
        assert sha(Path(name).read_bytes()) == identity, name
spacing = {item["source"]: item for item in json.loads((doc / "格式对齐.json").read_text())}
assert len(spacing) == 2
for source, item in spacing.items():
    old = (doc / item["executed_saved"]).read_bytes()
    current = Path(source).read_bytes()
    assert sha(old) == item["executed_sha256"]
    assert sha(current) == item["published_sha256"]
    assert item["only_blank_lines_changed"]
    assert [line for line in old.splitlines(keepends=True) if line.strip()] == [line for line in current.splitlines(keepends=True) if line.strip()]
for item in json.loads((doc / "证据清单.json").read_text()):
    if item["source"] in spacing:
        assert item["sha256"] == spacing[item["source"]]["executed_sha256"]
    else:
        assert sha(Path(item["source"]).read_bytes()) == item["sha256"]
    assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
assert len(generation["steps"]) == 6 and len(generation["generated"]) == 83
for step in generation["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
for group in ["generated", "tool_binaries"]:
    for path, identity in generation[group].items():
        assert sha(Path(path).read_bytes()) == identity
fixture = root / "packages/test/tests/collections/predicate_allocation"
expected = re.findall(r'^test "([^"\n]+)"', (fixture / "root.zig").read_text(), re.M)
assert len(expected) == 5
keys = set(itertools.product(["pointer", "value"], ["0", "1", "2", "17", "257", "4096"], ["0", "1", "2"], ["false", "true"]))
rows = []
program_bytes = {}
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 24 and len(state["steps"]) == 49
    assert state["named_executions"] == 120
    assert sha(Path(state["tool"]).read_bytes()) == state["tool_sha256"]
    for step in state["steps"]:
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
        assert "--test-no-exec" not in step["command"]
    for item in state["programs"]:
        assert item["names"] == expected and item["signature_verified"]
        assert item["exit_code"] in [0, 1]
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", item["binary"]], check=True, capture_output=True)
        for path, identity in item["files"].items():
            assert sha(Path(path).read_bytes()) == identity
            if path.endswith(".zig") and not path.endswith("options.zig"):
                key = (item["suite"], item["route"], Path(path).name)
                if mode == "Debug":
                    program_bytes[key] = Path(path).read_bytes()
                else:
                    assert program_bytes[key] == Path(path).read_bytes(), key
        observed = {(row["interface"], row["count"], row["pattern"], row["deny"]): row for row in item["observations"]}
        assert set(observed) == keys and len(item["observations"]) == 72
        failures = {}
        for interface in ["pointer", "value"]:
            normal = [row for row in observed.values() if row["interface"] == interface and row["deny"] == "false"]
            denied = [row for row in observed.values() if row["interface"] == interface and row["deny"] == "true"]
            assert all(row["succeeded"] == "true" and row["induced"] == "false" for row in normal)
            assert all(row["allocations"] == "0" and row["allocated_bytes"] == "0" for row in denied)
            failures[interface] = sum(row["succeeded"] != "true" or row["induced"] != "false" for row in denied)
            rows.append({"mode": mode, "suite": item["suite"], "route": item["route"], "interface": interface, "normal_allocations": sorted({int(row["allocations"]) for row in normal}), "normal_allocated_bytes": sorted({int(row["allocated_bytes"]) for row in normal}), "denied_failures": failures[interface], "observations": 36})
        failed_tests = sum(value != 0 for value in failures.values())
        assert (item["exit_code"] != 0) == (failed_tests != 0)
        label = item["suite"].replace("/", "-") + "-" + item["route"] + "-execute.txt"
        log = (run / mode / label).read_text()
        headers = list(re.finditer(r"\d+/5 .*?\.test\.(.+?)\.\.\.", log))
        for index, header in enumerate(headers):
            block = log[header.end():headers[index + 1].start() if index + 1 < len(headers) else len(log)]
            should_fail = index == 2 and failures["pointer"] != 0 or index == 3 and failures["value"] != 0
            assert ("FAIL (TestExpectedEqual)" in block) == should_fail
            if not should_fail:
                assert "OK" in block and "FAIL" not in block
        if failed_tests:
            assert f"{5 - failed_tests} passed; 0 skipped; {failed_tests} failed." in log
        else:
            assert "All 5 tests passed." in log
assert len(rows) == 96
assert all(row["denied_failures"] == 0 and row["normal_allocations"] == [0] and row["normal_allocated_bytes"] == [0] for row in rows)
registered = json.loads((run / "registered-execution.json").read_text())
assert registered["status"] == "terminal" and registered["exit_code"] == 0
assert registered["named_executions"] == 240 and len(registered["programs"]) == 48
for item in registered["programs"]:
    assert item["exit_code"] == 0 and item["signature_verified"]
    assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", item["binary"]], check=True, capture_output=True)
    for path, identity in item["files"].items():
        assert sha(Path(path).read_bytes()) == identity
    record = json.loads(Path(item["record"]).read_text())
    assert record["status"] == 0 and record["signal"] is None and record["error"] is None and record["names"] == expected
    assert "--test-no-exec" not in record["argv"]
    output = Path(item["record"]).with_suffix(".log").read_text()
    observed = [dict(re.findall(r"(\w+)=([\w]+)", line)) for line in output.split("\n") if "ALLOCATION interface=" in line]
    assert len(observed) == 72
    assert all(row["succeeded"] == "true" and row["allocations"] == "0" and row["allocated_bytes"] == "0" and row["induced"] == "false" for row in observed)
    assert "All 5 tests passed." in output
for item in json.loads((doc / "前期诊断清单.json").read_text()):
    assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
summary = {"source_commit": inputs["source_commit"], "formal_binaries": 48, "formal_named_executions": 240, "formal_observations": 3456, "independent_driver_binaries": 48, "independent_driver_named_executions": 240, "failing_interface_roots": sum(row["denied_failures"] != 0 for row in rows), "rows": rows}
summary_path = doc / "分配测量摘要.json"
if summary_path.exists():
    assert json.loads(summary_path.read_text()) == summary
else:
    summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=4) + "\n")
print("PASS: executed semantics, zero-allocation contract, signatures, generated identity and exact frozen inputs")
