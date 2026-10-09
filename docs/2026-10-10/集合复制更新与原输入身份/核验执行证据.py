from pathlib import Path

import hashlib
import gzip
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()


def saved_bytes(record):
    data = (doc / record["saved"]).read_bytes()
    encoding = record.get("encoding")
    assert encoding in [None, "gzip"]
    return gzip.decompress(data) if encoding == "gzip" else data


for record in json.loads((doc / "宿主签名预检清单.json").read_text()):
    assert sha((doc / record["saved"]).read_bytes()) == record["sha256"]
probe = doc / "宿主签名预检"
assert json.loads((probe / "terminal.json.txt").read_text())["exit_code"] == 0
assert json.loads((probe / "terminal.json.r1.txt.txt").read_text())["exit_code"] == 1
assert "Build Summary: 5/5 steps succeeded" in (probe / "build.log.txt").read_text()
signatures = json.loads((probe / "signatures.json.txt").read_text())
assert {record["name"]: record["signature_exit_code"] for record in signatures} == {"configurer": 1, "default": 1, "entitled": 0}
for record in signatures:
    assert sha(Path(record["path"]).read_bytes()) == record["sha256"]
    result = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", record["path"]], capture_output=True)
    assert result.returncode == record["signature_exit_code"]
for record in json.loads((doc / "基线证据清单.json").read_text()):
    assert sha(saved_bytes(record)) == record["sha256"]
baseline = json.loads((doc / "基线核验.json").read_text())
assert baseline["source_commit"] == "6bb97d60c344c1dbbe5f954c2f8c71a2107afbe8"
assert baseline["verifier_exit_code"] == 0 and baseline["named_executions"] == 1008 and baseline["signed_binaries"] == 16
assert sha((doc / "基线执行证据/脚本/核验执行证据.py.txt").read_bytes()) == baseline["verifier_sha256"]
baseline_inputs = json.loads((doc / "基线执行证据/脚本/执行输入.json.txt").read_text())
changed = {name for name in inputs["formal_sha256"] if inputs["formal_sha256"][name] != baseline_inputs["formal_sha256"][name]}
assert changed == {"packages/test/src/generate_immutable_list.ts"}
for name in ["前置复核清单.json", "失败诊断清单.json"]:
    for record in json.loads((doc / name).read_text()):
        assert sha((doc / record["saved"]).read_bytes()) == record["sha256"]
for mode in ["Debug", "ReleaseSafe"]:
    failed = json.loads((doc / "失败诊断" / (mode + "状态.json.txt")).read_text())
    assert failed["status"] == "terminal" and failed["exit_code"] == 1 and not failed["programs"]
    assert [step["exit_code"] for step in failed["steps"]] == [0, 0, 0, 1]
preflight = json.loads((doc / "预检状态.json").read_text())
assert len(preflight["programs"]) == 4 and preflight["named_executions"] == 252
for program in preflight["programs"]:
    assert sha(Path(program["binary"]).read_bytes()) == program["binary_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", program["binary"]], check=True, capture_output=True)
    for name, identity in program["files"].items():
        assert sha(Path(name).read_bytes()) == identity
    for step in program["steps"]:
        assert step["exit_code"] == 0 and sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    log = Path(program["steps"][-1]["log"]).read_text()
    names = program["names"]
    assert re.findall(r"\d+/" + str(len(names)) + r" .*?\.test\.(.+?)\.\.\.", log) == names
    assert "All " + str(len(names)) + " tests passed." in log
for group in ["packages", "formal_sha256"]:
    for name, identity in inputs[group].items():
        assert sha((root / name).read_bytes()) == identity, name
for group in ["tools", "external"]:
    for name, identity in inputs[group].items():
        assert sha(Path(name).read_bytes()) == identity, name
for item in json.loads((doc / "证据清单.json").read_text()):
    assert sha(Path(item["source"]).read_bytes()) == item["sha256"]
    assert sha(saved_bytes(item)) == item["sha256"]
for check in json.loads((doc / "静态检查.json").read_text()):
    assert check["exit_code"] == 0
    if "path" in check:
        path = Path(check["path"])
        assert sha((path if path.is_absolute() else root / path).read_bytes()) == check["sha256"]
    if "log" in check:
        assert sha(Path(check["log"]).read_bytes()) == check["log_sha256"]
generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
assert len(generation["steps"]) == 6 and len(generation["generated"]) == 85
assert len(inputs["generator_run"][2:-2]) == 84
for group in ["generated", "tool_binaries"]:
    for name, identity in generation[group].items():
        assert sha(Path(name).read_bytes()) == identity
        if group == "tool_binaries":
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", name], check=True, capture_output=True)
for step in generation["steps"]:
    assert step["exit_code"] == 0
    assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
originals = json.loads((doc / "原文身份.json").read_text())
official = json.loads((doc / "原文执行证据.json").read_text())
assert sha((doc / "执行原文.mjs").read_bytes()) == official["runner_sha256"]
assert sha(Path("/usr/local/bin/node").read_bytes()) == official["node_sha256"]
assert len(originals) == 4 and len(official["records"]) == 8
assert sum(len(record["observed"]) for record in official["records"]) == 20
for name, identity in official["harness"].items():
    assert sha((doc / "原文" / (name + ".txt")).read_bytes()) == identity
