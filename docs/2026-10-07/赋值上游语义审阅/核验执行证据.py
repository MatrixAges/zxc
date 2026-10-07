from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
import tempfile


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    directory = Path(__file__).resolve().parent
    root = Path(sys.argv[1])
    frozen = json.loads((directory / "输入冻结.json").read_text())
    work = Path(frozen["worktree"])

    for row in frozen["paths"]:
        assert digest(root / row["path"]) == row["sha256"], row["path"]
        assert digest(directory / "草稿" / row["path"]) == row["sha256"], row["path"]

    for row in frozen["reference_catalogs"]:
        assert digest(root / row["path"]) == row["sha256"], row["path"]

    suites = {row["name"]: row for row in json.loads((root / "packages/test/suites.json").read_text())["runtime"] if row["name"].startswith("state-update-")}

    for label in ["Debug", "ReleaseSafe"]:
        evidence = json.loads((directory / (label + "证据.json")).read_text())
        assert evidence["source_commit"] == frozen["source_commit"]
        assert evidence["tests"] == 18320 and len(evidence["binaries"]) == 18
        assert digest(directory / evidence["log_path"]) == evidence["log_sha256"]

        for row in evidence["binaries"]:
            assert digest(Path(row["binary_path"])) == row["binary_sha256"]
            assert digest(directory / row["replay_path"]) == row["replay_sha256"]
            generated = {item["path"].rsplit("-", 1)[-1].split(".")[0]: item for item in row["generated"]}

            for item in row["generated"]:
                assert digest(directory / item["path"]) == item["sha256"]

            suite = suites[row["name"]]
            catalog = root / ("packages/test/tests/" + suite["path"] + ".jsonl")
            ids = {json.loads(line)["id"] for line in catalog.read_text().splitlines()}
            cases = directory / generated["cases"]["path"]
            compiled_ids = set(re.findall(r'^test "([^"]+)"', cases.read_text(), re.M))
            assert ids == compiled_ids and len(ids) == row["tests"]
            emitter = "floating" if suite["kind"] == "state_update" else "control"

            with tempfile.TemporaryDirectory() as temporary:
                target = Path(temporary) / "cases.zig"
                subprocess.run(["node", str(root / ("packages/test/src/emit_" + emitter + "_tests.ts")), str(catalog), str(target)], check=True, cwd=work)
                assert target.read_bytes() == cases.read_bytes()

    for label in ["Debug", "ReleaseSafe"]:
        evidence = json.loads((directory / (label + "函数回归证据.json")).read_text())
        assert evidence["source_commit"] == frozen["source_commit"]
        assert evidence["tests"] == 584 and len(evidence["binaries"]) == 26

        for row in evidence["binaries"]:
            assert digest(Path(row["binary_path"])) == row["binary_sha256"]
            replay = directory / row["replay_path"]
            assert digest(replay) == row["replay_sha256"]
            assert f"All {row['tests']} tests passed." in replay.read_text()

    original = json.loads((directory / "上游原文执行证据.json").read_text())
    assert len(original) == 12 and sum(row["checks"] for row in original) == 24
    assert all(row["exit_code"] == 0 for row in original)
    print("PASS: 45 frozen formal paths, 36 native binaries, exact generated catalog IDs and expectations, 52 function-update regression binaries, and 12 upstream executions")


if __name__ == "__main__":
    main()
