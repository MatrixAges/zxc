from pathlib import Path
import hashlib
import json
import re
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
package = root / "packages/test"
sha = lambda data: hashlib.sha256(data).hexdigest()
identity = json.loads((doc / "原文身份.json").read_text())
index = {row["path"]: row["sha256"] for row in map(json.loads, (package / "upstream/index/language.jsonl").read_text().splitlines())}
samples = list(map(json.loads, (package / "src/data/concatenation_remaining.jsonl").read_text().splitlines()))
frontend = list(map(json.loads, (package / "tests/language/types/concatenation_remaining/cases.jsonl").read_text().splitlines()))
reviews = list(map(json.loads, (package / "upstream/reviews/language/expressions/concatenation_remaining.jsonl").read_text().splitlines()))
assert len(samples) == len(frontend) == 19 and len(reviews) == 4

for item in identity["sources"]:
    raw = (doc / item["saved"]).read_bytes()
    assert sha(raw) == item["sha256"] == index[item["path"]]
    checks = re.findall(r'if\s*\(([\s\S]*?)\s*!==\s*([\s\S]*?)\)\s*\{', raw.decode())
    selected = [sample for sample in samples if sample["path"] == item["path"]]
    assert len(selected) == len(checks)

    for sample, (expression, expected) in zip(selected, checks):
        assert sample["original_expression"] == expression.strip()
        assert sample["original_expected"] == expected.strip()
        if "myobj" in expression:
            symbol = re.search(r"myobj\d+", expression)[0]
            body = re.search(r"var " + symbol + r"\s*=\s*([\s\S]*?);\s*if", raw.decode())[1]
            assert sample["prefix"] == "    const " + symbol + " = " + body + "\n\n"

for sample, case in zip(samples, frontend):
    expected = "export type Input = void\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n" + sample["prefix"] + "    return " + sample["original_expression"] + "\n}\n"
    assert case["source"] == expected
    assert case["phase"] == sample["phase"] and case["diagnostic"] == sample["diagnostic"]

for review in reviews:
    cases = [case for sample, case in zip(samples, frontend) if sample["path"] == review["path"]]
    assert review["status"] == "excluded"
    assert review["cases"] == [case["id"] for case in cases]
    assert review["diagnostics"] == [{"case": case["id"], "phase": case["phase"], "code": case["diagnostic"]} for case in cases]

before = json.loads(subprocess.check_output(["git", "show", baseline["source_commit"] + ":packages/test/suites.json"], cwd=root))
after = json.loads((package / "suites.json").read_text())
assert after["frontend"].pop() == "language/types/concatenation_remaining/cases"
assert after["runtime"].pop() == {"name": "template-primitives-concatenation-string-identity", "path": "language/expressions/concatenation/string_identity", "kind": "control"}
assert after == before

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()
    if path.endswith(".zx"):
        data = (root / path).read_bytes()
        assert len(re.split(rb"\r\n|\r|\n", data)) - int(data.endswith((b"\n", b"\r"))) <= 120

print("PASS: four locked original identities; all 19 expressions and object contexts preserved; explicit exclusions and only two suite registrations.")
