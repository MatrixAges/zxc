from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

snapshot = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
state = json.loads((doc / "运行状态.json").read_text())
execution = Path(baseline["execution_root"])

assert subprocess.check_output(["git", "-C", str(execution), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"]
assert state["source_commit"] == baseline["source_commit"]
assert state["packages_tree"] == baseline["packages_tree"]
for item in baseline["inputs"]:
    assert hashlib.sha256((snapshot / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]
    assert hashlib.sha256((execution / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

formal = set(json.loads((doc / "正式文件清单.json").read_text()))
tracked = subprocess.check_output(["git", "-C", str(execution), "diff", "HEAD", "--name-only", "-z", "--", "packages"]).decode().strip("\0").split("\0")
untracked = subprocess.check_output(["git", "-C", str(execution), "ls-files", "--others", "--exclude-standard", "-z", "packages"]).decode().strip("\0").split("\0")
assert (set(tracked) | set(untracked)) - {""} == formal
for path in formal:
    assert (execution / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()

for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    log = (doc / evidence["log"]).read_bytes()
    assert state["gates"][label]["status"] == "terminal"
    assert state["gates"][label]["exit_code"] == evidence["exit_code"] == 0
    assert evidence["passed"] and not evidence["errors"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["steps_passed"] == evidence["steps_total"] == 75
    assert evidence["tests_passed"] == evidence["tests_total"] == 6739
    assert hashlib.sha256(log).hexdigest() == evidence["log_sha256"]
    assert len(evidence["logged_zig_test_binaries"]) == len(evidence["test_execution_links"]) == 18
    assert len(evidence["native_summary_entries"]) == 18
    assert all("cached" not in line for line in evidence["native_summary_entries"])
    counts = [int(re.search(r" (\d+) pass ", line).group(1)) for line in evidence["native_summary_entries"]]
    assert sorted(counts) == sorted([6642, 10, 19, 20, 9, 5, 3, 3, 3, 2, 3, 2, 3, 4, 1, 1, 2, 7])

    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]
    for item in evidence["test_execution_links"]:
        assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["binary_sha256"]
    flow = [item for item in evidence["test_execution_links"] if item["compiled_root"].endswith("scanner_metadata/flow_test.zig")]
    assert len(flow) == 1
    views = [item for item in evidence["test_execution_links"] if item["compiled_root"].endswith("resolution/views_test.zig")]
    assert len(views) == 1

    for item in evidence["artifacts"]:
        assert hashlib.sha256((doc / item["saved"]).read_bytes()).hexdigest() == item["sha256"]
        assert hashlib.sha256(Path(item["executed_source"]).read_bytes()).hexdigest() == item["sha256"]
    assert len(evidence["formal_parser_options"]) == 11
    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]
    cases = [item for item in evidence["artifacts"] if Path(item["executed_source"]).name == "cases.zig"]
    assert len(cases) == 1
    text = (doc / cases[0]["saved"]).read_text()
    assert len(re.findall(r"^test ", text, re.MULTILINE)) == 6642
    for name in ["language/types/object_construction/source_preservation/o.a", "language/types/object_construction/source_preservation/o.b"]:
        assert 'test "' + name + '"' in text

    programs = [Path(item["executed_source"]).name for item in evidence["artifacts"]]
    assert "lexer.zig" in programs
    assert "type_parser_plain.zig" in programs and "type_parser_template.zig" in programs

for label in ["ObjectDebug", "ObjectReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    assert state["gates"][label]["status"] == "terminal"
    assert state["gates"][label]["exit_code"] == evidence["exit_code"] == 0
    assert evidence["passed"] and not evidence["errors"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["steps_passed"] == evidence["steps_total"] == 95
    assert evidence["tests_passed"] == evidence["tests_total"] == 53
    assert len(evidence["logged_zig_test_binaries"]) == len(evidence["test_execution_links"]) == 16
    assert len(evidence["native_summary_entries"]) == 16
    assert all("cached" not in line for line in evidence["native_summary_entries"])
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]
    for item in evidence["test_execution_links"]:
        assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["binary_sha256"]
    for item in evidence["artifacts"]:
        assert hashlib.sha256((doc / item["saved"]).read_bytes()).hexdigest() == item["sha256"]
        assert hashlib.sha256(Path(item["executed_source"]).read_bytes()).hexdigest() == item["sha256"]
    assert len(evidence["formal_parser_options"]) == 1
    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]
    cases = [item for item in evidence["artifacts"] if Path(item["executed_source"]).name == "cases.zig"]
    texts = [(doc / item["saved"]).read_text() for item in cases]
    for field in ["o.a", "o.b"]:
        name = "language/expressions/object_construction/override/" + field
        assert sum('test "' + name + '"' in text for text in texts) == 1
    assert "run test object-construction-override 4 pass (4 total)" in raw.decode()

migration = json.loads((doc / "源保留用例迁移核对.json").read_text())
assert migration["same_sources"] and len(migration["cases"]) == 2
assert all(item["old_diagnostic"] == "ownership" and item["new_diagnostic"] is None for item in migration["cases"])

audit = json.loads((doc / "目录审查结果.json").read_text())
assert (audit["catalog_cases"], audit["unreviewed"], audit["reviewed"]["adapted"]) == (128467, 50631, 811)
print("PASS: fixed source plus two drafts, 13584 actually executed checks, 68 binaries, seven new checks in each mode and the current source-preservation analysis cases")
