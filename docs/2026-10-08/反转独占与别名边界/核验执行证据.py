from pathlib import Path
import hashlib
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
execution = Path(baseline["execution_root"])
snapshot = Path(baseline["source_snapshot"])
sha = lambda data: hashlib.sha256(data).hexdigest()

assert subprocess.check_output(["git", "-C", str(execution), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"]

for item in baseline["inputs"]:
    assert sha((execution / item["path"]).read_bytes()) == item["sha256"], item["path"]
    assert sha((snapshot / item["path"]).read_bytes()) == item["sha256"], item["path"]

for path in baseline["formal_files"]:
    executed_draft = doc / "执行草稿" / (path + ".txt")
    if not executed_draft.is_file():
        executed_draft = doc / "代码草稿" / path
    assert executed_draft.read_bytes() == (execution / path).read_bytes()
    if path.endswith(".zx"):
        assert len((execution / path).read_text().splitlines()) <= 240

for item in json.loads((doc / "格式整理.json").read_text()):
    executed = (doc / "执行草稿" / (item["path"] + ".txt")).read_bytes()
    published = (doc / "代码草稿" / item["path"]).read_bytes()
    assert sha(executed) == item["executed_sha256"]
    assert sha(published) == item["published_sha256"]
    assert executed.split() == published.split()

first_baseline = json.loads((doc / "首轮开始基线.json").read_text())
first_inputs = {item["path"]: item["sha256"] for item in first_baseline["inputs"]}
for path in (doc / "首轮草稿").rglob("*.zig.txt"):
    relative = str(path.relative_to(doc / "首轮草稿")).removesuffix(".txt")
    assert sha(path.read_bytes()) == first_inputs[relative]

state = json.loads((doc / "运行状态.json").read_text())
expected_names = {"reverse-ownership-" + mode + "-" + route for mode in ["map_unique", "map_shared", "filter_unique", "filter_shared", "borrowed", "literal", "object_unique", "tuple_unique", "loop_unique", "loop_shared"] for route in ["source", "library"]}
expected_names |= {"reverse-capacity-source", "reverse-capacity-library"}

for label in ["Debug", "ReleaseSafe", "OriginalDebug", "OriginalReleaseSafe"]:
    evidence = json.loads((doc / (label + "证据.json")).read_text())
    original = label.startswith("Original")
    steps, checks = (117, 212) if original else (97, 102)

    assert state["gates"][label]["status"] == "terminal"
    assert state["gates"][label]["exit_code"] == evidence["exit_code"] == 0
    assert evidence["passed"] and not evidence["errors"]
    assert evidence["source_commit"] == evidence["collected_source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["steps_passed"] == evidence["steps_total"] == steps
    assert evidence["tests_passed"] == evidence["tests_total"] == checks
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    assert len(evidence["logged_zig_test_binaries"]) == len(evidence["test_execution_links"]) == 22
    assert len(evidence["formal_parser_options"]) == 1

    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"] and sha(Path(item["path"]).read_bytes()) == item["sha256"]

    for item in evidence["logged_zig_test_binaries"]:
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]

    for item in evidence["test_execution_links"]:
        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        assert (execution / "packages/test" / item["compiled_root"]).is_file()

    for item in evidence["artifacts"]:
        assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
        assert Path(item["executed_source"]).read_bytes() == (doc / item["saved"]).read_bytes()

    summaries = evidence["native_summary_entries"]
    assert len(summaries) == 22 and all(" cached" not in line for line in summaries)
    assert sum(int(re.search(r" (\d+) pass", line).group(1)) for line in summaries) == checks

    if not original:
        assert {Path(item["path"]).name for item in evidence["logged_zig_test_binaries"]} == expected_names
        assert len(evidence["command_markers"]) == 2
        assert all(item["has_passing_native_summary"] for item in evidence["command_markers"])
        observed = [tuple(map(int, re.search(r"count=(\d+) allocated=(\d+) capacity=(\d+) payload=(\d+)", line).groups())) for line in evidence["capacity_observations"]]
        assert sorted(observed) == [(2048, 24648, 24624, 16384)] * 2 + [(16384, 196680, 196656, 131072)] * 2
        assert all(allocated < payload * 2 for count, allocated, capacity, payload in observed)

matrix = json.loads((doc / "目录审查结果.json").read_text())
assert matrix["catalog_cases"] == 128468 and matrix["unreviewed"] == 50630
assert matrix["reviewed"]["adapted"] == 812

print("PASS: frozen 5523-input source, 628 checks in 88 actual native executions, parser options, source/library identities and unchanged payload budget")
