from pathlib import Path

import hashlib
import json
import math
import struct
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
for item in json.loads((doc / "证据清单.json").read_text()):
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
for check in json.loads((doc / "静态检查.json").read_text()):
    assert check["exit_code"] == 0
    if "path" in check and "sha256" in check:
        path = Path(check["path"])
        assert sha((path if path.is_absolute() else root / path).read_bytes()) == check["sha256"]
    if "log" in check:
        assert sha(Path(check["log"]).read_bytes()) == check["log_sha256"]
for check in json.loads((doc / "位模式独立核对.json").read_text()):
    catalog = root / ("packages/test/tests/rx/runtime/floating/f" + str(check["width"]) + ".jsonl")
    assert sha(catalog.read_bytes()) == check["catalog_sha256"]
    rows = [json.loads(line) for line in catalog.read_text().split("\n") if line.strip()]
    errors = nan_count = negative_zero = 0
    for row in rows:
        data = row["input"]
        selected = data["safe"] if data["choose"] else (data["items"][0] if data["items"] else None)
        if selected is None:
            assert row["expected"] == {"error": "IndexOutOfBounds"}
            errors += 1
        else:
            value = struct.unpack(">f" if check["width"] == 32 else ">d", bytes.fromhex(selected))[0]
            nan_count += math.isnan(value)
            negative_zero += value == 0 and math.copysign(1, value) < 0
            assert row["expected"] == {"value": "nan" if math.isnan(value) else selected}
    assert len(rows) == check["rows"] == 756
    assert errors == check["selected_empty_errors"] == 18
    assert nan_count == check["selected_nan"] == 41
    assert negative_zero == check["selected_negative_zero"] == 41
all_names = set()
rows_by_id = {}
for suite, count in inputs["counts"].items():
    source = root / ("packages/test/tests/rx/runtime/floating/" + suite + ".rx")
    rows = [json.loads(line) for line in source.with_suffix(".jsonl").read_text().split("\n") if line.strip()]
    assert len(rows) == count
    for row in rows:
        assert row["id"] not in all_names
        all_names.add(row["id"])
        rows_by_id[row["id"]] = row
    assert source.read_text().count("\n") <= 120
assert len(all_names) == 1512
program_bytes = {}
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 18 and len(state["steps"]) == 39
    assert state["named_executions"] == 13608
    assert sha(Path(state["tool"]).read_bytes()) == state["tool_sha256"]
    for step in state["steps"]:
        assert step["exit_code"] == 0
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    executed = set()
    for item in state["programs"]:
        suite = item["suite"]
        count = inputs["counts"][suite]
        assert (suite, item["route"]) not in executed
        executed.add((suite, item["route"]))
        source = root / ("packages/test/tests/rx/runtime/floating/" + suite + ".rx")
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
        for path, identity in item["files"].items():
            assert sha(Path(path).read_bytes()) == identity
            if path.endswith(".zig"):
                key = (suite, item["route"], str(Path(path).relative_to(Path(item["binary"]).parents[2])))
                if mode == "Debug":
                    program_bytes[key] = Path(path).read_bytes()
                else:
                    assert program_bytes[key] == Path(path).read_bytes(), key
        key = (suite, "test-source")
        if mode == "Debug":
            program_bytes[key] = Path(item["test_source"]).read_bytes()
        else:
            assert program_bytes[key] == Path(item["test_source"]).read_bytes()
    assert executed == {(suite, route) for suite in inputs["counts"] for route in ["source", "forward", "reverse", "rx_forward", "rx_reverse", "zx_forward", "zx_reverse", "republish_forward", "republish_reverse"]}
print("PASS: 1512 cases, 27216 actual executions, 36 signed binaries, frozen inputs and generated identity")
