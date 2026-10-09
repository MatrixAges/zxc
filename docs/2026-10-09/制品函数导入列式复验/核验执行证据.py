from pathlib import Path
import hashlib
import json
import re
import subprocess


doc = Path(__file__).resolve().parent
sha = lambda data: hashlib.sha256(data).hexdigest()


def identity(path, expected):
    assert sha(Path(path).read_bytes()) == expected, str(path)


def signed(path, expected):
    identity(path, expected)
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(path)], check=True)


def check_phase(directory, prefix, generated_count, named_count):
    inputs = json.loads((directory / "执行输入.json").read_text())
    root = Path(inputs["root"])
    run = Path(inputs["run"])
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == inputs["source_commit"]

    for name, expected in inputs["packages"].items():
        if name not in inputs["formal"]:
            identity(root / name, expected)

    for name in inputs["formal"]:
        assert (root / name).read_bytes() == (directory / "草稿" / name).read_bytes(), name

    for name, expected in inputs["tools"].items():
        identity(name, expected)

    generator = json.loads((directory / "generator-state.json").read_text())
    assert generator["status"] == "terminal" and generator["exit_code"] == 0
    assert len(generator["generated"]) == generated_count
    signed(run / "generate-parser", generator["generator_binary_sha256"])

    for name, expected in generator["generated"].items():
        identity(name, expected)

    for step in generator["steps"]:
        assert step["exit_code"] == 0
        identity(step["log"], step["log_sha256"])
        assert Path(step["log"]).read_bytes() == (directory / "日志" / Path(step["log"]).name).read_bytes()

    roots = re.findall(r'@import\("([^"\n]+)"\)', (directory / "门禁入口.zig.txt").read_text())
    expected_names = []

    for name in roots:
        expected_names += re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests" / name).read_text(), re.M)

    assert len(expected_names) == len(set(expected_names)) == named_count
    emitted = {}

    for mode in ["Debug", "ReleaseSafe"]:
        state = json.loads((directory / (prefix + "-" + mode + "-state.json")).read_text())
        assert state["status"] == "terminal" and state["exit_code"] == 0 and state["signature_exit"] == 0
        assert state["formal_sources"] == {name: sha((root / name).read_bytes()) for name in inputs["formal"]}
        assert state["source_sha256"] == sha((directory / "门禁入口.zig.txt").read_bytes())
        log = Path(state["log"])
        identity(log, state["log_sha256"])
        assert log.read_bytes() == (directory / "日志" / log.name).read_bytes()
        actual = re.findall(r'^\d+/\d+ .*?\.test\.([^\n]+)\.\.\.OK$', log.read_text(), re.M)
        assert sorted(actual) == sorted(expected_names), (mode, actual)
        assert "All " + str(named_count + 1) + " tests passed." in log.read_text()
        assert "--test-no-exec" not in state["command"]
        signed(run / (prefix + "-" + mode), state["binary_sha256"])

        for name, expected in state["external"].items():
            identity(name, expected)

        parser = next(argument.split("=", 1)[1] for argument in state["command"] if argument.startswith("-Mparser_options="))
        assert re.search(r'pub const generated_parser(?:\s*:\s*bool)?\s*=\s*true;', Path(parser).read_text())
        runtime = json.loads((directory / (mode + "-runtime.json")).read_text())
        assert runtime["status"] == "terminal" and runtime["exit_code"] == 0 and runtime["compile_exit"] == 0
        assert len(runtime["programs"]) == 12
        assert {item["name"] for item in runtime["programs"]} == {str(index) + "-" + route for index in range(6) for route in ["source", "library"]}
        signed(run / mode / "compile-artifact-imports", runtime["tool_sha256"])
        identity(runtime["compile_log"], runtime["compile_log_sha256"])
        assert Path(runtime["compile_log"]).read_bytes() == (directory / "日志" / mode / "compile-tool.txt").read_bytes()
        emitted[mode] = {}
        runtime_names = re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests/incremental/artifact/imports/runtime_test.zig").read_text(), re.M)
        assert len(runtime_names) == 3

        for item in runtime["programs"]:
            assert item["generate_exit"] == item["exit_code"] == 0
            assert item["names"] == runtime_names
            for key in ["generate_log", "log"]:
                identity(item[key], item[key + "_sha256"])
                assert Path(item[key]).read_bytes() == (directory / "日志" / mode / Path(item[key]).name).read_bytes()
            actual = re.findall(r'^\d+/3 .*?\.test\.([^\n]+)\.\.\.OK$', Path(item["log"]).read_text(), re.M)
            assert actual == runtime_names
            assert "All 3 tests passed." in Path(item["log"]).read_text()
            assert "--test-no-exec" not in item["command"]
            signed(item["binary"], item["binary_sha256"])
            identity(item["source"], item["source_sha256"])
            assert Path(item["source"]).read_bytes() == (directory / "生成源码" / mode / (Path(item["source"]).name + ".txt")).read_bytes()
            emitted[mode][item["name"]] = item["source_sha256"]

    assert emitted["Debug"] == emitted["ReleaseSafe"]


check_phase(doc / "旧数组签名阶段", "final", 83, 51)
check_phase(doc, "final2", 85, 54)

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((doc / "命令依赖标记修正前" / ("final-" + mode + "-state.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 1
    assert "unrecognized file extension" in (doc / "命令依赖标记修正前" / ("final-" + mode + ".txt")).read_text()

print("PASS: current 180 named checks in 26 actual binaries and 85 modules; prior phase verified separately")
