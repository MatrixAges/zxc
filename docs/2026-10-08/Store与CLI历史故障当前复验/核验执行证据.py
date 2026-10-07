from pathlib import Path
import hashlib
import json
import re
import sys
import subprocess

snapshot = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
state = json.loads((doc / "运行状态.json").read_text())

for item in baseline["inputs"]:
    assert hashlib.sha256((snapshot / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

execution_root = Path(baseline["execution_root"])
assert subprocess.check_output(["git", "-C", str(execution_root), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"]
assert subprocess.check_output(["git", "-C", str(execution_root), "diff", "HEAD", "--", "packages"]) == b""
for item in baseline["inputs"]:
    assert hashlib.sha256((execution_root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

assert state["source_commit"] == baseline["source_commit"]
assert state["packages_tree"] == baseline["packages_tree"]

cli_names = [
    "loop CLI / precondition evaluation order",
    "loop CLI / postcondition evaluation order",
    "loop CLI / index failure precedes right hand side effects",
    "loop RX / explicit ZX calls preserve initial values",
    "loop import shadows the built in without changing its calling convention",
]

for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    raw = (doc / evidence["log"]).read_bytes()
    log = raw.decode()

    assert state["gates"][label]["status"] == "terminal"
    assert state["gates"][label]["exit_code"] == evidence["exit_code"] == 0
    assert evidence["passed"] and not evidence["errors"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["steps_passed"] == evidence["steps_total"] == 64
    assert evidence["tests_passed"] == evidence["tests_total"] == 26
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]

    native_results = re.findall(r"run test (\d+) pass \(\d+ total\)[^\n]*", log)
    assert sorted(map(int, native_results)) == [2, 6, 6, 6, 6]
    assert all("cached" not in line for line in log.splitlines() if re.search(r"run test \d+ pass", line))
    assert len(evidence["logged_zig_test_binaries"]) == 5
    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

    for item in evidence["artifacts"] + evidence["generated_store_modules"]:
        assert hashlib.sha256((doc / item["saved"]).read_bytes()).hexdigest() == item["sha256"]
        assert hashlib.sha256(Path(item["executed_source"]).read_bytes()).hexdigest() == item["sha256"]

    assert len(evidence["formal_parser_options"]) == 2
    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

    assert len(evidence["process_checks"]) == 46
    assert [int(re.match(r"ok (\d+): ", line).group(1)) for line in evidence["process_checks"]] == list(range(1, 47))
    assert "Process application entry: 46 checks passed" in log
    assert all("state.rx" in line for line in evidence["process_checks"][-5:])
    assert len(evidence["nested_zig_checks"]) == 39
    assert all(line.endswith("OK") for line in evidence["nested_zig_checks"])
    assert len(re.findall(r"^✔ generated Store memory consumer .*", log, re.MULTILINE)) == 7
    for name in cli_names:
        assert len(re.findall(r"^✔ " + re.escape(name) + r" ", log, re.MULTILINE)) == 1

    tests = [int(re.search(r"tests (\d+)", line).group(1)) for line in evidence["node_test_summaries"] if " tests " in line]
    passes = [int(re.search(r"pass (\d+)", line).group(1)) for line in evidence["node_test_summaries"] if " pass " in line]
    assert sorted(tests) == sorted(passes) == [1] * 7 + [5]
    assert all(line.endswith(" 0") for line in evidence["node_test_summaries"] if any(word in line for word in [" fail ", " cancelled ", " skipped ", " todo "]))
    assert len(evidence["generated_store_modules"]) == 29

audit = json.loads((doc / "目录审查结果.json").read_text())
assert (audit["catalog_cases"], audit["unreviewed"], audit["reviewed"]["adapted"]) == (128467, 50631, 811)

first = json.loads((doc / "首轮Debug证据.json").read_text())
assert first["exit_code"] == 0 and first["passed"]
assert first["source_commit"] == json.loads((doc / "首轮开始基线.json").read_text())["source_commit"]
assert hashlib.sha256((doc / first["log"]).read_bytes()).hexdigest() == first["log_sha256"]
drift = json.loads((doc / "共享源码变动观察.json").read_text())
assert drift["exit_code"] == 0 and not drift["accepted_as_fixed_source_evidence"]
assert drift["changed_inputs"]
assert hashlib.sha256((doc / drift["log"]).read_bytes()).hexdigest() == drift["log_sha256"]

print("PASS: frozen source, both terminal gates, 52 build-managed Zig checks, 78 Store Zig checks, 92 Process checks, 10 CLI subtests and 14 Store wrappers")
