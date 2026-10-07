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
    label, log_path = sys.argv[2:]
    log = Path(log_path).read_bytes()
    text = log.decode()
    assert re.search(r"Build Summary: (\d+)/\1 steps succeeded", text)
    suites = [row for row in json.loads((work / "suites.json").read_text())["runtime"] if row["name"].startswith("state-update-")]
    commands = {}
    binaries = {}

    for line in text.splitlines():
        if not line.startswith("info(verbose): "):
            continue

        args = shlex.split(line.removeprefix("info(verbose): "))

        if "--name" in args and "test" in args:
            name = args[args.index("--name") + 1]

            if name.startswith("state-update-"):
                commands[name] = {
                    "program": next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mprogram=")),
                    "cases": next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot=")),
                }

        if Path(args[0]).name.startswith("state-update-"):
            binaries[Path(args[0]).name] = args[0]

    assert len(commands) == 18
    previous = {}
    evidence_path = directory / (label + "证据.json")

    if evidence_path.exists():
        previous = {row["name"]: row["binary_path"] for row in json.loads(evidence_path.read_text())["binaries"]}

    records = []

    for suite in suites:
        name = suite["name"]
        binary = (work / binaries.get(name, previous.get(name, "absent"))).resolve()
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
            generated.append({"path": str(saved.relative_to(directory)), "sha256": digest(data)})

        records.append({"name": name, "tests": count, "binary_path": str(binary), "binary_sha256": digest(binary.read_bytes()), "replay_path": str(replay.relative_to(directory)), "replay_sha256": digest(output), "generated": generated})

    assert len(records) == 18 and sum(row["tests"] for row in records) == 18320
    saved_log = directory / "日志" / (label + ".txt")
    saved_log.parent.mkdir(parents=True, exist_ok=True)
    saved_log.write_bytes(log)
    evidence_path.write_text(json.dumps({"source_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=work, text=True).strip(), "worktree": str(work.parent), "tests": 18320, "log_path": str(saved_log.relative_to(directory)), "log_sha256": digest(log), "binaries": records}, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"optimize": label, "binaries": len(records), "tests": 18320}))


if __name__ == "__main__":
    main()
