from pathlib import Path
import hashlib
import json
import sys

snapshot = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_inputs(baseline, source, replacement=None):
    for item in baseline["inputs"]:
        path = source / item["path"]

        if replacement and item["path"].endswith("/effects/resources_test.zig"):
            path = replacement

        assert digest(path) == item["sha256"], str(path)


final = json.loads((doc / "开始基线.json").read_text())
original = json.loads((doc / "原门禁/开始基线.json").read_text())
original_source = Path(json.loads((doc / "原门禁/源快照.json").read_text())["path"])
initial = json.loads((doc / "首轮/开始基线.json").read_text())

verify_inputs(final, snapshot)
verify_inputs(original, original_source)
verify_inputs(initial, original_source, doc / "首轮/resources_test.zig.txt")

changed = [
    path for path, sha in {item["path"]: item["sha256"] for item in initial["inputs"]}.items()
    if sha != {item["path"]: item["sha256"] for item in final["inputs"]}[path]
]
assert changed == ["packages/test/tests/ir/effects/resources_test.zig"]

for label in ["首轮Debug", "首轮ReleaseSafe", "原门禁Debug", "原门禁ReleaseSafe", "新门禁Debug", "新门禁ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())

    assert evidence["source_commit"] == final["source_commit"]
    assert evidence["packages_tree"] == final["packages_tree"]
    assert digest(doc / evidence["log"]) == evidence["log_sha256"]

    if not label.startswith("首轮"):
        assert evidence["passed"] and evidence["exit_code"] == 0

    for item in evidence["artifacts"]:
        assert digest(doc / item["saved"]) == item["sha256"]
        assert digest(Path(item["executed_source"])) == item["sha256"]

    for item in evidence["logged_zig_test_binaries"]:
        assert digest(Path(item["path"])) == item["sha256"]

replays = json.loads((doc / "二进制重放证据.json").read_text())
assert len(replays) == 6

for item in replays:
    assert item["exit_code"] == 0
    assert digest(Path(item["binary"]["path"])) == item["binary"]["sha256"]
    assert digest(snapshot / item["source"]) == item["source_sha256"]
    assert digest(doc / item["log"]) == item["log_sha256"]

for mode in ["Debug", "ReleaseSafe"]:
    selected = [item for item in replays if item["mode"] == mode]
    assert len(selected) == 3
    assert sum(len(item["names"]) for item in selected) == 40

print("PASS: frozen inputs, original gates, generated modules and 80 actual native named checks")
