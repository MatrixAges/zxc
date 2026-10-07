import hashlib
import json
import pathlib
import re
import shlex
import shutil
import subprocess
import sys

root = pathlib.Path(sys.argv[1]).resolve()
label = sys.argv[2]
log = pathlib.Path(sys.argv[3])
doc = root / "docs/2026-10-07/整数复合赋值安全边界"
package = root / "packages/test"
text = log.read_text()
assert "Build Summary: 142/142 steps succeeded; 352/352 tests passed" in text
assert len(re.findall(r"isolated compound safety: (?:99/99|100/100|104/104) passed", text)) == 20
records = []
for line in text.splitlines():
    if not line.startswith("info(verbose): node ") or "/safety/run_test.ts " not in line:
        continue
    command = shlex.split(line.removeprefix("info(verbose): "))
    _, runner, zig, source, types, metadata, process, optimize, probe, mode, binary = command
    assert optimize == {"Debug": "debug", "ReleaseSafe": "safe"}[label]
    binary = (package / binary).resolve()
    route = binary.name.rsplit("-", 1)[1]
    directory = doc / "执行证据" / label / f"{mode}-{route}"
    directory.mkdir(parents=True, exist_ok=True)
    replay = directory / "复跑结果.txt"
    run = subprocess.run(["node", str(package / "tests/collections/function_updates/safety/run_process.ts"), str(binary), mode, str(replay)], capture_output=True, text=True, timeout=60)
    assert run.returncode == 0, run.stdout + run.stderr
    (directory / "复跑日志.txt").write_text(run.stdout + run.stderr)
    saved = json.loads(replay.read_text())
    original = json.loads((binary.parent / "results.json").read_text())
    assert saved == original
    assert saved["passed"] == saved["total"] == (100 if mode.endswith("divide") else 99 if mode.endswith("remainder") else 104)
    assert len(saved["results"]) == saved["total"] and all(item["passed"] for item in saved["results"])
    artifacts = []
    for name, path in [("生成程序.zig.txt", package / source), ("生成接口.zig.txt", package / types), ("原生元数据.txt", package / metadata), ("编译参数.txt", binary.parent / "compilation.json")]:
        shutil.copyfile(path, directory / name)
        artifacts.append({"path": str((directory / name).relative_to(doc)), "sha256": hashlib.sha256((directory / name).read_bytes()).hexdigest()})
    records.append({"mode": mode, "route": route, "binary": str(binary), "sha256": saved["sha256"], "checks": saved["total"], "panics": sum(item["status"] == 86 for item in saved["results"]), "application_errors": sum(item["stderr"].startswith("ZX_ERROR=") for item in saved["results"]), "replay": str(replay.relative_to(doc)), "replay_sha256": hashlib.sha256(replay.read_bytes()).hexdigest(), "artifacts": artifacts})
assert len(records) == 20
assert len({(record["mode"], record["route"]) for record in records}) == 20
assert sum(record["checks"] for record in records) == 2044
(doc / "日志").mkdir(exist_ok=True)
shutil.copyfile(log, doc / "日志" / f"{label}.txt")
freeze = json.loads((doc / "输入冻结.json").read_text())
(doc / f"{label}证据.json").write_text(json.dumps({"source_commit": freeze["source_commit"], "optimize": label, "checks": 2044, "records": records}, ensure_ascii=False, indent=2) + "\n")
print(f"PASS: {label}, 20 independently replayed binaries, 2044 checks")
