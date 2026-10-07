from pathlib import Path
import hashlib
import json
import re
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "输入冻结.json").read_text())
for record in freeze["paths"]:
    data = (root / record["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == record["sha256"], record["path"]
    assert data == (doc / "草稿" / record["path"]).read_bytes()
originals = json.loads((doc / "上游原文清单.json").read_text())
assert len(originals) == 11 and sum(row["assertions"] for row in originals) == 220
for row in originals:
    data = (doc / "上游原文" / (Path(row["path"]).name + ".txt")).read_bytes()
    assert hashlib.sha256(data).hexdigest() == row["sha256"]
    assert data.count(b"assert.sameValue(") == 20
    assert row["groups"][6]["gap_hex"] == "0d"
    gaps = [bytes.fromhex(group["gap_hex"]) for group in row["groups"]]
    assert gaps[-1] == b"".join(gaps[:-1])
    for gap in gaps:
        assert b"x" + gap + row["operator"].encode() + gap in data
for engine in ["Node","Bun"]:
    evidence = json.loads((doc / f"上游原文执行证据-{engine}.json").read_text())
    assert len(evidence["executions"]) == 22
    assert sum(item["assertions"] for item in evidence["executions"]) == 440
    for item in evidence["executions"]:
        original = next(row for row in originals if row["path"] == item["path"])
        assert item["passed"] and item["sha256"] == original["sha256"] and item["final_bits"] == original["expected_bits"]
    assert {item["strict"] for item in evidence["executions"]} == {False,True}
archive = doc / "起始基线证据"
if archive.exists():
    archived_freeze = json.loads((archive / "输入冻结.json").read_text())
    assert archived_freeze["source_commit"] == freeze["starting_commit"]
    for label in ["Debug", "ReleaseSafe"]:
        historical = json.loads((archive / f"{label}证据.json").read_text())
        assert historical["source_commit"] == archived_freeze["source_commit"] and historical["checks"] == 1140
        assert len(historical["records"]) == 6
        for item in historical["records"]:
            assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["sha256"]
            replay = (archive / item["replay"]).read_bytes()
            assert hashlib.sha256(replay).hexdigest() == item["replay_sha256"]
            assert f"All {item['checks']} tests passed.".encode() in replay
            for artifact in item["artifacts"]:
                assert hashlib.sha256((archive / artifact["path"]).read_bytes()).hexdigest() == artifact["sha256"]

checks = 0
for label in ["Debug","ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    assert evidence["source_commit"] == freeze["source_commit"] and evidence["checks"] == 1140
    assert len(evidence["records"]) == 6
    for item in evidence["records"]:
        assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["sha256"]
        replay = (doc / item["replay"]).read_bytes()
        assert hashlib.sha256(replay).hexdigest() == item["replay_sha256"]
        assert f"All {item['checks']} tests passed.".encode() in replay
        for artifact in item["artifacts"]:
            assert hashlib.sha256((doc / artifact["path"]).read_bytes()).hexdigest() == artifact["sha256"]
        checks += item["checks"]
assert checks == 2280
reviews = [json.loads(line) for line in (root / "packages/test/upstream/reviews/language/expressions/compound_whitespace.jsonl").read_text().splitlines()]
assert len(reviews) == 11
assert sum(row["status"] == "adapted" for row in reviews) == 5
assert sum(row["status"] == "excluded" for row in reviews) == 6
rows = [json.loads(line) for line in (root / "packages/test/tests/language/types/compound_whitespace/cases.jsonl").read_text().splitlines()]
assert len(rows) == 1050
assert sum(row["diagnostic"] == "lexical" for row in rows) == 420
assert sum(row["diagnostic"] == "type_mismatch" for row in rows) == 270
assert sum(row["diagnostic"] == "syntax" for row in rows) == 90
assert sum(row["diagnostic"] is None for row in rows) == 270
for path in (root / "packages/test/tests/language/statements/state_updates/whitespace").glob("*.jsonl"):
    cases = [json.loads(line) for line in path.read_text().splitlines()]
    assert len(cases) == 18
    if path.stem == "remainder":
        assert all(row["expected"] == "8000000000000000" for row in cases)
print(f"PASS: {len(freeze['paths'])} frozen paths, 12 binaries, {checks} native checks, 11 originals and both engines' 880 SameValue assertions")
