from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

mode = sys.argv[1]
doc = Path(__file__).resolve().parent
original = json.loads((doc / "原门禁参数.json").read_text())
root = Path(original["worktree"])
draft = doc / "草稿/packages/test/tests/language/lexical/scanner_metadata"
cache = Path("/tmp/zxc-scanner-contract-cache")
outputs = Path("/tmp/zxc-scanner-contract-binaries")
outputs.mkdir(exist_ok=True)
(doc / "日志").mkdir(exist_ok=True)
records = []

for group in ["boundaries", "words", "symbols", "templates", "resources"]:
    binary = outputs / f"{mode}-{group}"
    args = []

    for item in original["command"]:
        if item == "--listen=-":
            continue
        if item.startswith("-O"):
            item = "-Odebug" if mode == "Debug" else "-Osafe"
        if item.startswith("-Mroot="):
            item = f"-Mroot={draft / (group + '_test.zig')}"
        if item.startswith("-Mallocation_testing="):
            item = f"-Mallocation_testing={root / 'packages/test/tests/support/allocation_testing.zig'}"
        args.append(item)

    args[args.index("--cache-dir") + 1] = str(cache)
    args.extend(["--test-no-exec", f"-femit-bin={binary}"])
    built = subprocess.run(args, cwd=root, capture_output=True, timeout=180)
    build_log = doc / "日志" / f"{mode}-{group}-编译.txt"
    build_log.write_bytes(built.stdout + built.stderr)
    assert built.returncode == 0, built.stderr.decode()
    result = subprocess.run([str(binary)], capture_output=True, timeout=180)
    raw = result.stdout + result.stderr
    log = doc / "日志" / f"{mode}-{group}-执行.txt"
    log.write_bytes(raw)
    match = re.search(rb"All (\d+) tests passed\.", raw)
    assert result.returncode == 0 and match is not None, raw.decode()
    records.append({"group": group, "command": args, "build_exit_code": built.returncode,
                    "binary": str(binary), "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
                    "run_exit_code": result.returncode, "checks": int(match.group(1)),
                    "log": str(log.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(),
                    "build_log": str(build_log.relative_to(doc)), "build_log_sha256": hashlib.sha256(build_log.read_bytes()).hexdigest()})
    print(json.dumps({"mode": mode, "group": group, "checks": int(match.group(1)), "exit_code": result.returncode}), flush=True)

evidence = {"mode": mode, "source_commit": original["source_commit"], "scanner": original["scanner"],
            "scanner_sha256": original["scanner_sha256"], "records": records,
            "checks": sum(row["checks"] for row in records),
            "sources": [{"path": str(p.relative_to(doc)), "sha256": hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(draft.glob("*.zig"))],
            "scope": "all five registered scanner metadata test roots, using the real generated scanner and original module arguments; no test filter"}
(doc / f"{mode}执行证据.json").write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(f"PASS: {mode}, five scanner roots, {evidence['checks']} checks")
