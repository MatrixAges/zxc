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
for name, expected in {**inputs["tools"], **inputs["external"]}.items():
    assert sha(Path(name).read_bytes()) == expected, name
for name in inputs["formal"]:
    assert (doc / "草稿" / name).read_bytes() == (root / name).read_bytes(), name

state = json.loads((run / "generator-state.json").read_text())
assert state["status"] == "terminal" and state["exit_code"] == 0
assert len(state["steps"]) == 6
assert len(state["generated"]) == inputs["generated_count"] == 87
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
    assert "generated_type_merge" in modules and "references" in modules

results = []
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-aggregate-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["gates"]) == 2
    selected = []
    for entry in state["gates"]:
        assert entry["exit_code"] == 0 and entry["signature_verified"]
        for field in ["wrapper", "binary", "log"]:
            assert sha(Path(entry[field]).read_bytes()) == entry[field + "_sha256"], entry[field]
        for name, expected in entry["sources"].items():
            assert sha((root / "packages/test/tests" / (name + "_test.zig")).read_bytes()) == expected, name
        wrapper = "comptime {\n" + "".join('    _ = @import("' + name + '_test.zig");\n' for name in entry["roots"]) + "}\n"
        assert Path(entry["wrapper"]).read_text() == wrapper
        expected = [name.replace("/", ".") + "_test.test." + description for name in entry["roots"] for description in re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests" / (name + "_test.zig")).read_text(), re.MULTILINE)]
        text = Path(entry["log"]).read_text()
        names = re.findall(r"^\d+/\d+ (.+?)\.\.\.OK$", text, re.MULTILINE)
        assert names == entry["test_names"] and len(names) == entry["test_count"]
        assert sorted(names) == sorted(expected) == sorted(entry["expected_names"])
        assert "All " + str(len(names)) + " tests passed." in text
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", entry["binary"]], check=True, capture_output=True)
        assert "--test-no-exec" not in entry["command"]
        assert next(arg for arg in entry["command"] if arg.startswith("-Mroot=")) == "-Mroot=" + entry["wrapper"]
        selected += entry["roots"]
    assert len(selected) == len(set(selected)) == 31
    assert set(selected) == set(inputs["test_roots"])
    assert state["named_executions"] == sum(entry["test_count"] for entry in state["gates"])
    results.append(state)
assert [(entry["part"], entry["test_names"]) for entry in results[0]["gates"]] == [(entry["part"], entry["test_names"]) for entry in results[1]["gates"]]
for item in json.loads((doc / "静态检查.json").read_text()):
    assert item["exit_code"] == 0
    assert sha(Path(item["command"][-1]).read_bytes()) == item["sha256"]
for item in json.loads((doc / "证据清单.json").read_text()):
    assert sha((doc / item["saved"]).read_bytes()) == item["sha256"], item["saved"]
print("PASS:", sum(state["named_executions"] for state in results), "named test executions across 4 signed aggregate binaries and 31 original test roots; 87 fresh generated modules")
