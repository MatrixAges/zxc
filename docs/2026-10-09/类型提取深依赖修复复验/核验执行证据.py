from pathlib import Path

import hashlib
import json
import re

doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()

for name, expected in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == expected, name

for name, expected in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == expected, name

for item in inputs["external_inputs"].values():
    assert sha(Path(item["snapshot"]).read_bytes()) == item["sha256"]

for name in inputs["formal"]:
    assert (root / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

generator = json.loads((run / "generator-state.json").read_text())

assert generator["status"] == "terminal" and generator["exit_code"] == 0
assert len(generator["generated"]) == 81
assert sha((run / "generate-parser").read_bytes()) == generator["generator_binary_sha256"]

for name, expected in generator["generated"].items():
    assert sha(Path(name).read_bytes()) == expected, name

for item in generator["steps"]:
    assert item["exit_code"] == 0

    assert sha(Path(item["log"]).read_bytes()) == item["log_sha256"]

roots = ["invalid", "resources", "mixed-extract", "mixed-resources", "extract", "frontier-resources", "frontier-graph"]
new_names = []

for name in ["graph_test.zig", "resources_test.zig"]:
    new_names += re.findall(r'test "([^"]+)"', (root / "packages/test/tests/incremental/artifact/frontier" / name).read_text())

assert len(new_names) == 9 and len(set(new_names)) == 9

totals = {}

for mode in ["Audit", "Debug", "ReleaseSafe"]:
    state = json.loads((run / (mode + "-state.json")).read_text())

    assert state["status"] == "terminal" and state["exit_code"] == 0

    assert len(state["executions"]) == (1 if mode == "Audit" else 7)

    if mode != "Audit":
        assert [item["name"] for item in state["executions"]] == roots

    total = 0
    observed = []

    for name, expected in state["external"].items():
        assert sha(Path(name).read_bytes()) == expected, name

    for item in state["executions"]:
        assert item["compile_exit"] == item["signature_exit"] == item["exit_code"] == 0

        assert sha(Path(item["binary"]).read_bytes()) == item["binary_sha256"]
        assert sha(Path(item["compile_log"]).read_bytes()) == item["compile_log_sha256"]

        log = Path(item["log"]).read_bytes()

        assert sha(log) == item["log_sha256"]
        archived = doc / "日志" / Path(item["log"]).name

        if archived.exists():
            assert archived.read_bytes() == log, archived

        text = log.decode()
        matched = re.findall(r"All (\d+) tests passed\.", text)

        assert len(matched) == 1, item["name"]

        total += int(matched[0])

        for name in new_names:
            if name in text:
                observed.append(name)

    assert total == (1 if mode == "Audit" else 36), (mode, total)

    if mode != "Audit":
        assert sorted(observed) == sorted(new_names)

    totals[mode] = total

audit = json.loads((run / "Audit-state.json").read_text())
text = Path(audit["executions"][0]["log"]).read_text()
parts = text.split("\x1e")[1:]
expected_files = sum(depth + 2 for depth in [0, 1, 17, 65, 255, 257])

assert len(parts) == expected_files, len(parts)

maximum = 0

for part in parts:
    identity, content = part.split("\x1f", 1)

    content = content.split("OK\n", 1)[0]

    assert "\r" not in content
    lines = content.count("\n") + (not content.endswith("\n"))

    assert lines <= 120, identity

    maximum = max(maximum, lines)

for path in doc.rglob("*.md"):
    assert len(path.read_text().split("\n")) < 1000, path

print("PASS:", len(inputs["packages"]), "frozen package files; 81 regenerated modules;", totals, "; 9 new named tests;", expected_files, "formatted ZX files, maximum", maximum, "physical lines")
