from pathlib import Path
import gzip
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
sha = lambda data: hashlib.sha256(data).hexdigest()


def verifyInputs(name):
    baseline = json.loads((doc / name).read_text())
    root = Path(baseline["root"])
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

    for path, identity in baseline["inputs"].items():
        assert sha((root / path).read_bytes()) == identity, path
        assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

    for path, identity in baseline["toolchain_inputs"].items():
        assert sha(Path(path).read_bytes()) == identity, path

    return baseline


def verifyGate(name, baseline, modes, passed):
    evidence = json.loads((doc / name).read_text())
    assert evidence["passed"] == passed
    assert evidence["exit_code"] == (0 if passed else 1)
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["tests_passed"] == evidence["tests_total"] == len(modes) * 10
    raw = (doc / evidence["log"]).read_bytes()
    assert sha(raw) == evidence["log_sha256"]
    lines = raw.decode().split("\n")
    expected = {f"nested-buffer-{mode}-{route}" for mode in modes for route in ["source", "library"]}
    executions = evidence["actual_executions"]
    assert len(executions) == len(expected)
    assert {run["compiled"]["name"] for run in executions} == expected

    for run in executions:
        assert sha(Path(run["path"]).read_bytes()) == run["sha256"]
        assert run["compiled"]["root"] == "tests/collections/nested_buffer/root.zig"
        assert lines[run["line"] - 1].startswith("info(verbose): ")
        assert lines[run["compiled"]["compile_line"] - 1].startswith("info(verbose): ")

    assert evidence["formal_parser_options"]

    for item in evidence["formal_parser_options"]:
        assert item["generated_parser"]
        assert sha(Path(item["path"]).read_bytes()) == item["sha256"]

    for item in evidence["generated_source"]:
        data = Path(item["path"]).read_bytes()
        assert sha(data) == item["sha256"]

        if "saved" in item:
            saved = (doc / item["saved"]).read_bytes()
            assert (gzip.decompress(saved) if item.get("compression") == "gzip" else saved) == data

    if not passed:
        assert raw.count(b"error: cannot assign to constant") == 2
        assert b"source.zig:892:33" in raw and b"library.zig:892:33" in raw

    print(name, evidence["summary"], "actual binaries", len(executions))


fixed = verifyInputs("执行输入.json")
old = verifyInputs("修复前执行输入.json")
assert fixed["formal_files"] == old["formal_files"]
assert len(fixed["formal_files"]) == 14

for path in fixed["formal_files"]:
    assert fixed["inputs"][path] == old["inputs"][path]
    data = (doc / "草稿" / path).read_bytes()
    assert sha(data) == fixed["inputs"][path], path

    if path.endswith(".zx"):
        assert len(data.replace(b"\r\n", b"\n").replace(b"\r", b"\n").split(b"\n")) - int(data.endswith(b"\n")) <= 120

delta = subprocess.check_output(["git", "diff", "--name-only", old["source_commit"], fixed["source_commit"], "--", "packages"], cwd=fixed["root"], text=True).strip()
assert delta == "packages/genz/src/zx/iteration_buffer/root.zig"
modes = ["object", "tuple", "dual", "fresh", "modular"]
verifyGate("Debug证据.json", fixed, modes, True)
verifyGate("ReleaseSafe证据.json", fixed, modes, True)
verifyGate("修复前Debug证据.json", old, modes[:-1], False)
print("PASS: frozen inputs, identical regression tests, actual binaries, parser and generated source identities")
