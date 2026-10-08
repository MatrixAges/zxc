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

for info in inputs["external_inputs"].values():
    assert sha(Path(info["snapshot"]).read_bytes()) == info["sha256"]

for name in inputs["formal"]:
    assert (doc / "草稿" / name).read_bytes() == (root / name).read_bytes(), name

generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
assert len(generation["generated"]) == 81
assert sha((run / "generate-parser").read_bytes()) == generation["generator_binary_sha256"]

for name, expected in generation["generated"].items():
    assert sha(Path(name).read_bytes()) == expected, name

for step in generation["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    assert (doc / "日志" / Path(step["log"]).name).read_bytes() == Path(step["log"]).read_bytes()

checks = 0
programs = {}

for mode in ["Debug", "ReleaseSafe"]:
    generated = json.loads((doc / (mode + "-generation.json")).read_text())
    execution = json.loads((doc / (mode + "-execution.json")).read_text())
    assert generated == json.loads((run / (mode + "-generation.json")).read_text())
    assert execution == json.loads((run / (mode + "-execution.json")).read_text())
    assert generated["status"] == execution["status"] == "terminal"
    assert generated["exit_code"] == execution["exit_code"] == 0
    assert len(generated["drivers"]) == 2 and len(generated["programs"]) == 5
    assert len(execution["executions"]) == 6

    for driver in generated["drivers"]:
        assert driver["compile_exit"] == driver["signature_exit"] == driver["execute_exit"] == 0
        assert sha(Path(driver["binary"]).read_bytes()) == driver["binary_sha256"]
        assert sha(Path(driver["source"]).read_bytes()) == driver["source_sha256"]

        for name, expected in driver["external"].items():
            assert sha(Path(name).read_bytes()) == expected, name

        for key in ["log", "compile_log"]:
            raw = Path(driver[key]).read_bytes()
            assert sha(raw) == driver[key + "_sha256"]
            assert (doc / "日志" / mode / Path(driver[key]).name).read_bytes() == raw

    frames = {}
    raw = Path(generated["drivers"][0]["log"]).read_bytes()

    for piece in raw.split(b"\x1e")[1:]:
        label, separator, rest = piece.partition(b"\x1f")
        emitted, end, _ = rest.partition(b"\x1d")
        assert separator and end
        frames[label.decode().removesuffix(".zx")] = emitted

    assert len(frames) == 4

    for item in generated["programs"]:
        name = item["method"]
        source = Path(item["source_path"]).read_bytes()
        assert sha(source) == item["source_sha256"]
        assert (doc / "生成源码" / mode / (name + ".zig.txt")).read_bytes() == source
        assert sha(Path(item["test_path"]).read_bytes()) == item["test_sha256"]
        assert (doc / "生成源码" / mode / (name + "_test.zig.txt")).read_bytes() == Path(item["test_path"]).read_bytes()
        assert sha(Path(item["catalog_path"]).read_bytes()) == item["catalog_sha256"]
        rows = [json.loads(line) for line in Path(item["catalog_path"]).read_text().split("\n") if line]
        assert [row["id"] for row in rows] == item["names"]

        if name in frames:
            assert frames[name] == source

        if name in programs:
            assert programs[name] == source

        programs[name] = source

    for item in execution["executions"]:
        assert item["compile_exit"] == item["signature_exit"] == item["exit_code"] == 0
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        assert sha(Path(item["source_path"]).read_bytes()) == item["source_sha256"]
        assert sha(Path(item["test_path"]).read_bytes()) == item["test_sha256"]
        raw = Path(item["log"]).read_bytes()
        assert sha(raw) == item["log_sha256"]
        assert (doc / "日志" / mode / Path(item["log"]).name).read_bytes() == raw
        names = [match[1] for line in raw.decode().split("\n") if (match := re.fullmatch(r"\d+/\d+ .*\.test\.(.+)\.\.\.OK", line))]
        assert names == item["names"], (item["method"], names)
        checks += len(names)

assert checks == 184
originals = json.loads((doc / "原文身份.json").read_text())
original_runs = json.loads((doc / "原文执行证据.json").read_text())
assert len(originals) == 5 and len(original_runs["records"]) == 10
assert sum(len(record["observed"]) for record in original_runs["records"]) == 10
upstream = Path.home() / ".codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd"

for name, expected in original_runs["harness"].items():
    assert sha((upstream / "harness" / name).read_bytes()) == expected

lock = inputs["upstream_lock"]
assert json.loads((root / "packages/test/upstream/lock.json").read_text()) == lock
assert sha((upstream.parent / (lock["revision"] + ".tar.gz")).read_bytes()) == lock["archive_sha256"]
index = {}

for path in (root / "packages/test/upstream/index").glob("*.jsonl"):
    for line in path.read_text().split("\n"):
        if line:
            row = json.loads(line)
            index[row["path"]] = row["sha256"]

for original in originals:
    assert index[original["path"]] == original["sha256"]

for original in originals:
    raw = (doc / original["saved"]).read_bytes()
    assert sha(raw) == original["sha256"]
    assert (upstream / original["path"]).read_bytes() == raw
    matching = [record for record in original_runs["records"] if record["path"] == original["path"] and record["sha256"] == original["sha256"]]
    assert len(matching) == 2 and {row["strict"] for row in matching} == {False, True}

matrix = json.loads((doc / "矩阵审计.json").read_text())
assert matrix["catalog_cases"] == 128614
assert matrix["reviewed"] == {"adapted": 823, "excluded": 2081, "equivalent": 103}
assert matrix["unreviewed"] == 50590 and matrix["linked_cases"] == 6953

tools = json.loads((doc / "工具检查.json").read_text())
assert {item["name"] for item in tools} == {"typecheck", "generator_check"}
assert all(item["exit_code"] == 0 for item in tools)

for method in ["map", "filter", "every", "some"]:
    source = doc / "源程序" / (method + ".zx")
    assert source.read_bytes() == (root / ("packages/test/tests/built_ins/list/callbacks/" + method + "/context/cases.zx")).read_bytes()

for path in doc.rglob("*.zx"):
    text = path.read_text()
    physical = re.split(r"\r\n|\r|\n", text)
    assert len(physical) - int(physical[-1] == "") <= 120, path

archive = doc / "路径边界首轮"
first = json.loads((archive / "执行输入.json").read_text())
first_run = Path(first["run"])

for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((archive / (mode + "-generation.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 1
    assert state == json.loads((first_run / (mode + "-generation.json")).read_text())

    for driver in state["drivers"]:
        for key in ["log", "compile_log"]:
            if key in driver:
                raw = Path(driver[key]).read_bytes()
                assert sha(raw) == driver[key + "_sha256"]
                assert (archive / "日志" / mode / Path(driver[key]).name).read_bytes() == raw

    assert b"embed of file outside package path" in Path(state["drivers"][-1]["compile_log"]).read_bytes()

for name in first["formal"]:
    assert sha((archive / "草稿" / name).read_bytes()) == first["packages"][name]

for path in doc.rglob("*.md"):
    assert len(path.read_text().split("\n")) < 1000, path

print("PASS: five upstream observations, ten original executions, 184 actual native checks, twelve runtime binaries and four public compiler drivers")
