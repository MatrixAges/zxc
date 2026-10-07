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
    frozen = json.loads((directory / "输入冻结.json").read_text())
    work = Path(frozen["worktree"]) / "packages/test"
    label, log_path = sys.argv[1:]
    raw = Path(log_path).read_bytes()
    text = raw.decode()

    assert label in ["Debug", "ReleaseSafe"]
    assert "121/121 steps succeeded; 352/352 tests passed" in text
    assert text.count("All 32 tests passed.") == 12
    assert text.count("All 40 tests passed.") == 12

    commands = {}
    native = []

    for line in text.splitlines():
        if not line.startswith("info(verbose): "):
            continue

        args = shlex.split(line.removeprefix("info(verbose): "))

        if "/zig test " in line and "--name" in args:
            name = args[args.index("--name") + 1]

            if name.startswith("function-updates-"):
                commands[name] = [next(value.split("=", 1)[1] for value in args if value.startswith(key)) for key in ["-Mprogram=", "-Mzxc_abi="]]

        if args[0] == "node" and args[1].endswith("/effects/run_test.ts"):
            native.append({"binary": args[11], "generated": args[3:6]})

    pure = [{"binary": path, "generated": commands[Path(path).name]} for path in re.findall(r"^info\(verbose\): (\S*/function-updates-\S+) --cache-dir=", text, re.M)]

    assert len(pure) == 18
    assert len(native) == 24

    records = []

    for item in pure + native:
        binary = (work / item["binary"]).resolve()
        name = binary.name
        execution = subprocess.run([str(binary)], cwd=work, capture_output=True)
        output = execution.stdout + execution.stderr

        assert execution.returncode == 0, (name, output.decode())

        match = re.search(rb"All (\d+) tests passed\.", output)

        assert match, name

        replay = directory / "二进制复跑" / label / (name + ".txt")
        replay.parent.mkdir(parents=True, exist_ok=True)
        replay.write_bytes(output)
        generated = []

        for index, path in enumerate(item["generated"]):
            data = (work / path).read_bytes()
            suffix = [".zig.txt", "-abi.zig.txt", "-native.json.txt"][index]
            saved = directory / "生成物" / label / (name + suffix)
            saved.parent.mkdir(parents=True, exist_ok=True)
            saved.write_bytes(data)
            generated.append({"path": str(saved.relative_to(directory)), "sha256": digest(data)})

        records.append({"name": name, "binary_path": str(binary), "binary_sha256": digest(binary.read_bytes()), "tests": int(match.group(1)), "exit_code": execution.returncode, "replay_path": str(replay.relative_to(directory)), "replay_sha256": digest(output), "generated": generated})

    assert len(records) == 42
    assert sum(row["tests"] for row in records) == 1216

    log = directory / "日志" / (label + ".txt")
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_bytes(raw)
    (directory / (label + "证据.json")).write_text(json.dumps({"source_commit": frozen["source_commit"], "checks": 1216, "records": records, "log_path": str(log.relative_to(directory)), "log_sha256": digest(raw)}, ensure_ascii=False, indent=2) + "\n")

    print(json.dumps({"optimize": label, "binaries": len(records), "checks": 1216}))


if __name__ == "__main__":
    main()
