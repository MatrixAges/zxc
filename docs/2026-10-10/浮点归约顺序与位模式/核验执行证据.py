from pathlib import Path

import hashlib
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
all_names = set()
rows_by_id = {}
for suite, count in inputs["counts"].items():
    source = root / ("packages/test/tests/built_ins/list/callbacks/reduce/floating/" + suite + ".zx")
    rows = [json.loads(line) for line in source.with_suffix(".jsonl").read_text().split("\n") if line.strip()]
    assert len(rows) == count
    for row in rows:
        assert row["id"] not in all_names
        all_names.add(row["id"])
        rows_by_id[row["id"]] = row
    assert source.read_text().count("\n") <= 120
assert len(all_names) == 5944
for anchor in json.loads((doc / "数值锚点核对.json").read_text()):
    assert rows_by_id[anchor["id"]]["expected"] == anchor["expected"]
program_bytes = {}
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 32 and len(state["steps"]) == 81
    assert state["named_executions"] == 11888
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
        source = root / ("packages/test/tests/built_ins/list/callbacks/reduce/floating/" + suite + ".zx")
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
    assert executed == {(suite, route) for suite in inputs["counts"] for route in ["source", "library"]}
print("PASS: 5944 cases, 23776 actual executions, 64 signed binaries, frozen inputs and generated identity")
