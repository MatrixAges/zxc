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

for path, identity in baseline["toolchain_inputs"].items():
    assert sha(Path(path).read_bytes()) == identity, path

previous = json.loads((doc / "旧失败输入摘要.json").read_text())

for name in ["initialization", "names", "nodes", "views", "resources"]:
    path = "packages/test/tests/language/types/resolution/" + name + "_test.zig"
    assert previous["test_roots"][path] == baseline["inputs"][path]

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "完整证据.json")).read_text())
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["passed"] and evidence["checks_passed"] == evidence["checks_total"] == 63
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    runs = evidence["actual_executions"]
    assert len(runs) == 5
    assert {run["compiled"]["name"] for run in runs} == {"type-resolution-" + name for name in ["initialization", "names", "nodes", "views", "resources"]}

    for run in runs:
        assert sha(Path(run["path"]).read_bytes()) == run["sha256"]
        source = (root / "packages/test" / run["compiled"]["root"]).read_text()
        names = [line.split('"')[1] for line in source.split("\n") if line.startswith('test "')]
        data = Path(run["path"]).read_bytes()
        assert names and all(name.encode() in data for name in names)

    for item in evidence["generated_source"]:
        data = Path(item["path"]).read_bytes()
        assert sha(data) == item["sha256"]
        if "saved" in item:
            assert (doc / item["saved"]).read_bytes() == data

    print(mode, evidence["summary"], "actual binaries", 5)

print("PASS: same five test roots, frozen source and tools, 126 actual checks at the fixed reference")
