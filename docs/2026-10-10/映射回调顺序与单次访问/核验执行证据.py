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

for name, expected in {**inputs["packages"], **inputs["formal_sha256"]}.items():
    assert sha((root / name).read_bytes()) == expected, name
    if name in inputs["formal"] and name.endswith(".zx"):
        assert len((root / name).read_text().split("\n")) - 1 <= 120, name
for name, expected in {**inputs["tools"], **inputs["external"]}.items():
    assert sha(Path(name).read_bytes()) == expected, name
for name in inputs["formal"]:
    assert (doc / "草稿" / name).read_bytes() == (root / name).read_bytes(), name

state = json.loads((run / "generator-state.json").read_text())
assert state["status"] == "terminal" and state["exit_code"] == 0
assert len(state["steps"]) == 6
assert len(state["generated"]) == inputs["generated_count"] == 83
assert set(state["generated"]) == {str(path) for path in (run / "generated").glob("*.zig")}

for entry in state["steps"]:
    assert entry["exit_code"] == 0
    assert sha(Path(entry["log"]).read_bytes()) == entry["log_sha256"]
for name, expected in {**state["generated"], **state["tool_binaries"]}.items():
    assert sha(Path(name).read_bytes()) == expected, name
for name in state["tool_binaries"]:
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", name], check=True, capture_output=True)

for mode, command in inputs["compile_templates"].items():
    modules = {arg.split("=", 1)[0][2:]: Path(arg.split("=", 1)[1]) for arg in command if arg.startswith("-M")}
    assert re.search(r"generated_parser:\s*bool\s*=\s*true;", modules["parser_options"].read_text())
    removed = {"generated_type_extract", "extract_workspace", "extract_workspace_view", "merge_writer", "merge_writer_view"}
    assert not (removed & modules.keys())
    assert "generated_type_merge" in modules and "generated_artifact_remap" in modules
    assert not ({"reference_view", "named_view", "origin_writer", "generated_name_sort", "named_columns", "generated_type_remap", "references"} & modules.keys())

results = []
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["programs"]) == 4
    assert {(item["suite"], item["route"]) for item in state["programs"]} == {(suite, route) for suite in inputs["counts"] for route in ["source", "library"]}
    assert sha(Path(state["tool"]).read_bytes()) == state["tool_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", state["tool"]], check=True, capture_output=True)
    for step in state["steps"]:
        assert step["exit_code"] == 0
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    for item in state["programs"]:
        assert item["signature_verified"]
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", item["binary"]], check=True, capture_output=True)
        assert sha(Path(item["test_source"]).read_bytes()) == item["test_source_sha256"]
        base = root / ("packages/test/tests/built_ins/list/callbacks/map/trace/" + item["suite"])
        assert sha(base.with_suffix(".zx").read_bytes()) == item["source_sha256"]
        assert sha(base.with_suffix(".jsonl").read_bytes()) == item["catalog_sha256"]
        expected = [json.loads(line)["id"] for line in base.with_suffix(".jsonl").read_text().split("\n") if line.strip()]
        assert len(expected) == inputs["counts"][item["suite"]]
        assert item["names"] == expected
        for path, identity in item["files"].items():
            assert sha(Path(path).read_bytes()) == identity, path
        runtime = Path(item["binary"]).parent
        execution = json.loads((runtime / "execution.json").read_text())
        assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
        assert execution["names"] == expected and execution["binary_sha256"] == item["binary_sha256"]
        assert "--test-no-exec" not in execution["argv"]
        text = (runtime / "execution.log").read_text()
        assert re.findall(r"^\d+/\d+ .*?\.test\.(.+?)\.\.\.OK$", text, re.MULTILINE) == expected
        assert "All " + str(len(expected)) + " tests passed." in text
    assert state["named_executions"] == sum(len(item["names"]) for item in state["programs"])
    results.append(state)
for left, right in zip(results[0]["programs"], results[1]["programs"]):
    assert (left["suite"], left["route"], left["names"]) == (right["suite"], right["route"], right["names"])
    for name in ["source_sha256", "catalog_sha256", "test_source_sha256"]:
        assert left[name] == right[name]
    for path, identity in left["files"].items():
        if not path.endswith(".zig"):
            continue
        assert right["files"][path.replace("/Debug/", "/ReleaseSafe/")] == identity
for entry in json.loads((doc / "静态检查.json").read_text()):
    assert entry["exit_code"] == 0
for entry in json.loads((doc / "证据清单.json").read_text()):
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]
    assert sha(Path(entry["source"]).read_bytes()) == entry["sha256"]
originals = json.loads((doc / "原文身份.json").read_text())
observed = json.loads((doc / "原文执行证据.json").read_text())
upstream = Path.home() / ".codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd"
for name, identity in observed["harness"].items():
    assert sha((upstream / "harness" / name).read_bytes()) == identity
assert len(originals) == 2 and len(observed["records"]) == 4
for original in originals:
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]
    records = [row for row in observed["records"] if row["path"] == original["path"]]
    assert {row["strict"] for row in records} == {False, True}
    for row in records:
        assert row["sha256"] == original["sha256"]
        assert len(row["observed"]) == original["assertion_count"]
assert sum(len(row["observed"]) for row in observed["records"]) == 14
for rule, values, output in [("cursor", [0, 1, 2, 3, 4, 5], [True] * 6), ("violations", [11, 12, 13, 14], [False] * 4)]:
    path = root / ("packages/test/tests/built_ins/list/callbacks/map/trace/" + rule + ".jsonl")
    rows = [json.loads(line) for line in path.read_text().split("\n") if line.strip()]
    original_case = next(row for row in rows if row["id"].endswith("/upstream_" + rule))
    assert original_case["input"] == values
    assert original_case["probe"] == {"rule": rule, "cursor": 0, "failure": 0}
    assert original_case["expected"] == {"value": output, "ordered": True, "calls": len(values), "visits": [{"item": item, "index": index} for index, item in enumerate(values)], "input": values, "source_calls": 1}
assert sum(state["named_executions"] for state in results) == 4 * sum(inputs["counts"].values())
print("PASS:", sum(state["named_executions"] for state in results), "named test executions across 8 signed binaries; 83 fresh generated modules; two full originals and fourteen official assertions")
