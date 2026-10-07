from pathlib import Path
import gzip
import hashlib
import json
import re
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
state = json.loads((doc / "运行状态.json").read_text())
root = Path(baseline["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

subprocess.run(["python3", str(doc / "核验生成身份.py")], check=True)
checks = 0
runs = 0
for label, gate in state["gates"].items():
    assert gate["status"] == "terminal" and gate["exit_code"] == 0
    evidence = json.loads((doc / (label + "证据.json")).read_text())
    assert evidence["passed"] and not evidence["errors"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    summaries = evidence["native_summaries"]
    actual = sum(int(re.search(r" (\d+) pass", line)[1]) for line in summaries if " pass" in line and " cached" not in line)
    assert actual == evidence["tests_passed"]
    checks += actual
    runs += len(evidence["actual_executions"])

    for item in evidence["actual_executions"]:
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
        assert item["compiled"] is not None

    for item in evidence["generated_source"]:
        data = Path(item["path"]).read_bytes()
        assert sha(data) == item["sha256"]
        if "saved" in item:
            saved = (doc / item["saved"]).read_bytes()
            if item.get("compression") == "gzip":
                saved = gzip.decompress(saved)
            assert saved == data

    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]

    if label == "首轮Debug":
        assert evidence["tests_passed"] == 46
        assert gate["frontend_filter"] == "concatenation_remaining"
    else:
        assert gate["frontend_filter"] is None
        assert any("conformance-frontend 6661 pass" in line for line in summaries)

assert set(state["gates"]) == {"首轮Debug", "Debug", "ReleaseSafe"}
matrix = json.loads((doc / "候选目录审查.json").read_text())
assert matrix["catalog_cases"] == 128488 and matrix["unreviewed"] == 50626
assert matrix["reviewed"] == {"adapted": 812, "excluded": 2056, "equivalent": 103}
print(f"PASS: exact frozen source and original expressions; {checks} actual checks in {runs} native executions; full frontend in both modes; exclusions remain separate from semantic compatibility.")
