from pathlib import Path
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

for group in ["toolchain_inputs", "dependency_inputs"]:
    for path, identity in baseline.get(group, {}).items():
        assert sha(Path(path).read_bytes()) == identity, path

for path in baseline["formal_files"]:
    assert (doc / "草稿" / path).read_bytes() == (root / path).read_bytes(), path

expected_roots = {
    "tests/incremental/artifact/" + name + "_test.zig"
    for name in ["extract", "invalid", "resources", "mixed/extract", "mixed/resources", "frontier/graph", "frontier/resources"]
}
new_names = []

for name in ["graph", "resources"]:
    source = root / ("packages/test/tests/incremental/artifact/frontier/" + name + "_test.zig")
    new_names.extend(line.split('"')[1] for line in source.read_text().split("\n") if line.startswith('test "'))

assert len(new_names) == len(set(new_names)) == 9

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "完整证据.json")).read_text())
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["passed"] and evidence["checks_passed"] == evidence["checks_total"] == 36
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    runs = evidence["actual_executions"]
    assert len(runs) == 7
    assert {run["compiled"]["root"] for run in runs} == expected_roots
    observed = []

    for run in runs:
        data = Path(run["path"]).read_bytes()
        assert sha(data) == run["sha256"]
        source = (root / "packages/test" / run["compiled"]["root"]).read_text()
        names = [line.split('"')[1] for line in source.split("\n") if line.startswith('test "')]
        assert names and all(name.encode() in data for name in names)
        observed.extend(name for name in names if name in new_names)

    assert sorted(observed) == sorted(new_names)

    for item in evidence["generated_source"]:
        data = Path(item["path"]).read_bytes()
        assert sha(data) == item["sha256"]
        if "saved" in item:
            assert (doc / item["saved"]).read_bytes() == data

    print(mode, evidence["summary"], "actual binaries", len(runs))

print("PASS: 9 new named tests, 72 actual checks across 14 binaries, frozen source and exact drafts")
