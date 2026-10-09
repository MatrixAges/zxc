from pathlib import Path

import hashlib
import json
import re
import struct
import subprocess


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
run = Path(inputs["run"])
root = Path(inputs["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
routes = ["source", "forward", "reverse", "rx_forward", "rx_reverse", "zx_forward", "zx_reverse", "republish_forward", "republish_reverse"]
for group in ["packages", "formal_sha256"]:
    for name, identity in inputs[group].items():
        assert sha((root / name).read_bytes()) == identity, name
for group in ["tools", "external"]:
    for name, identity in inputs[group].items():
        assert sha(Path(name).read_bytes()) == identity, name
for item in json.loads((doc / "证据清单.json").read_text()):
    assert sha(Path(item["source"]).read_bytes()) == item["sha256"]
    assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
for item in json.loads((doc / "失败诊断清单.json").read_text()):
    assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
for mode in ["Debug", "ReleaseSafe"]:
    failed = json.loads((doc / "前置诊断/首次执行" / (mode + "-execution.json.txt")).read_text())
    assert failed["status"] == "terminal" and failed["exit_code"] == 1 and not failed["programs"]
    assert [step["exit_code"] for step in failed["steps"]] == [0, 0, 1]
for check in json.loads((doc / "静态检查.json").read_text()):
    assert check["exit_code"] == 0
    if "path" in check and "sha256" in check:
        path = Path(check["path"])
        assert sha((path if path.is_absolute() else root / path).read_bytes()) == check["sha256"]
    if "log" in check:
        assert sha(Path(check["log"]).read_bytes()) == check["log_sha256"]
generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
assert len(generation["steps"]) == 6 and len(generation["generated"]) == 83
for step in generation["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
for group in ["generated", "tool_binaries"]:
    for path, identity in generation[group].items():
        assert sha(Path(path).read_bytes()) == identity
all_names = set()
suites = {}
new_count = 0
for suite in inputs["suites"]:
    suites[suite["key"]] = suite
    source = root / ("packages/test/tests/" + suite["path"] + ".rx")
    rows = [json.loads(line) for line in source.with_suffix(".jsonl").read_text().split("\n") if line.strip()]
    assert len(rows) == suite["count"]
    for row in rows:
        assert row["id"] not in all_names
        all_names.add(row["id"])
        if suite["kind"] == "parallel":
            for name in ["left", "right", "marker"]:
                assert row["expected"][name] == row["input"][name]
            assert row["expected"]["owned_capture"] == suite["key"].endswith("captured")
            for value in [row["input"]["marker"], *row["input"]["left"]["values"], *row["input"]["right"]["values"]]:
                struct.unpack(">f" if len(value) == 8 else ">d", bytes.fromhex(value))
            for name in ["left", "right"]:
                pattern = row["input"][name]
                assert pattern["values"] and 0 <= pattern["length"] <= 8192
        else:
            data = row["input"]
            selected = data["safe"] if data["choose"] else (data["items"][0] if data["items"] else None)
            if selected is None:
                assert row["expected"] == {"error": "IndexOutOfBounds"}
            else:
                value = struct.unpack(">f" if len(selected) == 8 else ">d", bytes.fromhex(selected))[0]
                assert row["expected"] == {"value": "nan" if value != value else selected}
    if suite["kind"] == "parallel":
        new_count += len(rows)
        assert {kind: sum(row["check"] == kind for row in rows) for kind in ["values", "threads", "allocations"]} == {"values": 450, "threads": 1, "allocations": 1}
assert len(all_names) == 3320 and new_count == 1808
program_bytes = {}
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 54 and len(state["steps"]) == 115
    assert state["named_executions"] == 29880 and state["new_named_executions"] == 16272
    assert sha(Path(state["tool"]).read_bytes()) == state["tool_sha256"]
    for step in state["steps"]:
        assert step["exit_code"] == 0
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    executed = set()
    for item in state["programs"]:
        key = item["suite"]
        suite = suites[key]
        count = suite["count"]
        assert item["kind"] == suite["kind"]
        assert (key, item["route"]) not in executed
        executed.add((key, item["route"]))
        source = root / ("packages/test/tests/" + suite["path"] + ".rx")
        catalog = source.with_suffix(".jsonl")
        expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
        assert item["names"] == expected and item["signature_verified"]
        assert sha(source.read_bytes()) == item["source_sha256"]
        assert sha(catalog.read_bytes()) == item["catalog_sha256"]
        assert sha(Path(item["test_source"]).read_bytes()) == item["test_source_sha256"]
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", item["binary"]], check=True, capture_output=True)
        record = json.loads(Path(item["record"]).read_text())
        assert record["status"] == 0 and record["signal"] is None and record["error"] is None and record["names"] == expected
        assert "--test-no-exec" not in record["argv"]
        log = Path(item["record"]).with_suffix(".log").read_text()
        names = re.findall(r"\d+/" + str(count) + r" .*?\.test\.(.+?)\.\.\.", log)
        assert names == expected and "All " + str(count) + " tests passed." in log
        workers = [int(value) for value in re.findall(r"RX floating worker allocations: (\d+)", log)]
        assert workers == item["workers"]
        if suite["kind"] == "parallel":
            assert len(workers) == 1
            if key.endswith("captured"):
                assert workers[0] >= 1
            else:
                assert workers == [2]
            assert log.count("RX floating allocation sweep completed") == 1
        else:
            assert not workers
        for path, identity in item["files"].items():
            assert sha(Path(path).read_bytes()) == identity
            if path.endswith(".zig"):
                byte_key = (key, item["route"], str(Path(path).relative_to(Path(item["binary"]).parents[2])))
                if mode == "Debug":
                    program_bytes[byte_key] = Path(path).read_bytes()
                else:
                    assert program_bytes[byte_key] == Path(path).read_bytes(), byte_key
        byte_key = (key, "test-source")
        if mode == "Debug":
            program_bytes[byte_key] = Path(item["test_source"]).read_bytes()
        else:
            assert program_bytes[byte_key] == Path(item["test_source"]).read_bytes()
    assert executed == {(key, route) for key in suites for route in routes}
print("PASS: 1808 new and 1512 regression cases; 59760 actual executions; 108 signed binaries; thread and allocation controls; frozen inputs")