for original in originals:
    assert sha((doc / original["saved"]).read_bytes()) == original["sha256"]
    records = [record for record in official["records"] if record["path"] == original["path"]]
    assert {record["strict"] for record in records} == {False, True}
    for record in records:
        assert record["sha256"] == original["sha256"] and len(record["observed"]) == original["assertion_count"]
        first, *identities = record["observed"]
        assert first["kind"] == "compareArray" and first["actual"] == first["expected"]
        assert all(item == {"kind": "notSameValue", "distinct": True} for item in identities)
reviews = [json.loads(line) for line in (root / "packages/test/upstream/reviews/built_ins/array/immutable_list.jsonl").read_text().splitlines()]
assert {row["path"]: row["sha256"] for row in reviews} == {row["path"]: row["sha256"] for row in originals}
catalogs = {}
ids = set()
for suite in inputs["suites"]:
    operation = suite["operation"]
    path = root / ("packages/test/tests/" + suite["path"] + ".jsonl")
    rows = [json.loads(line) for line in path.read_text().splitlines() if line.strip()]
    assert len(rows) == suite["count"] and sum(row["check"] == "allocations" for row in rows) == 1
    for row in rows:
        assert row["id"] not in ids
        ids.add(row["id"])
        assert row["input"]["items"] == row["later"]["items"] and row["input"]["replacement"] == row["later"]["replacement"]
        for name, expected in [("input", "value"), ("later", "later")]:
            data = row[name]
            values = list(data["items"])
            if operation == "reverse":
                values.reverse()
            elif operation == "sort":
                values.sort()
            elif operation == "splice":
                values[data["index"]:data["index"] + data["count"]] = data["replacement"]
            else:
                values[data["index"]] = data["value"]
            assert row["expected"][expected] == values
        assert row["expected"]["unchanged"] is True
        assert row["expected"]["new_storage"] == bool(row["expected"]["value"])
        assert row["expected"]["later_new_storage"] == bool(row["expected"]["later"])
    original = rows[0]
    assert original["id"].endswith("/original")
    assert original["input"]["items"] == ([2, 0, 1] if operation in ["sort", "splice"] else [0, 1, 2])
    if operation == "splice":
        assert original["input"]["index"] == original["input"]["count"] == 0
        assert original["later"]["count"] == 1 and original["input"]["replacement"] == [-1]
    if operation == "with":
        assert original["input"]["index"] == 1 and original["input"]["value"] == 3
        assert original["later"]["value"] == original["input"]["items"][1] == 1
    review = next(review for review in reviews if review["cases"] == [original["id"]])
    assert len(review["assertions"]) == (3 if operation in ["splice", "with"] else 2)
    assert all(original["expected"][assertion["field"]] == assertion["expected"] for assertion in review["assertions"])
    catalogs[operation] = rows
assert len(ids) == 252
mode_bytes = {}
for mode in ["Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-execution.json")).read_text())
    assert state["status"] == "terminal" and state["exit_code"] == 0
    assert len(state["steps"]) == 17 and len(state["programs"]) == 8 and state["named_executions"] == 504
    assert sha(Path(state["tool"]).read_bytes()) == state["tool_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", state["tool"]], check=True, capture_output=True)
    for step in state["steps"]:
        assert step["exit_code"] == 0 and "--test-no-exec" not in step["command"]
        assert sha(Path(step["log"]).read_bytes()) == step["log_sha256"]
    seen = set()
    for program in state["programs"]:
        key = (program["operation"], program["route"])
        assert key not in seen
        seen.add(key)
        expected = [row["id"] for row in catalogs[program["operation"]]]
        assert program["names"] == expected and program["signature_verified"]
        source = root / ("packages/test/tests/built_ins/list/immutable/" + program["operation"] + ".zx")
        assert sha(source.read_bytes()) == program["source_sha256"]
        assert sha(source.with_suffix(".jsonl").read_bytes()) == program["catalog_sha256"]
        assert sha(Path(program["binary"]).read_bytes()) == program["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", program["binary"]], check=True, capture_output=True)
        for name, identity in program["files"].items():
            path = Path(name)
            assert sha(path.read_bytes()) == identity
            if path.suffix == ".log":
                text = path.read_text()
                assert re.findall(r"\d+/" + str(len(expected)) + r" .*?\.test\.(.+?)\.\.\.", text) == expected
                assert "All " + str(len(expected)) + " tests passed." in text
                assert text.count("Immutable list allocation sweep completed") == 1
            else:
                byte_key = (program["operation"], path.name)
                if mode == "Debug":
                    mode_bytes[byte_key] = path.read_bytes()
                else:
                    assert mode_bytes[byte_key] == path.read_bytes()
    assert seen == {(operation, route) for operation in catalogs for route in ["source", "library"]}
    previous = json.loads((doc / "基线执行证据" / (mode + "状态.json.txt")).read_text())
    assert previous["status"] == "terminal" and previous["exit_code"] == 0 and previous["named_executions"] == 504
    assert len(previous["steps"]) == 17 and len(previous["programs"]) == 8
    for program in previous["programs"]:
        assert program["names"] == [row["id"] for row in catalogs[program["operation"]]]
        assert sha(Path(program["binary"]).read_bytes()) == program["binary_sha256"]
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", program["binary"]], check=True, capture_output=True)
        for path, identity in program["files"].items():
            assert sha(Path(path).read_bytes()) == identity
print("PASS: 252 cases; 1008 Indexed and 1008 baseline executions; 32 signed binaries; 85 fresh compiler modules; 8 originals and 20 official assertions")
