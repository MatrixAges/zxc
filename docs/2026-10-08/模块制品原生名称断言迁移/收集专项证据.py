from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys


doc = Path(__file__).resolve().parent
mode = sys.argv[1]
state = json.loads((doc / "运行状态.json").read_text())
gate = next(item for item in state["gates"] if item["mode"] == mode)
assert gate["exit_code"] is not None
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
cwd = root / "packages/test"
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

raw = Path(gate["log"]).read_bytes()
lines = raw.decode().splitlines()
summary = next(line for line in reversed(lines) if line.startswith("Build Summary:"))
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
tests = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps
commands = []
executions = []
generated = {}
options = {}
pending_test = None

for index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue

    command = line.removeprefix("info(verbose): ")
    args = shlex.split(command)
    commands.append({"line": index + 1, "command": command})

    if len(args) > 1 and args[1] == "test":
        test_root = next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot="))
        option_path = (cwd / next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mparser_options="))).resolve()
        assert re.search(rb"generated_parser(?:: bool)?\s*=\s*true", option_path.read_bytes())
        pending_test = {"compile_line": index + 1, "root": test_root, "parser_options": str(option_path)}

    if len(args) > 1 and args[1].startswith("--cache-dir="):
        binary = (cwd / args[0]).resolve()
        executions.append({"line": index + 1, "path": str(binary), "sha256": sha(binary.read_bytes()), "compiled": pending_test})
        pending_test = None

    for arg in args:
        if not re.match(r"-M(?:root|generated[^=]*|parser_options)=", arg):
            continue

        path = (cwd / arg.split("=", 1)[1]).resolve()
        if not path.is_file() or path.is_relative_to(root) or str(path) in generated:
            continue

        data = path.read_bytes()
        identity = sha(data)
        saved = doc / "生成源码" / (identity + ".zig.txt")
        record = {"path": str(path), "sha256": identity}
        if arg.startswith("-Mparser_options=") or path.name in {"native_names.zig", "native_type.zig"}:
            saved.parent.mkdir(exist_ok=True)
            saved.write_bytes(data)
            record["saved"] = str(saved.relative_to(doc))
        generated[str(path)] = record

        if arg.startswith("-Mparser_options="):
            match = re.search(rb"generated_parser(?:: bool)?\s*=\s*(true|false)", data)
            assert match
            options[str(path)] = {**record, "generated_parser": match.group(1) == b"true"}

saved = doc / "日志" / (mode + ".txt")
saved.parent.mkdir(exist_ok=True)
saved.write_bytes(raw)
result = {
    "mode": mode,
    "source_commit": baseline["commit"],
    "draft": "packages/test/tests/incremental/artifact/mixed/metadata.zig",
    "input_count": len(baseline["inputs"]),
    "exit_code": gate["exit_code"],
    "summary": summary,
    "passed": gate["exit_code"] == 0 and steps[1] == steps[2] and (tests is None or tests[1] == tests[2]),
    "tests_passed": int(tests[1]) if tests else None,
    "tests_total": int(tests[2]) if tests else None,
    "commands": commands,
    "actual_native_executions": executions,
    "generated_source": list(generated.values()),
    "parser_options": list(options.values()),
    "cached_entries": [line for line in lines if " cached" in line and not line.startswith("info(verbose):")],
    "log": str(saved.relative_to(doc)),
    "log_sha256": sha(raw),
    "scope": "Complete test-module-artifacts gate; cached results are separate from actual executions.",
}
(doc / (mode + "证据.json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: result[key] for key in ["mode", "passed", "summary"]}, ensure_ascii=False))
