from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
label = sys.argv[2]
log = Path(sys.argv[3])
doc = Path(__file__).resolve().parent
package = root / "packages/test"
raw = log.read_bytes()
text = raw.decode()
summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", text)
assert summary and summary.group(1) == summary.group(2)
assert "error:" not in text
commands = {}
binaries = []
for line in text.splitlines():
    if not line.startswith("info(verbose): "):
        continue
    args = shlex.split(line.removeprefix("info(verbose): "))
    if "/zig test " in line and "--name" in args:
        name = args[args.index("--name") + 1]
        if name == "conformance-frontend" or name.startswith("state-update-reference-"):
            keys = ["-Mroot="] if name == "conformance-frontend" else ["-Mroot=", "-Mprogram="]
            commands[name] = [next(arg.split("=",1)[1] for arg in args if arg.startswith(key)) for key in keys]
    if len(args) > 1 and args[1].startswith("--cache-dir=") and (Path(args[0]).name == "conformance-frontend" or Path(args[0]).name.startswith("state-update-reference-")):
        binaries.append((package / args[0]).resolve())
assert len(binaries) == len(set(binaries)) == 6
records = []
for binary in binaries:
    run = subprocess.run([str(binary)], cwd=package, capture_output=True, timeout=60)
    output = run.stdout + run.stderr
    assert run.returncode == 0, output.decode()
    tests = int(re.search(rb"All (\d+) tests passed\.", output).group(1))
    assert tests == (174 if binary.name == "conformance-frontend" else 1)
    replay = doc / "二进制复跑" / label / f"{binary.name}.txt"
    replay.parent.mkdir(parents=True, exist_ok=True)
    replay.write_bytes(output)
    artifacts = []
    assert binary.name in commands
    for index, source in enumerate(commands[binary.name]):
        data = (package / source).read_bytes()
        saved = doc / "生成物" / label / f"{binary.name}-{index}.zig.txt"
        saved.parent.mkdir(parents=True, exist_ok=True)
        saved.write_bytes(data)
        artifacts.append({"path": str(saved.relative_to(doc)), "sha256": hashlib.sha256(data).hexdigest()})
    records.append({"name": binary.name,"binary": str(binary),"sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),"checks":tests,"replay":str(replay.relative_to(doc)),"replay_sha256":hashlib.sha256(output).hexdigest(),"artifacts":artifacts})
assert sum(item["checks"] for item in records) == 179
(doc / "日志").mkdir(exist_ok=True)
(doc / "日志" / f"{label}.txt").write_bytes(raw)
freeze = json.loads((doc / "输入冻结.json").read_text())
(doc / f"{label}证据.json").write_text(json.dumps({"source_commit":freeze["source_commit"],"checks":179,"records":records},ensure_ascii=False,indent=2) + "\n")
print(f"PASS: {label}, 6 binaries independently replayed, 179 checks")
