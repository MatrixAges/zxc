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
doc = root / "docs/2026-10-07/定宽整数复合目标"
package = root / "packages/test"
raw = log.read_bytes()
text = raw.decode()
assert label in ["Debug", "ReleaseSafe"]
summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", text)
assert summary and summary.group(1) == summary.group(2)
assert "error:" not in text
records = []
reports = set()
for line in text.splitlines():
    if not line.startswith("info(verbose): node "):
        continue
    args = shlex.split(line.removeprefix("info(verbose): "))
    if args[1].endswith("/compound_integer/run_test.ts"):
        _, runner, binary, catalog, build_report = args
        kind = "compound"
    elif args[1].endswith("/run_integer_safety.ts"):
        _, runner, binary, catalog, build_report = args
        kind = "expression"
    else:
        continue
    binary = (package / binary).resolve()
    catalog = (package / catalog).resolve()
    build_report = (package / build_report).resolve()
    assert str(build_report) not in reports, str(build_report)
    reports.add(str(build_report))
    name = binary.name
    replay = doc / "进程复跑" / label / f"{name}.jsonl.txt"
    replay.parent.mkdir(parents=True, exist_ok=True)
    run = subprocess.run(["node", str(package / runner), str(binary), str(catalog), str(replay)], cwd=package, capture_output=True, text=True, timeout=90)
    assert run.returncode == 0, run.stdout + run.stderr
    (replay.parent / f"{name}.日志.txt").write_text(run.stdout + run.stderr)
    assert replay.read_bytes() == build_report.read_bytes(), name
    rows = [json.loads(line) for line in replay.read_text().splitlines()]
    assert len(rows) == len({row["id"] for row in rows}) and all(row["passed"] for row in rows)
    if kind == "compound":
        argv_rows = [json.loads(line) for line in catalog.read_text().splitlines()]
        assert len(rows) == len(argv_rows)
        for actual, expected in zip(rows, argv_rows):
            assert actual["id"] == expected["id"] and actual["status"] == expected["expected"]["status"]
            assert actual["stderr"] == expected["expected"]["stderr"] and actual["stdout"] == "" and actual["signal"] is None
        panics = sum(row["status"] == 86 for row in rows)
        application_errors = sum(row["stderr"].startswith("ZX_ERROR=") for row in rows)
    else:
        panics = sum(row["returncode"] == 86 for row in rows)
        application_errors = 0
    records.append({"kind": kind, "name": name, "binary": str(binary), "sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "catalog": str(catalog.relative_to(root)), "catalog_sha256": hashlib.sha256(catalog.read_bytes()).hexdigest(), "checks": len(rows), "panics": panics, "application_errors": application_errors, "replay": str(replay.relative_to(doc)), "replay_sha256": hashlib.sha256(replay.read_bytes()).hexdigest()})
assert len(records) == len({item["name"] for item in records}) == 42
assert sum(item["kind"] == "compound" for item in records) == 36
assert sum(item["checks"] for item in records if item["kind"] == "compound") == 50280
assert sum(item["checks"] for item in records if item["kind"] == "expression") == 464

artifacts = []
commands = {}
for line in text.splitlines():
    if not line.startswith("info(verbose): "):
        continue
    args = shlex.split(line.removeprefix("info(verbose): "))
    if "/zig build-exe " in line and "--name" in args:
        name = args[args.index("--name") + 1]
        if name.startswith("compound-integer-") or name.startswith("integer-safety-"):
            sources = [arg.split("=", 1)[1] for arg in args if arg.startswith(("-Mprogram=", "-Mzxc_abi="))]
            commands[name] = sources
for record in records:
    assert record["name"] in commands
    for index, path in enumerate(commands[record["name"]]):
        path = (package / path).resolve()
        saved = doc / "生成物" / label / f"{record['name']}-{index}.zig.txt"
        saved.parent.mkdir(parents=True, exist_ok=True)
        saved.write_bytes(path.read_bytes())
        artifacts.append({"path": str(saved.relative_to(doc)), "sha256": hashlib.sha256(saved.read_bytes()).hexdigest()})

(doc / "日志").mkdir(exist_ok=True)
log_saved = doc / "日志" / f"{label}.txt"
log_saved.write_bytes(raw)
freeze = json.loads((doc / "输入冻结.json").read_text())
evidence = {"source_commit": freeze["source_commit"], "optimize": label, "checks": 50744, "records": records, "artifacts": artifacts, "log_path": str(log_saved.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest()}
(doc / f"{label}证据.json").write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(f"PASS: {label}, 42 binaries, 50744 independently replayed process checks")
