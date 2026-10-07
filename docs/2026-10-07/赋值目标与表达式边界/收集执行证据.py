from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    directory = Path(__file__).resolve().parent
    work = Path(sys.argv[1]) / "packages/test"
    label, *log_paths = sys.argv[2:]
    commands = {}
    binaries = {}
    assert label in ["Debug", "ReleaseSafe"]

    for log_path in log_paths:
        text = Path(log_path).read_text()

        for line in text.splitlines():
            if not line.startswith("info(verbose): "):
                continue

            args = shlex.split(line.removeprefix("info(verbose): "))

            if "--name" in args and "test" in args:
                name = args[args.index("--name") + 1]

                if name.startswith("assignment-boundaries-") or name == "conformance-frontend":
                    commands[name] = {"cases": next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot="))}

                    if name == "conformance-frontend":
                        assert args[args.index("--test-filter") + 1] == "assignment_boundaries"
                    else:
                        commands[name]["program"] = next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mprogram="))

            if Path(args[0]).name.startswith("assignment-boundaries-") or Path(args[0]).name == "conformance-frontend":
                binaries[Path(args[0]).name] = args[0]

    assert re.search(r"Build Summary: (\d+)/\1 steps succeeded", text)
    suites = [row for row in json.loads((work / "suites.json").read_text())["runtime"] if row["name"].startswith("assignment-boundaries-")]
    suites.append({"name": "conformance-frontend", "path": "language/statements/assignment_boundaries/frontend"})
    names = {row["name"] for row in suites}
    commands = {name: value for name, value in commands.items() if name in names}
    binaries = {name: value for name, value in binaries.items() if name in names}
    assert len(commands) == len(binaries) == 10

    records = []

    for suite in suites:
        name = suite["name"]
        binary = (work / binaries[name]).resolve()
        execution = subprocess.run([str(binary)], cwd=work, capture_output=True)
        output = execution.stdout + execution.stderr
        assert execution.returncode == 0, (name, output.decode())
        count = len((work / ("tests/" + suite["path"] + ".jsonl")).read_text().splitlines())
        match = re.search(rb"All (\d+) tests passed\.", output)
        assert match and int(match[1]) == count
        replay = directory / "二进制复跑" / label / (name + ".txt")
        replay.parent.mkdir(parents=True, exist_ok=True)
        replay.write_bytes(output)
        generated = []

        for kind, path in commands[name].items():
            data = (work / path).read_bytes()
            saved = directory / "生成物" / label / (name + "-" + kind + ".zig.txt")
            saved.parent.mkdir(parents=True, exist_ok=True)
            saved.write_bytes(data)
            generated.append({"kind": kind, "path": str(saved.relative_to(directory)), "sha256": digest(data)})

        records.append({"name": name, "tests": count, "binary_path": str(binary), "binary_sha256": digest(binary.read_bytes()), "replay_path": str(replay.relative_to(directory)), "replay_sha256": digest(output), "generated": generated})

    assert len(records) == 10 and sum(row["tests"] for row in records) == 94
    saved_logs = []

    for index, path in enumerate(log_paths):
        data = Path(path).read_bytes()
        target = directory / "日志" / (label + str(index) + ".txt")
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
        saved_logs.append({"path": str(target.relative_to(directory)), "sha256": digest(data)})

    commit = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=work, text=True).strip()
    (directory / (label + "证据.json")).write_text(json.dumps({"source_commit": commit, "worktree": str(work.parent), "tests": 94, "binaries": records, "logs": saved_logs}, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"optimize": label, "binaries": len(records), "tests": 94}))


if __name__ == "__main__":
    main()
