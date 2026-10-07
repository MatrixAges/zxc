from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
label, group, log_path = sys.argv[2:5]
log = Path(log_path)
doc = Path(__file__).resolve().parent
package = root / "packages/test"
raw = log.read_bytes()
text = raw.decode()
summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", text)
assert summary and summary.group(1) == summary.group(2) and "error:" not in text
commands = {}
binaries = []
for line in text.splitlines():
    if not line.startswith("info(verbose): "):
        continue
    args = shlex.split(line.removeprefix("info(verbose): "))
    if "/zig test " in line and "--name" in args:
        name = args[args.index("--name") + 1]
        if name == "conformance-frontend" or name.startswith("switch-scalars-"):
            keys = ["-Mroot="] if name == "conformance-frontend" else ["-Mroot=", "-Mprogram="]
            commands[name] = [next(arg.split("=", 1)[1] for arg in args if arg.startswith(key)) for key in keys]
    if len(args) > 1 and args[1].startswith("--cache-dir="):
        name = Path(args[0]).name
        if name == "conformance-frontend" or name.startswith("switch-scalars-"):
            binaries.append((package / args[0]).resolve())
assert len(binaries) == len(set(binaries)) == (5 if group == "所有权" else 1)
records = []
for binary in binaries:
    run = subprocess.run([str(binary)], cwd=package, capture_output=True, timeout=60)
    output = run.stdout + run.stderr
    assert run.returncode == 0, output.decode()
    checks = int(re.search(rb"All (\d+) tests passed\.", output).group(1))
    expected = {"所有权": 412, "分支类型": 11, "可选类型": 12}[group] if binary.name == "conformance-frontend" else {"integer": 4, "string": 6, "boolean": 2, "enumeration": 4}[binary.name.removeprefix("switch-scalars-")]
    assert checks == expected, (binary.name, checks, expected)
    replay = doc / "复跑" / label / f"{group}-{binary.name}.txt"
    replay.parent.mkdir(parents=True, exist_ok=True)
    replay.write_bytes(output)
    artifacts = []
    for index, source in enumerate(commands[binary.name]):
        data = (package / source).read_bytes()
        saved = doc / "生成物" / label / f"{group}-{binary.name}-{index}.zig.txt"
        saved.parent.mkdir(parents=True, exist_ok=True)
        saved.write_bytes(data)
        artifacts.append({"path": str(saved.relative_to(doc)), "executed_source": str((package / source).resolve()), "sha256": hashlib.sha256(data).hexdigest()})
    records.append({"name": binary.name, "binary": str(binary), "sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "checks": checks, "replay": str(replay.relative_to(doc)), "replay_sha256": hashlib.sha256(output).hexdigest(), "artifacts": artifacts})
checks = sum(record["checks"] for record in records)
assert checks == {"所有权": 428, "分支类型": 11, "可选类型": 12}[group]
(doc / "日志").mkdir(exist_ok=True)
(doc / "日志" / f"{label}-{group}.txt").write_bytes(raw)
freeze = json.loads((doc / "输入冻结.json").read_text())
(doc / f"{label}-{group}证据.json").write_text(json.dumps({"source_commit": freeze["source_commit"], "checks": checks, "records": records}, ensure_ascii=False, indent=2) + "\n")
print(f"PASS: {label} / {group}, {len(records)} actual binaries, {checks} independent replay checks")
