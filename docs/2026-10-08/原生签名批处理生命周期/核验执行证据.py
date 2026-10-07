from pathlib import Path
import gzip
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

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "草稿" / path).read_bytes(), path

for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (label + "证据.json")).read_text())
    assert evidence["passed"] and evidence["exit_code"] == 0
    assert evidence["source_commit"] == baseline["source_commit"]
    log = (doc / evidence["log"]).read_bytes()
    assert sha(log) == evidence["log_sha256"]
    lines = log.decode().splitlines()
    roots = []

    for run in evidence["actual_executions"]:
        assert sha(Path(run["path"]).read_bytes()) == run["sha256"]
        assert lines[run["line"] - 1].startswith("info(verbose): ")
        roots.append(run["compiled"]["root"])

    assert any(path.endswith("tests/native/signatures/root_test.zig") for path in roots)
    assert evidence["formal_parser_options"]

    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"] and sha(Path(item["path"]).read_bytes()) == item["sha256"]

    for item in evidence["generated_source"]:
        data = Path(item["path"]).read_bytes()
        assert sha(data) == item["sha256"]
        if "saved" in item:
            saved = (doc / item["saved"]).read_bytes()
            assert (gzip.decompress(saved) if item.get("compression") == "gzip" else saved) == data

    print(label, evidence["summary"], "actual binaries", len(roots))

print("PASS: frozen execution inputs, both gate summaries, actual signature executions and generated parser identities")
