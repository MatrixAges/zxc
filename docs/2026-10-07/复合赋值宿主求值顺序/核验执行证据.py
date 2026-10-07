from pathlib import Path
import hashlib
import json
import re
import sys


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    directory = Path(__file__).resolve().parent
    root = Path(sys.argv[1])
    frozen = json.loads((directory / "输入冻结.json").read_text())

    for row in frozen["paths"]:
        assert digest(root / row["path"]) == row["sha256"], row["path"]
        assert digest(directory / "草稿" / row["path"]) == row["sha256"], row["path"]

    names = set()

    for label in ["Debug", "ReleaseSafe"]:
        evidence = json.loads((directory / (label + "证据.json")).read_text())
        assert evidence["source_commit"] == frozen["source_commit"]
        assert evidence["checks"] == 1216 and len(evidence["records"]) == 42
        assert digest(directory / evidence["log_path"]) == evidence["log_sha256"]
        assert sum(row["tests"] for row in evidence["records"]) == 1216

        for row in evidence["records"]:
            names.add(row["name"])
            assert digest(Path(row["binary_path"])) == row["binary_sha256"]
            replay = directory / row["replay_path"]
            assert digest(replay) == row["replay_sha256"]
            assert f"All {row['tests']} tests passed." in replay.read_text()

            for item in row["generated"]:
                assert digest(directory / item["path"]) == item["sha256"]

    assert len(names) == 42
    modes = set()

    for operation, token in [("subtract", "-="), ("multiply", "*="), ("divide", "/="), ("remainder", "%=")]:
        for prefix in ["", "nested_"]:
            mode = "effects_" + prefix + operation
            source = root / ("packages/test/tests/collections/function_updates/fixtures/" + mode + ".zx")
            assert token + " probe.value(state.delta)" in source.read_text()
            assert "function-updates-" + mode + "-source" in names
            assert "function-updates-" + mode + "-library" in names
            modes.add(mode)

    assert len(modes) == 8
    originals = json.loads((directory / "上游原文清单.json").read_text())
    assert len(originals) == 44 and sum(row["assertions"] for row in originals) == 66
    hashes = {row["path"]: row["sha256"] for row in originals}

    for engine, failures, calls in [("Node", 22, 154), ("Bun", 0, 132)]:
        evidence = json.loads((directory / ("上游原文执行证据-" + engine + ".json")).read_text())
        assert evidence["engine"] == engine and len(evidence["records"]) == 88
        assert sum(not row["passed"] for row in evidence["records"]) == failures
        assert sum(row["assertion_calls"] for row in evidence["records"]) == calls
        seen = set()

        for row in evidence["records"]:
            assert hashes[row["path"]] == row["sha256"]
            seen.add((row["path"], row["mode"]))

            if not row["passed"]:
                assert row["path"].endswith("_T4.js")
                assert row["failure"]["name"] == "Test262Error"
                assert row["failure"]["message"] == "Expected true but got false"

        assert len(seen) == 88

    print("PASS: 15 frozen paths, 84 native binaries, 2432 native checks, and both engines' 176 original executions with preserved reference failures")


if __name__ == "__main__":
    main()
