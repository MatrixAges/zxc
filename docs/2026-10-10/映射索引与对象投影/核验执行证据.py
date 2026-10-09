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
    assert len(state["programs"]) == 10
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
        base = root / ("packages/test/tests/built_ins/list/callbacks/map/projection/" + item["suite"])
        assert sha(base.with_suffix(".zx").read_bytes()) == item["source_sha256"]
        assert sha(base.with_suffix(".jsonl").read_bytes()) == item["catalog_sha256"]
        expected = [json.loads(line)["id"] for line in base.with_suffix(".jsonl").read_text().split("\n") if line.strip()]
        assert len(expected) == inputs["counts"][item["suite"]]
        assert item["names"] == expected
        for path, identity in item["files"].items():
            assert sha(Path(path).read_bytes()) == identity, path
        matches = [step for step in state["steps"] if "-femit-bin=" + item["binary"] in step["command"]]
        assert len(matches) == 1
        step = matches[0]
        assert step["command"][1] == "test" and "--test-no-exec" not in step["command"]
        text = Path(step["log"]).read_text()
        assert re.findall(r"^\d+/\d+ .*?\.test\.(.+?)\.\.\.OK$", text, re.MULTILINE) == expected
        assert "All " + str(len(expected)) + " tests passed." in text
        assert json.loads((Path(item["binary"]).parent / "native.json").read_text()) == []
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
assert len(originals) == 1 and len(observed["records"]) == 2
for original in originals:
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]
    records = [row for row in observed["records"] if row["path"] == original["path"]]
    assert {row["strict"] for row in records} == {False, True}
    for row in records:
        assert row["sha256"] == original["sha256"]
        assert len(row["observed"]) == original["assertion_count"]
assert sum(len(row["observed"]) for row in observed["records"]) == 2
samples = [json.loads(line) for line in (root / "packages/test/src/data/map_projection.jsonl").read_text().split("\n") if line.strip()]
assert len(samples) == 1 and samples[0]["spec"] == {"operation": "source_value", "input": {"items": [11], "threshold": 10}}
rows = [json.loads(line) for line in (root / "packages/test/tests/built_ins/list/callbacks/map/projection/source_value.jsonl").read_text().split("\n") if line.strip()]
original_case = next(row for row in rows if row["id"].endswith("/" + samples[0]["name"]))
assert original_case["input"] == samples[0]["spec"]["input"]
assert original_case["expected"] == {"value": {"mapped": [True], "items": [11]}}
for row in observed["records"]:
    assert row["observed"][0]["actual"] is original_case["expected"]["value"]["mapped"][0]
diagnostic = json.loads((doc / "前期诊断/判别联合命令.json.txt").read_text())
assert diagnostic["exit_code"] == 2
assert "Property 'first' does not exist" in (doc / "前期诊断/判别联合.log.txt").read_text()
assert "'indices' | 'length' | 'rotate'" in (doc / "前期诊断/判别联合.ts.txt").read_text()
print("PASS:", sum(state["named_executions"] for state in results), "named test executions across 20 signed binaries; 83 fresh generated modules; one full original and two official assertions")
