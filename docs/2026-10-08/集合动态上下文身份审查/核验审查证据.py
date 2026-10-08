from pathlib import Path
import hashlib
import json


doc = Path(__file__).resolve().parent
root = doc.parents[2]
sha = lambda data: hashlib.sha256(data).hexdigest()
originals = json.loads((doc / "原文身份.json").read_text())
execution = json.loads((doc / "原文执行证据.json").read_text())
inputs = json.loads((doc / "执行输入.json").read_text())
formal = json.loads((doc / "正式路径.json").read_text())
rows = [json.loads(line) for line in (doc / "草稿" / formal[0]).read_text().split("\n") if line]
index = {
    row["path"]: row["sha256"]
    for row in (json.loads(line) for line in (root / "packages/test/upstream/index/built-ins.jsonl").read_text().split("\n") if line)
}
assert len(originals) == len(rows) == 16
assert len({row["path"] for row in rows}) == 16
assert {row["path"] for row in rows} == {item["path"] for item in originals}
assert (root / formal[0]).read_bytes() == (doc / "草稿" / formal[0]).read_bytes()

for path, identity in inputs["identities"].items():
    assert sha(Path(path).read_bytes()) == identity, path

for item, row in zip(originals, rows):
    assert item["path"] == row["path"]
    data = (doc / item["saved"]).read_bytes()
    assert sha(data) == item["sha256"] == row["sha256"] == index[item["path"]]
    text = data.decode()
    assert item["identity_expression"] in text
    assertions = [{"line": position + 1, "text": line.strip()} for position, line in enumerate(text.split("\n")) if line.strip().startswith("assert")]
    assert assertions == item["assertion_lines"]
    assert row["status"] == "excluded" and row["cases"] == row["assertions"] == []
    runs = [run for run in execution["records"] if run["path"] == item["path"]]
    assert len(runs) == 2 and {run["strict"] for run in runs} == {False, True}

    for run in runs:
        assert run["sha256"] == item["sha256"]
        observed = run["observed"]
        assert len(observed) == len(assertions)

        if item["method"] == "map":
            assert observed == [{"kind": "sameValue", "actual": True, "expected": True}]
        elif item["method"] == "filter":
            assert observed == [{"kind": "sameValue", "actual": 11, "expected": 11}, {"kind": "assert", "actual": True}]
        elif item["method"] == "every":
            assert observed == [{"kind": "assert", "actual": True}, {"kind": "assert", "actual": True}]
        else:
            assert item["method"] == "some"
            assert observed == [{"kind": "assert", "actual": True}]

assert len(execution["records"]) == 32
assert sum(len(run["observed"]) for run in execution["records"]) == 48
before = json.loads((doc / "基线矩阵.json").read_text())
after = json.loads((doc / "矩阵审计.json").read_text())
assert before["catalog_cases"] == after["catalog_cases"]
assert before["linked_cases"] == after["linked_cases"]
assert before["unreviewed"] - after["unreviewed"] == 16
assert after["reviewed"]["excluded"] - before["reviewed"]["excluded"] == 16
assert before["reviewed"]["adapted"] == after["reviewed"]["adapted"]
assert before["reviewed"]["equivalent"] == after["reviewed"]["equivalent"]

for path in doc.rglob("*.md"):
    assert len(path.read_text().split("\n")) <= 1000, path

print("PASS: 16 reviewed originals, 32 executions, 48 original assertions; zero new ZX cases or pass claims")
