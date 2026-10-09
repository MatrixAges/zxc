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

for name, identity in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == identity, name

for name in inputs["formal"]:
    assert (root / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

for name, identity in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == identity, name

for original in json.loads((doc / "原文身份.json").read_text()):
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]

originals = json.loads((doc / "原文执行证据.json").read_text())
assert len(originals["records"]) == 4
assert all(len(entry["observed"]) == 1 for entry in originals["records"])
assert {entry["strict"] for entry in originals["records"]} == {False, True}

for name, entry in json.loads((doc / "证据归档.json").read_text()).items():
    assert sha((doc / name).read_bytes()) == entry["sha256"], name
    assert sha(Path(entry["source"]).read_bytes()) == entry["sha256"], entry["source"]

for name, entry in json.loads((doc / "外部输入.json").read_text()).items():
    assert sha(Path(name).read_bytes()) == entry["sha256"]
    assert sha((doc / entry["saved"]).read_bytes()) == entry["sha256"]

generator = json.loads((doc / "生成器证据.json.txt").read_text())
assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert len(generator["generated"]) == 85
assert all(step["exit_code"] == 0 for step in generator["steps"])

for name, identity in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == identity

expected_names = re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests/collections/callback_arguments/root.zig").read_text(), re.M)
assert len(expected_names) == 9
native_count = 0
pure_count = 0
binaries = []
generated = {}

for mode in ["Debug", "ReleaseSafe"]:
    generation = json.loads((doc / (mode + "-generation.json.txt")).read_text())
    execution = json.loads((doc / (mode + "-execution.json.txt")).read_text())
    pure = json.loads((doc / (mode + "-pure.json.txt")).read_text())

    for state in [generation, execution, pure]:
        assert state["status"] == "terminal" and state["exit_code"] == 0

    assert generation["compile_exit"] == generation["signature_exit"] == 0
    parser_option = next(argument.split("=", 1)[1] for argument in generation["compile_command"] if argument.startswith("-Mparser_options="))
    assert "generated_parser: bool = true" in Path(parser_option).read_text()
    assert len(generation["programs"]) == len(execution["executions"]) == 8
    assert len(pure["programs"]) == 4
    binaries.append((generation["compile_command"][-3].split("=", 1)[1], generation["binary_sha256"]))
    binaries.append((pure["tool"], pure["tool_sha256"]))
    generated[mode] = {}

    for program in generation["programs"]:
        assert program["exit_code"] == 0
        assert sha(Path(program["fixture"]).read_bytes()) == program["fixture_sha256"]
        assert sha(Path(program["declaration"]).read_bytes()) == program["declaration_sha256"]
        generated[mode][program["name"]] = {Path(name).name: identity for name, identity in program["files"].items()}

    for entry in execution["executions"]:
        actual = entry["execution"]
        assert entry["exit_code"] == entry["signature_exit"] == actual["status"] == 0
        assert actual["signal"] is None and actual["error"] is None
        assert actual["names"] == expected_names
        log = Path(entry["log"]).read_bytes()
        assert sha(log) == entry["log_sha256"]
        assert "All 9 tests passed." in log.decode()
        binaries.append((actual["binary"], actual["binary_sha256"]))
        native_count += len(actual["names"])

    for step in pure["steps"]:
        assert step["exit_code"] == 0
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]

    for program in pure["programs"]:
        for field in ["source", "catalog", "test_source", "output", "binary"]:
            assert sha(Path(program[field]).read_bytes()) == program[field + "_sha256"]

        rows = [json.loads(line)["id"] for line in Path(program["catalog"]).read_text().split("\n") if line.strip()]
        log = Path(program["execution_log"]).read_text()
        assert re.findall(r"\d+/25 .*?\.test\.(.+?)\.\.\.", log) == rows == program["names"]
        assert "All 25 tests passed." in log
        binaries.append((program["binary"], program["binary_sha256"]))
        pure_count += len(rows)

assert generated["Debug"] == generated["ReleaseSafe"]
assert native_count == 144 and pure_count == 200
assert len(binaries) == 28

for name, identity in binaries:
    assert sha(Path(name).read_bytes()) == identity
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", name], check=True, capture_output=True)

for name in inputs["formal"]:
    if name.endswith(".zx"):
        source = (root / name).read_text()
        assert len(re.split(r"\r\n|\r|\n", source.rstrip("\r\n"))) <= 120, name

for entry in json.loads((doc / "静态检查.json").read_text()):
    assert entry["exit_code"] == 0
    assert sha((doc / entry["log"]).read_bytes()) == entry["sha256"]

matrix = json.loads((doc / "矩阵审计.json.txt").read_text())
assert matrix["catalog_cases"] == 128715 and matrix["reviewed"]["adapted"] == 826
print("PASS: 344 named test executions in 24 runtime binaries; two original files in both modes; frozen inputs and signed tools verified")
