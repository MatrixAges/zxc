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
        lines = re.split(r"\r\n|\r|\n", text)
        assert len(lines) - int(text.endswith(("\n", "\r"))) <= 120

for entry in json.loads((doc / "证据清单.json").read_text()):
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]
    assert sha(Path(entry["source"]).read_bytes()) == entry["sha256"]

generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
assert len(generation["generated"]) == inputs["generated_count"]
assert all(step["exit_code"] == 0 for step in generation["steps"])
assert sha((run / "generate-parser").read_bytes()) == generation["generator_binary_sha256"]

for path, identity in generation["tool_binaries"].items():
    assert sha(Path(path).read_bytes()) == identity
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", path], check=True)

for path, expected in generation["generated"].items():
    assert sha(Path(path).read_bytes()) == expected

previous = inputs["previous"]
old_inputs = json.loads((doc / "迁移前固定版本/执行输入.json.txt").read_text())
old_run = Path(previous["run"])
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=previous["root"], text=True).strip() == previous["source_commit"]

for entry in json.loads((doc / previous["manifest"]).read_text()):
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]
    assert sha(Path(entry["source"]).read_bytes()) == entry["sha256"]

for name, identity in old_inputs["formal_sha256"].items():
    assert identity == inputs["formal_sha256"][name]
    assert sha((Path(previous["root"]) / name).read_bytes()) == identity

for name, identity in old_inputs["packages"].items():
    assert sha((Path(previous["root"]) / name).read_bytes()) == identity

old_named = 0

for mode in ["Debug", "ReleaseSafe"]:
    old_state = json.loads((old_run / (mode + "-execution.json")).read_text())
    assert old_state["status"] == "terminal" and old_state["exit_code"] == 0
    assert len(old_state["programs"]) == 10

    for entry in old_state["programs"]:
        assert sha(Path(entry["binary"]).read_bytes()) == entry["binary_sha256"]
        old_named += len(entry["names"])

assert old_named == 824

for mode in ["Debug", "ReleaseSafe"]:
    failed = json.loads((doc / "命令前缀诊断" / (mode + "-state.json.txt")).read_text())
    log = (doc / "命令前缀诊断" / (mode + "-log.txt")).read_bytes()
    assert failed["status"] == "terminal" and failed["exit_code"] == 1
    assert len(failed["steps"]) == 1 and failed["programs"] == []
    assert sha(log) == failed["steps"][0]["log_sha256"]
    assert b"unknown command" in log

binary_count = 0
named_count = 0

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 10
    assert all(step["exit_code"] == 0 for step in state["steps"])
    assert sha(Path(state["tool"]).read_bytes()) == state["tool_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", state["tool"]], check=True)

    for entry in state["programs"]:
        source = root / ("packages/test/tests/built_ins/list/callbacks/reduce/fold/" + entry["suite"] + ".zx")
        catalog = source.with_suffix(".jsonl")
        rows = [json.loads(line) for line in catalog.read_text().split("\n") if line.strip()]
        expected = [row["id"] for row in rows]
        assert len(expected) == inputs["counts"][entry["suite"]]
        assert entry["names"] == expected
        assert sha(source.read_bytes()) == entry["source_sha256"]
        assert sha(catalog.read_bytes()) == entry["catalog_sha256"]
        assert sha((run / (entry["suite"].replace("/", "-") + "-cases.zig")).read_bytes()) == entry["test_source_sha256"]
        assert sha(Path(entry["binary"]).read_bytes()) == entry["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", entry["binary"]], check=True)
        binary_count += 1
        named_count += len(expected)

        for path, identity in entry["files"].items():
            assert sha(Path(path).read_bytes()) == identity

    for step in state["steps"]:
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]

for suite in inputs["counts"]:
    for route in ["source", "library"]:
        label = suite.replace("/", "-") + "-" + route
        debug = run / "Debug" / label
        safe = run / "ReleaseSafe" / label

        for path in debug.glob("*.zig"):
            assert path.read_bytes() == (safe / path.name).read_bytes(), path

originals = json.loads((doc / "原文身份.json").read_text())
original_evidence = json.loads((doc / "原文执行证据.json").read_text())
records = original_evidence["records"]
upstream = Path.home() / ".codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd"

for name, identity in original_evidence["harness"].items():
    assert sha((upstream / "harness" / name).read_bytes()) == identity

assert len(originals) == 2 and len(records) == 4
assert sum(len(record["observed"]) for record in records) == 12
path = root / "packages/test/tests/built_ins/list/callbacks/reduce/fold/concat/unseeded.jsonl"
rows = [json.loads(line) for line in path.read_text().split("\n") if line.strip()]
original = next(row for row in rows if row["id"].endswith("/upstream_concat_order"))
assert original["input"] == ["1", "2", "3", "4", "5"]
assert original["expected"] == {"value": "12345"}
path = root / "packages/test/tests/built_ins/list/callbacks/reduce/fold/constant/unseeded.jsonl"
rows = [json.loads(line) for line in path.read_text().split("\n") if line.strip()]
original = next(row for row in rows if row["id"].endswith("/upstream_input_preserved"))
assert original["input"] == {"items": [1, 2, 3, 4, 5], "returned": 1}
assert original["expected"] == {"value": {"value": 1, "items": [1, 2, 3, 4, 5]}}

for original in originals:
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]
    assert sha((upstream / original["path"]).read_bytes()) == original["sha256"]
    observations = [record for record in records if record["path"] == original["path"]]
    assert {record["strict"] for record in observations} == {False, True}
    assert all(len(record["observed"]) == original["assertion_count"] for record in observations)
    assert all(record["sha256"] == original["sha256"] for record in observations)

for entry in json.loads((doc / "静态检查.json").read_text()).values():
    assert entry["exit_code"] == 0
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]

assert binary_count == 20 and named_count == 824
print("PASS: 824 named executions in twenty signed binaries, 89 fresh compiler modules and twelve original assertions")
