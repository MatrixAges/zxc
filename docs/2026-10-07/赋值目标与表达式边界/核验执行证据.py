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

    for row in frozen["paths"]:
        assert digest(root / row["path"]) == row["sha256"], row["path"]
        assert digest(directory / "草稿" / row["path"]) == row["sha256"], row["path"]

    catalog = json.loads((root / "packages/test/suites.json").read_text())
    suites = {row["name"]: row for row in catalog["runtime"] if row["name"].startswith("assignment-boundaries-")}
    suites["conformance-frontend"] = {"path": "language/statements/assignment_boundaries/frontend", "kind": "frontend"}

    for label in ["Debug", "ReleaseSafe"]:
        evidence = json.loads((directory / (label + "证据.json")).read_text())
        assert evidence["source_commit"] == frozen["source_commit"]
        assert evidence["tests"] == 94 and len(evidence["binaries"]) == 10

        for row in evidence["logs"]:
            assert digest(directory / row["path"]) == row["sha256"]

        for row in evidence["binaries"]:
            assert digest(Path(row["binary_path"])) == row["binary_sha256"]
            replay = directory / row["replay_path"]
            assert digest(replay) == row["replay_sha256"]
            assert f"All {row['tests']} tests passed." in replay.read_text()

            for item in row["generated"]:
                assert digest(directory / item["path"]) == item["sha256"]

            suite = suites[row["name"]]
            source = root / ("packages/test/tests/" + suite["path"] + ".jsonl")
            ids = {json.loads(line)["id"] for line in source.read_text().splitlines()}
            saved = directory / next(item["path"] for item in row["generated"] if item["kind"] == "cases")
            compiled_ids = set(re.findall(r'^test "([^"]+)"', saved.read_text(), re.M))

            if suite["kind"] == "frontend":
                compiled_ids = {name for name in compiled_ids if "assignment_boundaries" in name}

            assert compiled_ids == ids and len(ids) == row["tests"]

            with tempfile.TemporaryDirectory() as temporary:
                target = Path(temporary) / "cases.zig"
                emitter = "frontend" if suite["kind"] == "frontend" else "control"
                sources = [str(root / ("packages/test/tests/" + path + ".jsonl")) for path in catalog["frontend"]] if emitter == "frontend" else [str(source)]
                subprocess.run(["node", str(root / ("packages/test/src/emit_" + emitter + "_tests.ts")), *sources, str(target)], check=True)
                assert target.read_bytes() == saved.read_bytes()

    originals = json.loads((directory / "上游原文执行证据.json").read_text())
    assert len(originals) == 44
    assert sum(row.get("checks", 0) for row in originals) == 70
    assert sum(row["executed"] for row in originals) == 32
    assert sum(row["result"] == "parse/SyntaxError" for row in originals) == 12
    print("PASS: 25 frozen paths, 20 native binaries, 188 case executions, exact generated expectations, and 44 upstream runs/negative parses")


if __name__ == "__main__":
    main()
