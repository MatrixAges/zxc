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
assert inputs["source_commit"] == "872106c3981af68fa4049452f583d535af3b7551"
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == inputs["source_commit"]

for name, identity in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == identity, name

for name in inputs["formal"]:
    assert (root / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

for name, identity in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == identity, name

for name, entry in json.loads((doc / "证据归档.json").read_text()).items():
    assert sha((doc / name).read_bytes()) == entry["sha256"], name
    assert sha(Path(entry["source"]).read_bytes()) == entry["sha256"], entry["source"]

for name, entry in json.loads((doc / "修复前固定版本/归档清单.json").read_text()).items():
    assert sha((doc / "修复前固定版本" / name).read_bytes()) == entry["sha256"], name

old = json.loads((doc / "修复前固定版本/状态/analysis-r3-Debug-state.json.txt").read_text())
old_log = (doc / "修复前固定版本/日志/analysis-r3-Debug.txt").read_bytes()
assert old["status"] == "terminal" and old["exit_code"] == 1
assert sha(old_log) == old["log_sha256"]
assert "25 passed; 0 skipped; 2 failed." in old_log.decode()

reproduction = json.loads((doc / "修复前固定版本/失败复现.json").read_text())
assert reproduction["exit_code"] == 1 and reproduction["signature_exit"] == 0
assert sha(Path(reproduction["command"][0]).read_bytes()) == reproduction["binary_sha256"]
assert sha((doc / reproduction["log"]).read_bytes()) == reproduction["log_sha256"]
assert "25 passed; 0 skipped; 2 failed." in (doc / reproduction["log"]).read_text()

for name in inputs["formal"]:
    if "/field_facts/" in name and "/runtime/" not in name:
        assert (doc / "修复前固定版本/草稿" / (name + ".txt")).read_bytes() == (root / name).read_bytes(), name

for name, entry in json.loads((doc / "外部输入.json").read_text()).items():
    assert sha(Path(name).read_bytes()) == entry["sha256"]
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]

generator = json.loads((doc / "生成器证据.json.txt").read_text())
assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert len(generator["generated"]) == 85
assert all(entry["exit_code"] == 0 for entry in generator["steps"])

for name, identity in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == identity

owner = root / "packages/test/tests/ownership/field_facts"
ordered = re.findall(r'@import\("([^"]+_test.zig)"\)', (owner / "root.zig").read_text())
analysis_names = [name for file in ordered for name in re.findall(r'^test "([^"\n]+)"', (owner / file).read_text(), re.M)]
assert len(analysis_names) == 26
named = 0
runtime_binaries = []
tools = [(run / "generate-parser", generator["generator_binary_sha256"])]
generated = {}

for mode in ["Debug", "ReleaseSafe"]:
    analysis = json.loads((doc / ("final-" + mode + "-state.json.txt")).read_text())
    generation = json.loads((doc / (mode + "-generation.json.txt")).read_text())
    execution = json.loads((doc / (mode + "-execution.json.txt")).read_text())

    for state in [analysis, generation, execution]:
        assert state["status"] == "terminal" and state["exit_code"] == 0

    analysis_log = Path(analysis["log"]).read_bytes()
    assert sha(analysis_log) == analysis["log_sha256"]
    assert re.findall(r"\d+/27 .*?\.test\.(.+?)\.\.\.", analysis_log.decode()) == analysis_names
    assert "All 27 tests passed." in analysis_log.decode()
    assert analysis["source_sha256"] == old["source_sha256"]
    assert analysis["formal_sources"] == {name: inputs["packages"][name] for name in inputs["formal"]}
    runtime_binaries.append((run / ("final-" + mode), analysis["binary_sha256"]))
    named += len(analysis_names)
    assert generation["compile_exit"] == generation["signature_exit"] == 0
    tools.append((Path(generation["compile_command"][-3].split("=", 1)[1]), generation["binary_sha256"]))
    assert len(generation["programs"]) == len(execution["executions"]) == 16
    generated[mode] = {}

    for program in generation["programs"]:
        assert program["exit_code"] == 0
        assert sha(Path(program["fixture"]).read_bytes()) == program["fixture_sha256"]

        for name, identity in program["seeds"].items():
            assert sha(Path(name).read_bytes()) == identity

        generated[mode][program["name"]] = {Path(name).name: identity for name, identity in program["files"].items()}

    for entry in execution["executions"]:
        source = owner / "runtime" / (entry["root_name"] + ".zig")
        expected = re.findall(r'^test "([^"\n]+)"', source.read_text(), re.M)
        actual = entry["execution"]
        assert len(expected) == (6 if entry["name"].startswith("discard_") else 7)
        assert actual["names"] == expected
        assert entry["formal_sources"] == {name: inputs["packages"][name] for name in inputs["formal"]}
        assert sha(source.read_bytes()) == entry["root_source_sha256"]
        assert entry["exit_code"] == entry["signature_exit"] == actual["status"] == 0
        assert actual["signal"] is None and actual["error"] is None
        log = Path(entry["log"]).read_bytes()
        assert sha(log) == entry["log_sha256"]
        assert ("All " + str(len(expected)) + " tests passed.") in log.decode()
        runtime_binaries.append((Path(actual["binary"]), actual["binary_sha256"]))
        named += len(expected)

assert generated["Debug"] == generated["ReleaseSafe"]
assert named == 260 and len(runtime_binaries) == 34

for path, identity in runtime_binaries + tools:
    assert sha(path.read_bytes()) == identity
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(path)], check=True, capture_output=True)

for name in inputs["formal"]:
    if name.endswith(".zx"):
        assert len(re.split(r"\r\n|\r|\n", (root / name).read_text().rstrip("\r\n"))) <= 120, name

for entry in json.loads((doc / "Zig语法检查.json").read_text()):
    assert entry["exit_code"] == 0
    assert sha((root / entry["source"]).read_bytes()) == entry["source_sha256"]

for entry in json.loads((doc / "静态检查.json").read_text()):
    assert entry["exit_code"] == 0
    assert sha((doc / entry["log"]).read_bytes()) == entry["sha256"]

print("PASS: unchanged analysis expectations fail before the fix and pass afterward; 260 named executions in 34 signed test binaries, plus two discovery roots")
