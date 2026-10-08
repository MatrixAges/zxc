from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys


doc = Path(__file__).resolve().parent
label = sys.argv[1]
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
cwd = root / "packages/test"
run = Path(baseline["run"])
state = json.loads((run / (label + "-state.json")).read_text())
assert state["status"] == "terminal" and state["exit_code"] is not None
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

for group in ["toolchain_inputs", "dependency_inputs"]:
    for path, identity in baseline.get(group, {}).items():
        assert sha(Path(path).read_bytes()) == identity, path

raw = Path(state["log"]).read_bytes()
lines = raw.decode().split("\n")
summary = next(line for line in reversed(lines) if line.startswith("Build Summary:"))
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
checks = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps
commands = []
executions = []
generated = {}
pending = {}
options = []

for index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue

    command = line.removeprefix("info(verbose): ")
    args = [re.sub(rb"\\([0-7]{3})", lambda match: bytes([int(match[1], 8)]), arg.encode()).decode() for arg in shlex.split(command)]
    commands.append({"line": index + 1, "command": command})

    if len(args) > 1 and args[1] == "test":
        name = args[args.index("--name") + 1] if "--name" in args else "test"
        test_root = next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot="))
        pending.setdefault(name, []).append({"line": index + 1, "name": name, "root": test_root})

    if len(args) > 1 and args[1].startswith("--cache-dir="):
        binary = (cwd / args[0]).resolve()
        candidates = pending.get(binary.name, [])
        compiled = candidates.pop() if len(candidates) == 1 else None
        executions.append({"line": index + 1, "path": str(binary), "sha256": sha(binary.read_bytes()), "compiled": compiled, "unresolved_candidates": list(candidates) if compiled is None else []})

    for arg in args:
        if not re.match(r"-M(?:root|program|zxc_abi|generated[^=]*|parser_options|options)=", arg):
            continue

        path = (cwd / arg.split("=", 1)[1]).resolve()
        if not path.is_file() or path.is_relative_to(root) or str(path) in generated:
            continue

        data = path.read_bytes()
        identity = sha(data)
        item = {"path": str(path), "sha256": identity}

        if arg.startswith("-Mparser_options="):
            match = re.search(rb"generated_parser(?:: bool)?\s*=\s*(true|false)", data)
            assert match is not None
            saved = doc / "解析选项" / (identity + ".zig.txt")
            saved.parent.mkdir(exist_ok=True)
            saved.write_bytes(data)
            item["saved"] = str(saved.relative_to(doc))
            options.append({**item, "generated_parser": match[1] == b"true"})

        generated[str(path)] = item

saved_log = doc / "日志" / (label + ".txt")
saved_log.parent.mkdir(exist_ok=True)
saved_log.write_bytes(raw)
evidence = {
    "source_commit": baseline["source_commit"], "label": label,
    "exit_code": state["exit_code"], "summary": summary,
    "passed": state["exit_code"] == 0 and steps[1] == steps[2] and (checks is None or checks[1] == checks[2]),
    "steps_passed": int(steps[1]), "steps_total": int(steps[2]),
    "checks_passed": int(checks[1]) if checks else None,
    "checks_total": int(checks[2]) if checks else None,
    "commands": commands, "actual_executions": executions,
    "generated_source": list(generated.values()), "parser_options": options,
    "cached_entries": [line for line in lines if " cached" in line and not line.startswith("info(verbose):")],
    "node_summary_lines": [line for line in lines if line.startswith(("ℹ ", "✔ ", "✖ "))],
    "errors": [{"line": index + 1, "text": line} for index, line in enumerate(lines) if "error:" in line],
    "log": str(saved_log.relative_to(doc)), "log_sha256": sha(raw),
    "scope": "Selected array callback catalogs including twenty new constant predicate cases; nested Node checks and cache entries remain separate. Unresolved associations remain explicit.",
    "archive_limit": "Generated modules and executables remain in the persistent content-addressed cache with SHA identities; only parser options and full raw logs are copied into this document directory.",
}
(doc / (label + "完整证据.json")).write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: evidence[key] for key in ["label", "passed", "summary"]}))
