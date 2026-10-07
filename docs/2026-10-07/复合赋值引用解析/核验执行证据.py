from pathlib import Path
import hashlib
import json
import struct
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "输入冻结.json").read_text())
assert len(freeze["paths"]) == 18
for record in freeze["paths"]:
    data = (root / record["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == record["sha256"], record["path"]
    assert data == (doc / "草稿" / record["path"]).read_bytes()

originals = json.loads((doc / "上游原文清单.json").read_text())
assert len(originals) == 42
assert originals == json.loads((root / "packages/test/src/data/compound_references.json").read_text())
assert {kind: sum(row["kind"] == kind for row in originals) for kind in ["lhs", "rhs", "resolved"]} == {"lhs": 20, "rhs": 11, "resolved": 11}
for row in originals:
    data = (doc / "上游原文" / (Path(row["path"]).name + ".txt")).read_bytes()
    assert hashlib.sha256(data).hexdigest() == row["sha256"]
    assert row["operator"].encode() in data

for engine in ["Node", "Bun"]:
    evidence = json.loads((doc / f"上游原文执行证据-{engine}.json").read_text())
    executions = evidence["executions"]
    assert len(executions) == 84
    assert sum(item["same_value"] for item in executions) == 22
    assert sum(item["throws"] for item in executions) == 18
    assert sum(item["original_catch_check"] for item in executions) == 44
    assert {(item["path"], item["strict"]) for item in executions} == {(row["path"], strict) for row in originals for strict in [False, True]}
    for item in executions:
        original = next(row for row in originals if row["path"] == item["path"])
        assert item["passed"] and item["sha256"] == original["sha256"]
        if original["kind"] == "resolved":
            assert item["final_bits"] == struct.pack(">d", original["expected"]).hex()

checks = 0
for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    assert evidence["source_commit"] == freeze["source_commit"] and evidence["checks"] == 179
    assert len(evidence["records"]) == 6
    assert len({item["binary"] for item in evidence["records"]}) == 6
    for item in evidence["records"]:
        assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["sha256"]
        replay = (doc / item["replay"]).read_bytes()
        assert hashlib.sha256(replay).hexdigest() == item["replay_sha256"]
        assert f"All {item['checks']} tests passed.".encode() in replay
        assert item["checks"] == (174 if item["name"] == "conformance-frontend" else 1)
        for artifact in item["artifacts"]:
            assert hashlib.sha256((doc / artifact["path"]).read_bytes()).hexdigest() == artifact["sha256"]
        checks += item["checks"]
assert checks == 358

reviews = [json.loads(line) for line in (root / "packages/test/upstream/reviews/language/expressions/compound_references.jsonl").read_text().splitlines()]
assert len(reviews) == 42
assert {row["path"]: row["sha256"] for row in reviews} == {row["path"]: row["sha256"] for row in originals}
assert sum(row["status"] == "adapted" for row in reviews) == 19
assert sum(row["status"] == "excluded" for row in reviews) == 23
assert all(not row["cases"] for row in reviews if row["status"] == "excluded")
rows = [json.loads(line) for line in (root / "packages/test/tests/language/types/compound_references/cases.jsonl").read_text().splitlines()]
assert len(rows) == 174
assert {code: sum(row["diagnostic"] == code for row in rows) for code in ["name", "ownership", "naming", None]} == {"name": 104, "ownership": 20, "naming": 5, None: 45}
assert {phase: sum(row["phase"] == phase for row in rows) for phase in ["analyze", "compile"]} == {"analyze": 87, "compile": 87}
for row in rows:
    assert "⟦" not in row["source"] and "⟧" not in row["source"]
    assert ("span" in row) == (row["diagnostic"] is not None)
    if "span" in row:
        start, end = row["span"]
        token = row["source"].encode()[start:end].decode()
        assert token.isidentifier(), (row["id"], token)

operations = {"*=": "multiply", "/=": "divide", "%=": "remainder", "+=": "add", "-=": "subtract"}
for original in originals:
    if original["kind"] != "resolved" or original["operator"] not in operations:
        continue
    base = root / "packages/test/tests/language/statements/state_updates/references" / operations[original["operator"]]
    runtime = [json.loads(line) for line in base.with_suffix(".jsonl").read_text().splitlines()]
    assert len(runtime) == 1
    assert all(runtime[0][field] == struct.pack(">d", original[field]).hex() for field in ["left", "right", "expected"])
    source = base.with_suffix(".zx").read_text()
    for target in [f"state.{original['identifier']}", f"state.box.{original['identifier']}", "state.values[0]"]:
        assert f"{target} {original['operator']} state.right" in source
print("PASS: 18 frozen files, 42 original reviews, 168 reference executions, 12 binaries and 358 independently replayed checks")
