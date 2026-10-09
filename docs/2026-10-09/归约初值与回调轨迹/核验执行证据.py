from pathlib import Path

import hashlib
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == inputs["source_commit"]

for name, expected in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == expected, name

for group in ["tools", "external"]:
    for name, expected in inputs[group].items():
        assert sha(Path(name).read_bytes()) == expected, name

for name, expected in inputs["formal_sha256"].items():
    assert sha((root / name).read_bytes()) == expected, name
    assert (root / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

    if name.endswith(".zx"):
        text = (root / name).read_text()
        assert len(re.split(r"\r\n|\r|\n", text)) - int(text.endswith(("\n", "\r"))) <= 120

for entry in json.loads((doc / "证据清单.json").read_text()):
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]
    assert sha(Path(entry["source"]).read_bytes()) == entry["sha256"]

first = json.loads((doc / "首轮执行输入.json.txt").read_text())

for name, identity in first["formal_sha256"].items():
    assert sha((doc / "首轮草稿" / (name + ".txt")).read_bytes()) == identity

generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
assert len(generation["generated"]) == 85
assert all(step["exit_code"] == 0 for step in generation["steps"])
assert sha((run / "generate-parser").read_bytes()) == generation["generator_binary_sha256"]

for path, expected in generation["generated"].items():
    assert sha(Path(path).read_bytes()) == expected

binary_count = 0
named_count = 0

for mode in ["Debug", "ReleaseSafe"]:
    initial_path = run / (mode + "-execution.json")
    initial = json.loads(initial_path.read_text())
    assert initial["status"] == "terminal" and initial["exit_code"] == 1
    assert initial["steps"][0]["exit_code"] == 0
    assert initial["steps"][-1]["exit_code"] == 1
    assert "expected type" in Path(initial["steps"][-1]["log"]).read_text()
    state = json.loads((run / (mode + "-corrected-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 4
    assert all(step["exit_code"] == 0 for step in state["steps"])
    assert state["reuse_from"] == str(initial_path)
    assert state["reuse_state_sha256"] == sha(initial_path.read_bytes())
    assert state["tool"] == initial["tool"]
    assert state["tool_sha256"] == initial["tool_sha256"] == sha(Path(state["tool"]).read_bytes())
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", state["tool"]], check=True)

    for entry in state["programs"]:
        catalog = root / ("packages/test/tests/built_ins/list/callbacks/reduce/trace/" + entry["initial"] + ".jsonl")
        rows = [json.loads(line) for line in catalog.read_text().split("\n") if line.strip()]
        expected = [row["id"] for row in rows]
        execution = json.loads(Path(entry["execution"]).read_text())
        assert len(expected) == inputs["counts"][entry["initial"]]
        assert entry["names"] == execution["names"] == expected
        assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
        assert sha(Path(entry["binary"]).read_bytes()) == entry["binary_sha256"] == execution["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", entry["binary"]], check=True)
        binary_count += 1
        named_count += len(expected)

        for path, identity in entry["files"].items():
            assert sha(Path(path).read_bytes()) == identity

    for step in state["steps"]:
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]

for initial in ["seeded", "unseeded"]:
    for route in ["source", "library"]:
        debug = run / "Debug-corrected" / (initial + "-" + route)
        safe = run / "ReleaseSafe-corrected" / (initial + "-" + route)

        for path in debug.glob("*.zig"):
            assert path.read_bytes() == (safe / path.name).read_bytes(), path

build = json.loads((run / "build-api.json").read_text())
assert build["status"] == "terminal" and build["exit_code"] == 0 and len(build["steps"]) == 2

for entry in build["steps"]:
    assert entry["exit_code"] == 0
    assert sha(Path(entry["log"]).read_bytes()) == entry["log_sha256"]
    assert "All 1 tests passed." in Path(entry["log"]).read_text()
    assert sha(Path(entry["binary"]).read_bytes()) == entry["binary_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", entry["binary"]], check=True)

originals = json.loads((doc / "原文身份.json").read_text())
original_evidence = json.loads((doc / "原文执行证据.json").read_text())
records = original_evidence["records"]
upstream = Path.home() / ".codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd"
assert len(originals) == 5 and len(records) == 10
assert sum(len(record["observed"]) for record in records) == 14

for name, identity in original_evidence["harness"].items():
    assert sha((upstream / "harness" / name).read_bytes()) == identity

for original in originals:
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]
    assert sha((upstream / original["path"]).read_bytes()) == original["sha256"]
    observations = [record for record in records if record["path"] == original["path"]]
    assert {record["strict"] for record in observations} == {False, True}
    assert all(len(record["observed"]) == original["assertion_count"] for record in observations)
    assert all(record["sha256"] == original["sha256"] for record in observations)

all_rows = []

for initial in ["seeded", "unseeded"]:
    path = root / ("packages/test/tests/built_ins/list/callbacks/reduce/trace/" + initial + ".jsonl")
    all_rows += [json.loads(line) for line in path.read_text().split("\n") if line.strip()]

by_name = {row["id"].split("/")[-1]: row["expected"] for row in all_rows if "/original_" in row["id"]}
assert by_name["original_first_accumulator"]["calls"] == 1
assert by_name["original_first_accumulator"]["visits"] == [{"previous": 11, "current": 9, "index": 1, "source_value": 9, "source_length": 2}]
assert by_name["original_singleton_skips_callback"]["value"] == 1 and by_name["original_singleton_skips_callback"]["calls"] == 0
assert by_name["original_first_own_element"]["visits"][0]["index"] == 1 and by_name["original_first_own_element"]["visits"][0]["previous"] == 0
assert by_name["original_current_own_element"]["visits"][1]["index"] == 1 and by_name["original_current_own_element"]["visits"][1]["current"] == 1
assert by_name["original_empty_without_initial"]["error"] == "IndexOutOfBounds" and by_name["original_empty_without_initial"]["calls"] == 0

for entry in json.loads((doc / "静态检查.json").read_text()).values():
    assert entry["exit_code"] == 0
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]

assert binary_count == 8 and named_count == 816
print("PASS: 816 named runtime executions in eight signed binaries, two Build API checks and fourteen original assertions")
