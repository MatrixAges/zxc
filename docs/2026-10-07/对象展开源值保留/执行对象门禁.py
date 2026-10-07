from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

mode = sys.argv[1]
doc = Path(__file__).resolve().parent
root = Path("/Users/xiewendao/.codex/worktrees/semantic-gate-regression/zxc")
cli = Path("/tmp/zxc-canonical-fixed-safe-cache/o/32ec13f0921e557b26e13dc4a7a55bbc/zxc")
draft = doc / "草稿/packages/test"
output = Path("/tmp/zxc-object-preservation") / mode
output.mkdir(parents=True, exist_ok=True)
(doc / "日志").mkdir(exist_ok=True)
records = []
entries = []

for group in ["merge", "override"]:
    base = draft / "tests/language/expressions/object_construction" / group
    rows = [json.loads(line) for line in base.with_suffix(".jsonl").read_text().splitlines()]
    entries.append((group, base.with_suffix(".zx"), rows, "runtime"))

frontend = [json.loads(line) for line in (draft / "tests/language/types/object_construction/source_preservation.jsonl").read_text().splitlines()]
sample = json.loads((doc / "输入冻结.json").read_text())["samples"][1]
values = dict(zip(sample["fields"], sample["values"]))

for row in frontend:
    name = "source_" + row["id"].split("/")[-1].replace(".", "_")
    source = output / f"{name}.zx"
    source.write_text(row["source"])
    entries.append((name, source, [{"id": row["id"], "expected": {"value": values[row["id"].split("/")[-1]]}}], "frontend_source"))

for name, source, rows, kind in entries:
    folder = output / name
    folder.mkdir(exist_ok=True)
    program = folder / "program.zig"
    cases = folder / "cases.zig"
    binary = folder / "tests"
    command = [str(cli), str(source), "--out", str(program)]
    result = subprocess.run(command, cwd=root, capture_output=True, timeout=180)
    assert result.returncode == 0, result.stderr.decode()
    compile_log = doc / "日志" / f"{mode}-{name}-CLI.txt"
    compile_log.write_bytes(result.stdout + result.stderr)

    if kind == "runtime":
        emitter = ["node", str(root / "packages/test/src/emit_control_tests.ts"), str(source.with_suffix(".jsonl")), str(cases)]
        subprocess.run(emitter, cwd=root, check=True, timeout=60)
    else:
        row = rows[0]
        cases.write_text(f'const check = @import("support").check;\n\ntest "{row["id"]}" {{\n    try check(@import("program"), {{}}, .{{ .value = {row["expected"]["value"]} }});\n}}\n')

    optimize = "-Odebug" if mode == "Debug" else "-Osafe"
    build = ["zig", "test", optimize, "--dep", "support", "--dep", "program", f"-Mroot={cases}", optimize,
             f"-Msupport={root / 'packages/test/tests/support/control.zig'}", optimize, f"-Mprogram={program}",
             "--cache-dir", "/tmp/zxc-object-preservation-cache", "--test-no-exec", f"-femit-bin={binary}"]
    result = subprocess.run(build, cwd=root, capture_output=True, timeout=180)
    assert result.returncode == 0, result.stderr.decode()
    build_log = doc / "日志" / f"{mode}-{name}-Zig.txt"
    build_log.write_bytes(result.stdout + result.stderr)
    result = subprocess.run([str(binary)], capture_output=True, timeout=60)
    raw = result.stdout + result.stderr
    assert result.returncode == 0 and f"All {len(rows)} tests passed.".encode() in raw, raw.decode()
    log = doc / "日志" / f"{mode}-{name}-执行.txt"
    log.write_bytes(raw)
    artifacts = []

    for artifact in [source, program, cases]:
        target = doc / "生成物" / mode / name / (artifact.name + ".txt")
        target.parent.mkdir(parents=True, exist_ok=True)
        data = artifact.read_bytes()
        target.write_bytes(data)
        artifacts.append({"path": str(target.relative_to(doc)), "executed_source": str(artifact), "sha256": hashlib.sha256(data).hexdigest()})

    records.append({"name": name, "kind": kind, "cli_command": command, "build_command": build,
                    "binary": str(binary), "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
                    "checks": len(rows), "exit_code": result.returncode, "log": str(log.relative_to(doc)),
                    "log_sha256": hashlib.sha256(raw).hexdigest(), "artifacts": artifacts})
    print(json.dumps({"mode": mode, "name": name, "checks": len(rows), "exit_code": result.returncode}), flush=True)

evidence = {"mode": mode, "source_commit": subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip(),
            "cli": str(cli), "cli_sha256": hashlib.sha256(cli.read_bytes()).hexdigest(), "records": records,
            "checks": sum(row["checks"] for row in records),
            "scope": "merge/override and both exact frontend source programs compile through real CLI; each frontend source additionally executes its original field value; not the full frontend aggregate step"}
(doc / f"{mode}执行证据.json").write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(f"PASS: {mode}, four real programs, {evidence['checks']} checks")
