from pathlib import Path
import hashlib
import json
import os
import re
import subprocess
import sys

mode = sys.argv[1]
cli = Path(sys.argv[2]).resolve()
worktree = Path(sys.argv[3]).resolve()
doc = Path(__file__).resolve().parent
draft = doc / "草稿/packages/test/tests"
solver = "/tmp/zxc-z3-5.1.0/z3-5.1.0-x64-osx-13.3/bin/z3"
paths = [f"semantic_lint/{group}_test.ts" for group in ["project", "options", "rx", "workspace", "compiled"]]
paths.append("verification/enumeration/verify_test.ts")
records = []

for path in paths:
    command = ["node", str(draft / path), str(cli)]
    result = subprocess.run(command, env={**os.environ, "ZXC_TEST_SOLVER": solver}, capture_output=True, timeout=180)
    raw = result.stdout + result.stderr
    text = raw.decode()
    name = path.replace("/", "-").removesuffix(".ts")
    log = doc / "日志" / f"{mode}-{name}.txt"
    log.write_bytes(raw)
    counts = {}

    for key in ["tests", "pass", "fail", "cancelled", "skipped", "todo"]:
        match = re.search(rf"^ℹ {key} (\d+)$", text, re.MULTILINE)
        assert match is not None, (path, key, text[-1500:])
        counts[key] = int(match.group(1))

    row = {"path": path, "command": command, "exit_code": result.returncode, "counts": counts,
           "log": str(log.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest()}
    records.append(row)
    print(json.dumps({"mode": mode, "path": path, "exit_code": result.returncode, **counts}, ensure_ascii=False), flush=True)

source_paths = json.loads((doc / "原始输入冻结.json").read_text())["paths"]
sources = []

for item in source_paths:
    data = (doc / "草稿" / item["path"]).read_bytes()
    sources.append({"path": item["path"], "sha256": hashlib.sha256(data).hexdigest()})

evidence = {"mode": mode, "source_commit": subprocess.check_output(["git", "-C", str(worktree), "rev-parse", "HEAD"], text=True).strip(),
            "packages_tree": subprocess.check_output(["git", "-C", str(worktree), "rev-parse", "HEAD:packages"], text=True).strip(),
            "cli": str(cli), "cli_sha256": hashlib.sha256(cli.read_bytes()).hexdigest(),
            "solver": solver, "solver_sha256": hashlib.sha256(Path(solver).read_bytes()).hexdigest(),
            "draft_sources": sources, "records": records, "checks": sum(row["counts"]["tests"] for row in records),
            "scope": "original semantic lint and enum verification assertions using real compiled CLI and Z3; not a complete root regression"}
(doc / f"{mode}执行证据.json").write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
assert all(row["exit_code"] == 0 and row["counts"]["tests"] == row["counts"]["pass"] and not any(row["counts"][key] for key in ["fail", "cancelled", "skipped", "todo"]) for row in records)
print(f"PASS: {mode}, {len(records)} original groups, {evidence['checks']} checks")
