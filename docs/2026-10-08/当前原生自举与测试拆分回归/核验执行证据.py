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

checks = 0
runs = 0
for mode, gate in state["gates"].items():
    assert gate["status"] == "terminal" and gate["exit_code"] == 0
    evidence = json.loads((doc / (mode + "证据.json")).read_text())
    assert evidence["passed"] and evidence["exit_code"] == 0
    assert evidence["source_commit"] == baseline["source_commit"]
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    assert not evidence["errors"]
    actual_checks = sum(int(re.search(r" (\d+) pass", line)[1]) for line in evidence["native_summaries"] if " pass" in line and " cached" not in line)
    assert actual_checks == evidence["tests_passed"]
    checks += actual_checks
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

    assert evidence["formal_parser_options"]
    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]

    lines = (doc / evidence["log"]).read_text().splitlines()
    assert any("test-native-generation success" in line for line in lines)
    assert any(line.startswith("ℹ pass 1") for line in lines)
    assert not any(line.startswith("✖") for line in lines)

assert set(state["gates"]) == {"Debug", "ReleaseSafe"}
print(f"PASS: current fixed native bootstrap and split inputs; {checks} actual Zig checks in {runs} native executions; Node ABI wrapper and parser selection verified in both modes.")
