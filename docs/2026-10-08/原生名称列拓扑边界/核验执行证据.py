from pathlib import Path
import hashlib
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
first = json.loads((doc / "首轮开始基线.json").read_text())
root = Path(baseline["execution_root"])
sha = lambda data: hashlib.sha256(data).hexdigest()

assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"] == first["source_commit"]
assert len(baseline["inputs"]) == len(first["inputs"]) == 5540
final_inputs = {item["path"]: item["sha256"] for item in baseline["inputs"]}

for item in baseline["inputs"]:
    assert sha((root / item["path"]).read_bytes()) == item["sha256"], item["path"]
    assert sha((Path(baseline["source_snapshot"]) / item["path"]).read_bytes()) == item["sha256"], item["path"]

for item in first["inputs"]:
    assert sha((Path(first["source_snapshot"]) / item["path"]).read_bytes()) == item["sha256"], item["path"]
    if item["path"] not in baseline["formal_files"]:
        assert final_inputs[item["path"]] == item["sha256"], item["path"]

for path in baseline["formal_files"]:
    assert (doc / "代码草稿" / path).read_bytes() == (root / path).read_bytes()
    previous = (doc / "首轮草稿" / (path + ".txt")).read_bytes()
    assert sha(previous) == next(item["sha256"] for item in first["inputs"] if item["path"] == path)

state = json.loads((doc / "运行状态.json").read_text())
original_roots = {"tests/native/references/ir/" + name + "_test.zig" for name in ["owner", "boundary", "allocation", "task"]}
all_binaries = set()

for mode in ["Debug", "ReleaseSafe"]:
    for prefix in ["首轮", ""]:
        label = prefix + mode
        evidence = json.loads((doc / (label + "证据.json")).read_text())
        initial = bool(prefix)
        expected_exit, expected_steps, expected_checks, expected_runs = (1, 30, 18, 4) if initial else (0, 33, 9, 1)

        assert state["gates"][label]["status"] == "terminal"
        assert state["gates"][label]["exit_code"] == evidence["exit_code"] == expected_exit
        assert evidence["passed"] == (not initial)
        assert evidence["steps_passed"] == expected_steps and evidence["steps_total"] == 33
        assert evidence["tests_passed"] == evidence["tests_total"] == expected_checks
        assert evidence["source_commit"] == evidence["collected_source_commit"] == baseline["source_commit"]
        assert evidence["packages_tree"] == baseline["packages_tree"]
        assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
        assert len(evidence["logged_zig_test_binaries"]) == len(evidence["test_execution_links"]) == expected_runs
        assert len(evidence["formal_parser_options"]) == 5

        for item in evidence["formal_parser_options"]:
            assert item["generated_parser"]
            assert sha(Path(item["path"]).read_bytes()) == item["sha256"]

        for item in evidence["logged_zig_test_binaries"]:
            assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
            all_binaries.add(item["path"])

        for item in evidence["artifacts"]:
            assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
            assert Path(item["executed_source"]).read_bytes() == (doc / item["saved"]).read_bytes()

        observed_roots = {item["compiled_root"] for item in evidence["test_execution_links"]}
        assert observed_roots == (original_roots if initial else {"tests/native/references/ir/name_columns/root_test.zig"})
        summaries = evidence["native_summary_entries"]
        assert sum(int(re.search(r" (\d+) pass", line).group(1)) for line in summaries if " cached" not in line) == expected_checks

        if not initial:
            assert not evidence["errors"] and not evidence["command_markers"]
            assert sum(" cached" in line for line in summaries) == 4
            assert {Path(item["executed_source"]).name for item in evidence["artifacts"]} >= {"native_names.zig", "native_type.zig"}

assert len(all_binaries) == 10
test_source = (root / "packages/test/tests/native/references/ir/name_columns/root_test.zig").read_text()
assert len(re.findall(r'^test "', test_source, re.M)) == 9
matrix = json.loads((doc / "目录审查结果.json").read_text())
assert matrix["catalog_cases"] == 128468 and matrix["unreviewed"] == 50630 and matrix["reviewed"]["adapted"] == 812

print("PASS: frozen latest native construction/validation, 54 checks in 10 actual executions across two rounds and modes; four cached groups per final gate remain distinct")
