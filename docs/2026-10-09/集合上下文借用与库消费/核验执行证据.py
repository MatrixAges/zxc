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

for name, expected in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == expected, name

for identity in inputs["external_inputs"].values():
    assert sha(Path(identity["snapshot"]).read_bytes()) == identity["sha256"]

for name in inputs["formal"]:
    assert (doc / "草稿" / name).read_bytes() == (root / name).read_bytes(), name

generator = json.loads((doc / "生成器证据.json").read_text())
assert generator == json.loads((run / "generator-state.json").read_text())
assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert len(generator["generated"]) == 81
assert sha((run / "generate-parser").read_bytes()) == generator["generator_binary_sha256"]

for name, expected in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == expected, name

subprocess.run(["python3", str(doc / "修复前捕获分配阶段/核验执行证据.py")], check=True)
subprocess.run(["python3", str(doc / "修复前捕获分配阶段/容量观察/核验容量证据.py")], check=True)

tools = json.loads((doc / "工具检查.json").read_text())
assert tools and all(item["exit_code"] == 0 for item in tools)

for step in generator["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]

count = 0
programs = {}
expected_roots = {kind + "-" + method + "-" + route for kind in ["list", "object", "nested"] for method in ["map", "filter", "every", "some"] for route in ["source", "library"]}

for mode in ["Debug", "ReleaseSafe"]:
    generation = json.loads((doc / (mode + "-generation.json")).read_text())
    execution = json.loads((doc / (mode + "-execution.json")).read_text())
    assert generation == json.loads((run / (mode + "-generation.json")).read_text())
    assert execution == json.loads((run / (mode + "-execution.json")).read_text())
    assert generation["status"] == execution["status"] == "terminal"
    assert generation["exit_code"] == execution["exit_code"] == 0
    assert generation["compile_exit"] == generation["signature_exit"] == 0
    binary = Path(next(arg.removeprefix("-femit-bin=") for arg in generation["compile_command"] if arg.startswith("-femit-bin=")))
    assert sha(binary.read_bytes()) == generation["binary_sha256"]
    assert len(generation["programs"]) == 24 and len(execution["executions"]) == 36
    assert {item["name"] for item in generation["programs"]} == expected_roots
    assert {item["name"] for item in execution["executions"]} == expected_roots
    assert sum(item["root_name"] == "capacity_test" for item in execution["executions"]) == 12

    for name, expected in generation["external"].items():
        assert sha(Path(name).read_bytes()) == expected, name

    raw = Path(generation["compile_log"]).read_bytes()
    assert sha(raw) == generation["compile_log_sha256"]
    assert (doc / "日志" / mode / "compile.txt").read_bytes() == raw

    for item in generation["programs"]:
        assert item["exit_code"] == 0
        assert sha(Path(item["fixture"]).read_bytes()) == item["fixture_sha256"]
        assert sha(Path(item["declaration"]).read_bytes()) == item["declaration_sha256"]
        directory = Path(item["directory"])
        saved = doc / "生成源码" / mode / item["name"]
        raw = Path(item["log"]).read_bytes()
        assert sha(raw) == item["log_sha256"]
        assert (doc / "日志" / mode / Path(item["log"]).name).read_bytes() == raw
        files = {}

        for name, expected in item["files"].items():
            path = Path(name)
            raw = path.read_bytes()
            assert sha(raw) == expected, name
            assert (saved / (path.name + ".txt")).read_bytes() == raw
            files[path.name] = raw

        if item["name"] in programs:
            assert programs[item["name"]] == files

        programs[item["name"]] = files
        native = json.loads((directory / "native.json").read_text())
        assert len(native) == 1
        assert (native[0]["identity"] is not None) == (item["route"] == "library")
        modules = json.loads((directory / "modules.json").read_text())
        assert len(modules) > 1

    for item in execution["executions"]:
        assert item["exit_code"] == item["signature_exit"] == 0
        record = item["execution"]
        directory = Path(item["directory"])
        saved = doc / "生成源码" / mode / item["name"] / "runtime" / item["root_name"]
        assert record == json.loads((directory / "execution.json").read_text())
        assert record["status"] == 0 and record["signal"] is None and record["error"] is None
        assert sha(Path(record["binary"]).read_bytes()) == item["binary_sha256"] == record["binary_sha256"]
        assert sha((directory / "options.zig").read_bytes()) == item["options_sha256"]
        raw = Path(item["log"]).read_bytes()
        assert sha(raw) == item["log_sha256"]
        assert (doc / "日志" / mode / Path(item["log"]).name).read_bytes() == raw
        total = 1 if item["root_name"] == "capacity_test" else 6
        expected = re.findall(r'^test "([^"\n]+)"', Path(record["source"]).read_text(), re.MULTILINE)
        raw = (directory / "execution.log").read_text()
        names = re.findall(r"\d+/" + str(total) + r" .*?\.test\.(.+?)\.\.\.", raw)
        assert names == record["names"] == expected and len(names) == total
        assert "All " + str(total) + " tests passed." in raw

        if item["root_name"] == "capacity_test":
            samples = {int(count): int(capacity) for count, capacity in re.findall(r"count=(\d+) capacity=(\d+)", raw)}
            assert set(samples) == {0, 1, 64, 257, 4096}
            assert samples[4096] <= samples[1]

        for name in ["execution.log", "execution.json", "options.zig"]:
            assert (saved / (name + ".txt")).read_bytes() == (directory / name).read_bytes()

        count += len(names)

assert count == 312

for path in doc.rglob("*.zx"):
    lines = re.split(r"\r\n|\r|\n", path.read_text())
    assert len(lines) - int(lines[-1] == "") <= 120, path

for path in doc.rglob("*.md"):
    assert len(path.read_text().split("\n")) < 1000, path

print("PASS: three borrowed context shapes, source and compiled consumers, 312 actual named checks, 72 runtime binaries with capacity gates and two compiler tools")
