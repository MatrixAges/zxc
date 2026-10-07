from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
fingerprints = json.loads((doc / "执行源码指纹.json").read_text())
for item in fingerprints["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

base = json.loads((doc / "开始基线.json").read_text())
shape = "packages/test/tests/language/expressions/tasks/cancel_analysis/shape_test.zig"
assert (root / shape).read_bytes() == (doc / "原始文件" / (shape + ".txt")).read_bytes()
graph = "packages/test/tests/language/types/resolution/graph.zig"
original = (doc / "原始文件" / (graph + ".txt")).read_text()
expected = original.replace("    for (program.symbols) |symbol| {", "    for (0..program.symbols.count()) |symbol_index| {\n        const symbol = program.symbols.at(symbol_index);\n")
assert (root / graph).read_text() == expected

for item in base["files"]:
    assert (root / item["path"]).read_bytes() == (doc / "草稿" / item["path"]).read_bytes()

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "证据.json")).read_text())
    assert evidence["exit_code"] == 0 and evidence["passed"] is True
    assert evidence["steps_passed"] == evidence["steps_total"]
    assert evidence["tests_passed"] == evidence["tests_total"]
    assert len(evidence["logged_zig_test_binaries"]) == 1
    assert evidence["errors"] == []
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["summary"].encode() in raw
    for binary in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(binary["path"]).read_bytes()).hexdigest() == binary["sha256"]

replay = json.loads((doc / "原生重跑证据.json").read_text())
assert replay["total_checks"] == 168 and len(replay["runs"]) == 18
for mode in ["Debug", "ReleaseSafe"]:
    runs = [run for run in replay["runs"] if run["mode"] == mode]
    first = json.loads((doc / ("首次尝试" + mode + "证据.json")).read_text())
    final = json.loads((doc / (mode + "证据.json")).read_text())
    assert {run["binary"]["path"] for run in runs} == {item["path"] for item in first["logged_zig_test_binaries"] + final["logged_zig_test_binaries"]}
    assert len(runs) == 9 and sum(run["tests"] for run in runs) == 84
    assert len({run["binary"]["path"] for run in runs}) == 9
    for run in runs:
        assert run["exit_code"] == 0
        assert hashlib.sha256(Path(run["binary"]["path"]).read_bytes()).hexdigest() == run["binary"]["sha256"]
        output = (doc / run["log"]).read_bytes()
        assert hashlib.sha256(output).hexdigest() == run["log_sha256"]
        assert f"All {run['tests']} tests passed".encode() in output

old = doc.parent / "规范表达式列全量回归"
evidence = json.loads((old / "首轮Debug证据.json").read_text())
assert evidence["source_commit"] == "b6a814647ff9421821c062d11d701b1a49f11710"
assert evidence["exit_code"] == 1 and evidence["passed"] is False
assert evidence["steps_passed"] == 6646 and evidence["steps_total"] == 6688
assert evidence["tests_passed"] == 111781 and evidence["tests_total"] == 111789
assert hashlib.sha256((old / evidence["log"]).read_bytes()).hexdigest() == evidence["log_sha256"]
print("PASS: original full aggregate gates in both modes, nine binaries each, unchanged cancellation assertions, exact package fingerprints and old full-root failure evidence")
