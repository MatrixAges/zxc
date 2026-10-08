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

for name in inputs["formal"]:
    assert (root / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

for name, expected in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == expected

for item in inputs["external_inputs"].values():
    assert sha(Path(item["snapshot"]).read_bytes()) == item["sha256"]

def log(item, mode, prefix=""):
    path = Path(item[prefix + "log"])
    assert sha(path.read_bytes()) == item[prefix + "log_sha256"]
    assert path.read_bytes() == (doc / "日志" / mode / path.name).read_bytes()
    return path.read_text()


def signed(path, identity):
    assert sha(Path(path).read_bytes()) == identity
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(path)], check=True)


generator = json.loads((doc / "生成器证据.json").read_text())
assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert len(generator["generated"]) == 81
signed(run / "generate-parser", generator["generator_binary_sha256"])

for name, identity in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == identity

for step in generator["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    assert Path(step["log"]).read_bytes() == (doc / "日志/生成器" / Path(step["log"]).name).read_bytes()

names = re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests/collections/reduce_initial/root.zig").read_text(), re.M)
assert len(names) == 8
emitted_by_mode = {}

for mode in ["Debug", "ReleaseSafe"]:
    generation = json.loads((doc / (mode + "-generation.json")).read_text())
    execution = json.loads((doc / (mode + "-execution.json")).read_text())
    pure = json.loads((doc / (mode + "-pure.json")).read_text())

    for state in [generation, execution, pure]:
        assert state["status"] == "terminal" and state["exit_code"] == 0

    assert generation["compile_exit"] == 0 and generation["signature_exit"] == 0
    log(generation, mode, "compile_")
    signed(run / mode / "compile-reduce-initial", generation["binary_sha256"])
    assert len(generation["programs"]) == len(execution["executions"]) == 8
    expected = {kind + "-" + initial + "-" + route for kind in ["numeric", "text"] for initial in ["unseeded", "seeded"] for route in ["source", "library"]}
    assert {item["name"] for item in generation["programs"]} == expected
    assert {item["name"] for item in execution["executions"]} == expected
    emitted_by_mode[mode] = {}

    for item in generation["programs"]:
        assert item["exit_code"] == 0
        log(item, mode)
        assert sha(Path(item["fixture"]).read_bytes()) == item["fixture_sha256"]
        assert sha(Path(item["declaration"]).read_bytes()) == item["declaration_sha256"]

        for path, identity in item["files"].items():
            assert sha(Path(path).read_bytes()) == identity
            assert Path(path).read_bytes() == (doc / "生成源码" / mode / item["name"] / (Path(path).name + ".txt")).read_bytes()
            emitted_by_mode[mode][item["name"] + "/" + Path(path).name] = identity

    for item in execution["executions"]:
        actual = item["execution"]
        assert item["exit_code"] == actual["status"] == 0
        assert actual["signal"] is None and actual["error"] is None
        assert actual["names"] == names and item["signature_exit"] == 0
        assert item["binary_sha256"] == actual["binary_sha256"]
        signed(actual["binary"], actual["binary_sha256"])
        log(item, mode)
        runtime = Path(item["directory"])
        assert "All 8 tests passed." in (runtime / "execution.log").read_text()
        assert sha((runtime / "options.zig").read_bytes()) == item["options_sha256"]
        assert "--test-no-exec" not in actual["argv"]
        for name in ["execution.log", "execution.json", "options.zig"]:
            assert (runtime / name).read_bytes() == (doc / "生成源码" / mode / item["name"] / "runtime/root" / (name + ".txt")).read_bytes()

    for step in pure["steps"]:
        assert step["exit_code"] == 0
        log(step, mode)
    assert "All 1 tests passed." in Path(pure["steps"][-1]["log"]).read_text()
    signed(pure["binary"], pure["binary_sha256"])
    signed(pure["compiler_binary"], pure["compiler_sha256"])
    assert sha(Path(pure["output"]).read_bytes()) == pure["output_sha256"]
    assert Path(pure["output"]).read_bytes() == (doc / "生成源码" / mode / "singleton.zig.txt").read_bytes()

assert emitted_by_mode["Debug"] == emitted_by_mode["ReleaseSafe"]
originals = json.loads((doc / "原文身份.json").read_text())
records = json.loads((doc / "原文执行证据.json").read_text())["records"]
assert len(records) == 4
assert sum(len(item["observed"]) for item in records) == 6

for original in originals:
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]
    matches = [item for item in records if item["path"] == original["path"]]
    assert {item["strict"] for item in matches} == {False, True}
    for item in matches:
        assert item["sha256"] == original["sha256"]
        assert len(item["observed"]) == original["assertion_count"]

archive = doc / "首轮声明失败"
previous = json.loads((archive / "执行输入.json").read_text())
previous_run = Path(previous["run"])

for mode in ["Debug", "ReleaseSafe"]:
    failed = json.loads((archive / (mode + "-generation.json")).read_text())
    assert failed["status"] == "terminal" and failed["exit_code"] == 1
    assert failed["compile_exit"] == 0 and failed["signature_exit"] == 0
    assert len(failed["programs"]) == 1
    item = failed["programs"][0]
    assert item["exit_code"] == 1
    declaration = Path(item["declaration"]).relative_to(root)
    raw = (archive / "草稿" / declaration).read_bytes()
    assert sha(raw) == item["declaration_sha256"]
    assert b"readonly" in raw
    source_log = Path(item["log"])
    assert sha(source_log.read_bytes()) == item["log_sha256"]
    assert source_log.read_bytes() == (archive / "日志" / source_log.relative_to(previous_run)).read_bytes()
    assert "expected a newline, closing block or end of source" in source_log.read_text()

print("PASS: 128 named native checks and 2 exact-source checks in 18 actual binaries; 6 original assertions")
