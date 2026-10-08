from pathlib import Path
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
first = json.loads((doc / "首轮执行输入.json").read_text())
root = Path(baseline["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path
    assert sha((Path(first["snapshot"]) / path).read_bytes()) == first["inputs"][path], path

changed = [path for path in baseline["inputs"] if baseline["inputs"][path] != first["inputs"][path]]
assert changed == ["packages/test/src/data/array_callbacks.jsonl"]
old_rows = (Path(first["snapshot"]) / changed[0]).read_text().split("\n")
new_rows = (root / changed[0]).read_text().split("\n")
assert [json.loads(row) for row in old_rows if row] == [json.loads(row) for row in new_rows if row]

for path, identity in baseline["toolchain_inputs"].items():
    assert sha(Path(path).read_bytes()) == identity, path

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "草稿" / path).read_bytes(), path

for path in [changed[0], "packages/test/upstream/reviews/built_ins/array/callbacks.jsonl"]:
    previous = subprocess.check_output(["git", "show", baseline["source_commit"] + ":" + path], cwd=root)
    assert (root / path).read_bytes().startswith(previous), path

actual = json.loads((doc / "最终实际执行证据.json").read_text())
assert len(actual) == 16

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / ("首轮" + mode + "完整证据.json")).read_text())
    assert evidence["passed"] and evidence["checks_passed"] == evidence["checks_total"] == 121
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    cached = json.loads((doc / (mode + "完整证据.json")).read_text())
    assert cached["passed"] and not cached["actual_executions"]
    assert cached["checks_total"] is None
    assert sha((doc / cached["log"]).read_bytes()) == cached["log_sha256"]
    runs = [run for run in actual if run["mode"] == mode]
    assert len(runs) == 8 and sum(run["tests"] for run in runs) == 121

    for run in runs:
        assert run["exit_code"] == 0
        assert sha(Path(run["command"][0]).read_bytes()) == run["binary_sha256"]
        raw = (doc / run["log"]).read_bytes()
        assert sha(raw) == run["log_sha256"]
        assert sum(line.endswith("...OK") for line in raw.decode().split("\n")) == run["tests"]
        original = next(item for item in evidence["actual_executions"] if item["path"] == run["command"][0])
        assert original["sha256"] == run["binary_sha256"] and original["compiled"] == run["compiled"]

    for keep in ["false", "true"]:
        run = next(item for item in runs if item["name"] == "array-callbacks-filter-constant-" + keep)
        assert run["tests"] == 10
        rows = [json.loads(row) for row in (root / ("packages/test/tests/built_ins/list/callbacks/filter/constant_" + keep + "/cases.jsonl")).read_text().split("\n") if row]
        log = (doc / run["log"]).read_text()
        assert len(rows) == 10 and all(row["id"] in log for row in rows)

    for item in evidence["generated_source"]:
        data = Path(item["path"]).read_bytes()
        assert sha(data) == item["sha256"]
        if "saved" in item:
            assert (doc / item["saved"]).read_bytes() == data

shape = json.loads((doc / "输出类别执行证据.json").read_text())
assert len(shape) == 4

for item in shape:
    assert item["compile_exit_code"] == item["run_exit_code"] == 0
    assert sha(Path(item["program"]).read_bytes()) == item["program_sha256"]
    assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
    assert sha((doc / "输出类别检查.zig.txt").read_bytes()) == item["root_sha256"]
    assert sha((doc / item["saved_log"]).read_bytes()) == item["log_sha256"]

originals = json.loads((doc / "原文执行证据.json").read_text())["records"]
assert len(originals) == 6 and sum(len(item["observed"]) for item in originals) == 10

for item in originals:
    assert sha((doc / "原文" / (Path(item["path"]).name + ".txt")).read_bytes()) == item["sha256"]

print("PASS: final frozen inputs, cached gates separated, 242 actual checks, four real slice ABI checks and ten original assertions")
