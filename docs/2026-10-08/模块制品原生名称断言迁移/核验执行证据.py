from pathlib import Path
import hashlib
import json
import re
import subprocess


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

path = "packages/test/tests/incremental/artifact/mixed/metadata.zig"
assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()
expected_roots = {"tests/incremental/artifact/" + name + "_test.zig" for name in ["extract", "invalid", "resources", "mixed/extract", "mixed/resources"]}

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "证据.json")).read_text())
    assert evidence["source_commit"] == baseline["commit"]
    assert evidence["exit_code"] == 0 and evidence["passed"]
    assert evidence["summary"] == "Build Summary: 32/32 steps succeeded; 27/27 tests passed"
    assert sha((doc / evidence["log"]).read_bytes()) == evidence["log_sha256"]
    executions = evidence["actual_native_executions"]
    assert len(executions) == 5
    assert {item["compiled"]["root"] for item in executions} == expected_roots

    for item in executions:
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
        option = Path(item["compiled"]["parser_options"]).read_bytes()
        assert re.search(rb"generated_parser(?:: bool)?\s*=\s*true", option)

    for item in evidence["generated_source"]:
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]
        if "saved" in item:
            assert sha((doc / item["saved"]).read_bytes()) == item["sha256"]
            assert (doc / item["saved"]).read_bytes() == Path(item["path"]).read_bytes()

    lines = (doc / evidence["log"]).read_text().splitlines()
    assert sum(int(re.search(r" (\d+) pass", line)[1]) for line in lines if "run test" in line and " pass" in line and " cached" not in line) == 27

print("PASS: frozen inputs; two complete module artifact gates; 54 checks and 10 actual binary executions with generated parser enabled.")
