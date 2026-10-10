from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
root = Path(baseline["execution_root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"]
assert len(baseline["inputs"]) == 5563 and len(baseline["formal_files"]) == 31
current = {item["path"]: item["sha256"] for item in baseline["inputs"]}

for item in baseline["inputs"]:
    assert sha((root / item["path"]).read_bytes()) == item["sha256"], item["path"]
    assert sha((Path(baseline["source_snapshot"]) / item["path"]).read_bytes()) == item["sha256"], item["path"]

for prefix in ["首轮", "二轮"]:
    previous = json.loads((doc / (prefix + "开始基线.json")).read_text())
    assert previous["source_commit"] == baseline["source_commit"]
    for item in previous["inputs"]:
        assert sha((Path(previous["source_snapshot"]) / item["path"]).read_bytes()) == item["sha256"]
        if item["path"] not in baseline["formal_files"]:
            assert item["sha256"] == current[item["path"]]
    for path in baseline["formal_files"]:
        saved = (doc / (prefix + "草稿") / (path + ".txt")).read_bytes()
        assert sha(saved) == next(item["sha256"] for item in previous["inputs"] if item["path"] == path)

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()

subprocess.run([sys.executable, str(doc / "核验生成身份.py"), str(root)], check=True)
state = json.loads((doc / "运行状态.json").read_text())
names = {"首轮": "conformance-frontend", "二轮": "comparison-whitespace", "": "decimal-original"}
checks = {"首轮": 6642, "二轮": 216, "": 403}
steps = {"首轮": 36, "二轮": 40, "": 44}
binaries = set()

for mode in ["Debug", "ReleaseSafe"]:
    for prefix in ["首轮", "二轮", ""]:
        label = prefix + mode
        evidence = json.loads((doc / (label + "证据.json")).read_text())
        expected_exit = 1 if prefix else 0
        assert state["gates"][label]["status"] == "terminal"
        assert state["gates"][label]["exit_code"] == evidence["exit_code"] == expected_exit
        assert evidence["passed"] == (not prefix)
        assert evidence["steps_passed"] == steps[prefix] and evidence["steps_total"] == 44
        assert evidence["tests_passed"] == evidence["tests_total"] == checks[prefix]
        assert evidence["source_commit"] == evidence["collected_source_commit"] == baseline["source_commit"]
        assert evidence["packages_tree"] == baseline["packages_tree"]
        assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
        assert len(evidence["logged_zig_test_binaries"]) == len(evidence["test_execution_links"]) == 1
        assert len(evidence["formal_parser_options"]) == 2
        for item in evidence["formal_parser_options"]:
            assert item["generated_parser"] and sha(Path(item["path"]).read_bytes()) == item["sha256"]
        for item in evidence["logged_zig_test_binaries"]:
            assert Path(item["path"]).name == names[prefix]
            assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
            binaries.add(item["path"])
        for item in evidence["artifacts"]:
            assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
            assert Path(item["executed_source"]).read_bytes() == (doc / item["saved"]).read_bytes()
        assert sum(int(re.search(r" (\d+) pass", line).group(1)) for line in evidence["native_summary_entries"] if " cached" not in line) == checks[prefix]
        if not prefix:
            assert not evidence["errors"] and not evidence["command_markers"]
            assert sum(" cached" in line for line in evidence["native_summary_entries"]) == 2

assert len(binaries) == 6
matrix = json.loads((doc / "目录审查结果.json").read_text())
assert matrix["catalog_cases"] == 128468 and matrix["unreviewed"] == 50630 and matrix["reviewed"]["adapted"] == 812
print("PASS: three frozen rounds, 14522 actual checks in six native executions, unchanged upstream assertions and generated-source identity")
