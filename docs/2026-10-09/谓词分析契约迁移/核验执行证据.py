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
    if name not in inputs["formal"]:
        assert sha((root / name).read_bytes()) == expected, name

for name, expected in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == expected, name

for item in inputs["external_inputs"].values():
    assert sha(Path(item["snapshot"]).read_bytes()) == item["sha256"]

generator = json.loads((doc / "generator-state.json").read_text())
assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert sha((run / "generate-parser").read_bytes()) == generator["generator_binary_sha256"]
assert len(generator["generated"]) == 81

for step in generator["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    assert Path(step["log"]).read_bytes() == (doc / "日志" / Path(step["log"]).name).read_bytes()

for name, expected in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == expected
    assert Path(name).read_bytes() == (doc / "生成源码" / (Path(name).name + ".txt")).read_bytes()

baseline = json.loads((doc / "baseline-Debug-state.json").read_text())
assert baseline["exit_code"] == 1 and baseline["signature_exit"] == 0
assert baseline["source_sha256"] == sha((doc / "原有分析测试.zig.txt").read_bytes())
assert "2 passed; 0 skipped; 4 failed." in Path(baseline["log"]).read_text()

expected_names = []

for name in inputs["formal"]:
    source = (doc / "草稿" / name).read_bytes()
    assert source == (root / name).read_bytes(), name
    expected_names += re.findall(r'^test "([^"]+)"', source.decode(), re.M)

assert len(expected_names) == len(set(expected_names)) == 24

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((doc / ("final-" + mode + "-state.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert state["signature_exit"] == 0
    assert state["formal_sources"] == {name: sha((root / name).read_bytes()) for name in inputs["formal"]}
    log = Path(state["log"]).read_text()
    names = re.findall(r'^\d+/25 .*?\.test\.([^\n]+)\.\.\.OK$', log, re.M)
    assert sorted(names) == sorted(expected_names), (mode, names)
    assert "All 25 tests passed." in log
    command = state["command"]
    assert "--test-no-exec" not in command and "--entitlements" in command
    binary = run / ("final-" + mode)
    assert sha(binary.read_bytes()) == state["binary_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True)
    for name, expected in state["external"].items():
        assert sha(Path(name).read_bytes()) == expected

for path in doc.glob("*-state.json"):
    state = json.loads(path.read_text())
    assert state["status"] == "terminal"
    if "log" in state:
        source = Path(state["log"])
        assert sha(source.read_bytes()) == state["log_sha256"]
        assert source.read_bytes() == (doc / "日志" / source.name).read_bytes()

print("PASS: 48 named checks and 2 discovery roots, original failures, fixed source and 81 modules")
