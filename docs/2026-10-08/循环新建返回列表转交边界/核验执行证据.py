from pathlib import Path
import hashlib
import json
import re
import subprocess


doc = Path(__file__).resolve().parent
state = json.loads((doc / "运行状态.json").read_text())
final = json.loads((doc / "执行输入.json").read_text())
first = json.loads((doc / "首轮执行输入.json").read_text())
root = Path(final["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == final["source_commit"] == first["source_commit"]

for baseline in [first, final]:
    for path, identity in baseline["inputs"].items():
        assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

for path, identity in final["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path

for path in final["formal_files"]:
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()
    assert sha((doc / "首轮草稿" / (path + ".txt")).read_bytes()) == first["inputs"][path]

changed = {path for path in final["inputs"] if final["inputs"][path] != first["inputs"][path]}
assert changed == {"packages/test/tests/collections/loop_call_origins/fixtures/factory/literal.zx"}
expected_new = {"loop-call-origins-" + mode + "-" + route for mode in ["fresh", "literal", "chain", "branch", "mixed", "borrowed", "shared", "impure"] for route in ["source", "library"]}
expected_new |= {"loop-call-capacity-" + mode + "-" + route for mode in ["fresh", "literal", "chain", "branch", "impure"] for route in ["source", "library"]}
total_checks = 0
total_runs = 0

for label, gate in state["gates"].items():
    assert gate["status"] == "terminal"
    evidence = json.loads((doc / (label + "证据.json")).read_text())
    assert gate["exit_code"] == evidence["exit_code"]
    assert evidence["source_commit"] == final["source_commit"]
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    passed = sum(int(re.search(r" (\d+) pass", line)[1]) for line in evidence["native_summaries"] if " pass" in line and " cached" not in line)
    assert passed == evidence["tests_passed"]
    total_checks += passed
    total_runs += len(evidence["actual_executions"])

    for item in evidence["actual_executions"]:
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
        assert item["compiled"] is not None

    for item in evidence["generated_source"]:
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
        if "saved" in item:
            assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]

    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]

    if label.startswith("首轮"):
        assert not evidence["passed"] and evidence["exit_code"] == 1
        assert "syntax: expected an identifier" in (doc / evidence["log"]).read_text()
    else:
        assert evidence["passed"] and evidence["exit_code"] == 0
        assert not evidence["errors"]
        observed = {Path(item["path"]).name for item in evidence["actual_executions"] if Path(item["path"]).name.startswith("loop-call-")}
        assert observed == expected_new
        assert sum(1 for line in (doc / evidence["log"]).read_text().splitlines() if line.startswith("call origin length=")) == 40

assert set(state["gates"]) == {"首轮Debug", "首轮ReleaseSafe", "Debug", "ReleaseSafe"}
print(f"PASS: exact first/final source identities; {total_checks} actual checks and {total_runs} binary executions; final source/library return-origin coverage and parser selection verified.")
