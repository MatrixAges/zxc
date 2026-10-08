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

for name, expected in inputs["identical_production_inputs"].items():
    assert not name.startswith("packages/test/")
    assert sha((root / name).read_bytes()) == expected, name

assert not subprocess.check_output(["git", "diff", "--name-only", inputs["parser_generation_source_commit"], inputs["source_commit"], "--", "packages", ":!packages/test"], cwd=root)

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

count = 0
programs = {}
expected_roots = {method + "_" + suffix for method in ["map", "filter", "every", "some"] for suffix in ["used", "ignored"]}

for mode in ["Debug", "ReleaseSafe"]:
    generation = json.loads((doc / (mode + "-generation.json")).read_text())
    execution = json.loads((doc / (mode + "-execution.json")).read_text())
    assert generation == json.loads((run / (mode + "-generation.json")).read_text())
    assert execution == json.loads((run / (mode + "-execution.json")).read_text())
    assert generation["status"] == execution["status"] == "terminal"
    assert generation["exit_code"] == execution["exit_code"] == 0
    assert generation["compile_exit"] == generation["signature_exit"] == 0
    assert sha(Path(next(arg.removeprefix("-femit-bin=") for arg in generation["compile_command"] if arg.startswith("-femit-bin="))).read_bytes()) == generation["binary_sha256"]
    assert len(generation["programs"]) == len(execution["executions"]) == 8
    assert {item["name"] for item in generation["programs"]} == expected_roots
    assert {item["name"] for item in execution["executions"]} == expected_roots

    for name, expected in generation["external"].items():
        assert sha(Path(name).read_bytes()) == expected, name

    raw = Path(generation["compile_log"]).read_bytes()
    assert sha(raw) == generation["compile_log_sha256"]
    assert (doc / "日志" / mode / "compile.txt").read_bytes() == raw
    assert sha(Path(generation["options"]).read_bytes()) == generation["options_sha256"]

    for item in generation["programs"]:
        assert item["exit_code"] == 0
        assert sha(Path(item["fixture"]).read_bytes()) == item["fixture_sha256"]
        raw = Path(item["log"]).read_bytes()
        assert sha(raw) == item["log_sha256"]
        assert (doc / "日志" / mode / Path(item["log"]).name).read_bytes() == raw
        pair = []

        for key, suffix in [("source", ".zig.txt"), ("types", "_abi.zig.txt")]:
            raw = Path(item[key]).read_bytes()
            assert sha(raw) == item[key + "_sha256"]
            assert (doc / "生成源码" / mode / (item["name"] + suffix)).read_bytes() == raw
            pair.append(raw)

        if item["name"] in programs:
            assert programs[item["name"]] == pair

        programs[item["name"]] = pair

    for item in execution["executions"]:
        assert item["compile_exit"] == item["signature_exit"] == item["exit_code"] == 0
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        assert sha(Path(item["options"]).read_bytes()) == item["options_sha256"]

        for key in ["log", "compile_log"]:
            raw = Path(item[key]).read_bytes()
            assert sha(raw) == item[key + "_sha256"]
            assert (doc / "日志" / mode / Path(item[key]).name).read_bytes() == raw

        raw = Path(item["log"]).read_text()
        names = [match[1] for line in raw.split("\n") if (match := re.fullmatch(r"\d+/8 .*\.test\.(.+)\.\.\.OK", line))]
        assert names == item["names"] and len(names) == 8
        assert "All 8 tests passed." in raw
        count += len(names)

assert count == 128

archive = doc / "格式首轮"
first = json.loads((archive / "执行输入.json").read_text())
first_run = Path(first["run"])

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((archive / (mode + "-generation.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 1
    assert state == json.loads((first_run / (mode + "-generation.json")).read_text())
    assert state["programs"][0]["exit_code"] == 1

    for file in (archive / "日志" / mode).glob("*.txt"):
        assert file.read_bytes() == (first_run / mode / file.name).read_bytes()

    assert b"spacing:" in Path(state["programs"][0]["log"]).read_bytes()

for name in first["formal"]:
    assert sha((archive / "草稿" / name).read_bytes()) == first["packages"][name]

abi_archive = doc / "宿主ABI首轮"
prior = json.loads((abi_archive / "执行输入.json").read_text())
prior_run = Path(prior["run"])
failed = json.loads((abi_archive / "Debug-execution.json").read_text())
assert failed == json.loads((prior_run / "Debug-execution.json").read_text())
assert failed["status"] == "terminal" and failed["exit_code"] == 1
assert failed["executions"][0]["compile_exit"] == 1
assert b"does not support struct initialization syntax" in Path(failed["executions"][0]["compile_log"]).read_bytes()

for mode in ["Debug", "ReleaseSafe"]:
    for file in (abi_archive / "日志" / mode).glob("*.txt"):
        assert file.read_bytes() == (prior_run / mode / file.name).read_bytes()

for name in prior["formal"]:
    assert sha((abi_archive / "草稿" / name).read_bytes()) == prior["packages"][name]

for path in doc.rglob("*.zx"):
    lines = re.split(r"\r\n|\r|\n", path.read_text())
    assert len(lines) - int(lines[-1] == "") <= 120, path

for path in doc.rglob("*.md"):
    assert len(path.read_text().split("\n")) < 1000, path

print("PASS: eight real context programs, 128 actual named checks, sixteen runtime binaries, two compiler tools and identical production inputs for parser reuse")
