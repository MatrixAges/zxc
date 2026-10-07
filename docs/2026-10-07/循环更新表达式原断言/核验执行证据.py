from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
fingerprints = json.loads((doc / "执行源码指纹.json").read_text())
assert len(fingerprints["inputs"]) == 5292
for item in fingerprints["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

original = (doc / "上游原文.js.txt").read_bytes()
reference = json.loads((doc / "上游原文执行证据.json").read_text())
assert hashlib.sha256(original).hexdigest() == reference["sha256"] == "20af24357eea8455e30ecd0399d8236d0cbe50bee374049411d6b305ee0389e1"
assert [run["strict"] for run in reference["executions"]] == [False, True]
assert all(run["completed"] and run["original_conditional_checks"] == 9 and run["final"] == {"i": 16, "j": 2} for run in reference["executions"])

modes = ["increment", "multiply", "divide", "decrement", "square"]
original_results = {"increment": (10, None), "multiply": (16, 4), "divide": (1, 4), "decrement": (1, 9), "square": (16, 2)}
linked = []
for mode in modes:
    path = f"packages/test/tests/language/statements/iteration/update/{mode}"
    rows = [json.loads(line) for line in (root / (path + ".jsonl")).read_text().splitlines()]
    assert len(rows) == 7 and len({row["id"] for row in rows}) == 7
    first = rows[0]
    assert first["id"].endswith("/original")
    expected_i, expected_j = original_results[mode]
    assert first["expected"]["value"]["i"] == expected_i
    if expected_j is not None:
        assert first["expected"]["value"]["j"] == expected_j
    linked.append(first)
    source = (root / (path + ".zx")).read_text()
    assert "return loop(in," in source and "while: state =>" in source and "next: state =>" in source
    assert "state.j += 1" in source
    assert "i: f64, j: f64, limit: f64, step: f64" in source

review = json.loads((root / "packages/test/upstream/reviews/language/statements/for_numeric_updates.jsonl").read_text())
assert review["path"] == "test/language/statements/for/S12.6.3_A14.js"
assert review["status"] == "adapted" and review["sha256"] == reference["sha256"]
assert review["cases"] == [row["id"] for row in linked]
assert review["assertions"] == [{"case": row["id"], "field": "value", "expected": row["expected"]["value"]} for row in linked]

suites_path = "packages/test/suites.json"
previous = json.loads((doc / "原始文件" / (suites_path + ".txt")).read_text())
current = json.loads((root / suites_path).read_text())
added = [suite for suite in current["runtime"] if suite["name"].startswith("for-updates-")]
assert len(added) == 5
assert {suite["path"] for suite in added} == {f"language/statements/iteration/update/{mode}" for mode in modes}
current["runtime"] = [suite for suite in current["runtime"] if not suite["name"].startswith("for-updates-")]
assert current == previous

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "证据.json")).read_text())
    assert evidence["exit_code"] == 0 and evidence["passed"] is True
    assert evidence["steps_passed"] == evidence["steps_total"] == 50
    assert evidence["tests_passed"] == evidence["tests_total"] == 35
    assert len(evidence["logged_zig_test_binaries"]) == 5
    assert len(evidence["artifacts"]) == 10
    assert evidence["source_commit"] == fingerprints["source_commit"]
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["summary"].encode() in raw and evidence["errors"] == []
    for binary in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(binary["path"]).read_bytes()).hexdigest() == binary["sha256"]
    for artifact in evidence["artifacts"]:
        data = (doc / artifact["saved"]).read_bytes()
        assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
        assert data == Path(artifact["executed_source"]).read_bytes()

for path in json.loads((doc / "正式路径.json").read_text()):
    assert (root / path).read_bytes() == (doc / "草稿" / path).read_bytes()

matrix = json.loads((doc / "矩阵审计.json").read_text())
assert matrix["catalog_cases"] == 128459 and matrix["unreviewed"] == 50633
print("PASS: all nine original results, actual five loop programs, 35 cases, both modes 70 checks, unchanged old registrations and exact package fingerprints")
