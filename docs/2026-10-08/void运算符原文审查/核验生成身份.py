from pathlib import Path
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
draft = doc / "草稿/packages/test"
read_rows = lambda path: [json.loads(line) for line in path.read_text().split("\n") if line]
sha = lambda data: hashlib.sha256(data).hexdigest()
identity = json.loads((doc / "原文身份.json").read_text())
originals = read_rows(doc / "草稿/原文表达式.jsonl")
samples = read_rows(draft / "src/data/void_originals.jsonl")
cases = read_rows(draft / "tests/language/types/void_originals/cases.jsonl")
reviews = read_rows(draft / "upstream/reviews/language/expressions/void_originals.jsonl")
observed = {row["id"]: row for row in read_rows(doc / "实验/观测结果.jsonl")}
experimental = json.loads((doc / "实验/固定输入.json").read_text())
for path, digest in experimental["inputs"].items():
    assert sha((doc / experimental["archived_inputs"][path]).read_bytes()) == digest, path
assert len(identity["sources"]) == len(reviews) == 9
assert len(originals) == len(samples) == len(cases) == len(observed) == 26

for source in identity["sources"]:
    raw = (doc / source["saved"]).read_bytes()
    assert sha(raw) == source["sha256"]
    assert raw.startswith(b"// Copyright")
    review = next(row for row in reviews if row["path"] == source["path"])
    assert review["sha256"] == source["sha256"] and review["status"] == "excluded"

for original, sample, case in zip(originals, samples, cases):
    for key in original:
        assert sample[key] == original[key], (original["id"], key)
    source = next(row for row in identity["sources"] if row["path"] == original["source"])
    raw = (doc / source["saved"]).read_text()
    assert original["original_context"] in raw
    if original["original_literal"] is not None:
        assert json.loads(original["original_literal"]) == original["expression"]
        assert original["original_literal"] in original["original_context"]
    else:
        assert original["expression"] in original["original_context"]
    probe = observed[original["id"]]
    assert case["source"] == probe["source"]
    assert case["phase"] == "parse" and case["diagnostic"] == probe["code"]
    assert case["span"] == [probe["start"], probe["end"]]
    assert "return " + original["expression"] + "\n" in case["source"]
    physical = case["source"].replace("\r\n", "\n").replace("\r", "\n")
    assert len(physical.split("\n")) <= 120
    review = next(row for row in reviews if row["path"] == original["source"])
    assert case["id"] in review["cases"]
    assert {"case": case["id"], "phase": "parse", "code": case["diagnostic"], "span": case["span"]} in review["diagnostics"]

previous = json.loads(subprocess.check_output(["git", "show", baseline["source_commit"] + ":packages/test/suites.json"], cwd=root))
current = json.loads((draft / "suites.json").read_text())
assert current["frontend"] == previous["frontend"] + ["language/types/void_originals/cases"]
assert {key: value for key, value in current.items() if key != "frontend"} == {key: value for key, value in previous.items() if key != "frontend"}

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "草稿" / path).read_bytes(), path

subprocess.run(["node", "src/generate_void_originals.ts", "--check"], cwd=root / "packages/test", check=True)
print("PASS: 9 original identities, 26 exact expressions/contexts/diagnostics/spans, excluded reviews and one suite append")
