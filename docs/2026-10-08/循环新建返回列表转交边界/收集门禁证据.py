from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys


doc = Path(__file__).resolve().parent
label = sys.argv[1]
state = json.loads((doc / "运行状态.json").read_text())
gate = state["gates"][label]
assert gate["status"] == "terminal" and gate["exit_code"] is not None
baseline = json.loads((doc / gate.get("baseline_file", "执行输入.json")).read_text())
root = Path(baseline["root"])
cwd = root / "packages/test"
sha = lambda data: hashlib.sha256(data).hexdigest()
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["source_commit"]

for path, identity in baseline["inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path
    assert sha((Path(baseline["snapshot"]) / path).read_bytes()) == identity, path

raw = Path(gate["log"]).read_bytes()
lines = raw.decode().splitlines()
summary = next(line for line in reversed(lines) if line.startswith("Build Summary:"))
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
checks = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps
commands = []
executions = []
generated = {}
formal_options = []
pending = {}

for index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue

    command = line.removeprefix("info(verbose): ")
    args = shlex.split(command)
    commands.append({"line": index + 1, "command": command})
    is_test = len(args) > 1 and args[1] == "test"
    name = args[args.index("--name") + 1] if "--name" in args else "test"

    option_arg = next((arg for arg in args if arg.startswith("-Mparser_options=")), None)
    formal = is_test or name in {"compile-loop-call-origins", "compile-loop-initial-ownership", "zxc"}
    option_path = (cwd / option_arg.split("=", 1)[1]).resolve() if option_arg else None

    if formal and option_path:
        assert re.search(rb"generated_parser(?:: bool)?\s*=\s*true", option_path.read_bytes())
        formal_options.append({"test": name, "path": str(option_path), "sha256": sha(option_path.read_bytes()), "generated_parser": True})

    if is_test:
        test_root = next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot="))
        pending[name] = {"compile_line": index + 1, "name": name, "root": test_root, "parser_options": str(option_path) if option_path else None}

    if len(args) > 1 and args[1].startswith("--cache-dir="):
        binary = (cwd / args[0]).resolve()
        executions.append({"line": index + 1, "path": str(binary), "sha256": sha(binary.read_bytes()), "compiled": pending.pop(binary.name, None)})

    for arg in args:
        if not re.match(r"-M(?:root|program|zxc_abi|generated[^=]*|parser_options|options)=", arg):
            continue

        path = (cwd / arg.split("=", 1)[1]).resolve()
        if not path.is_file() or path.is_relative_to(root) or str(path) in generated:
            continue

        data = path.read_bytes()
        identity = sha(data)
        record = {"path": str(path), "sha256": identity}
        if arg.startswith("-Mparser_options=") or (is_test and name.startswith("loop-call-") and arg.startswith(("-Mprogram=", "-Mzxc_abi=", "-Moptions="))):
            saved = doc / "生成源码" / (identity + ".zig.txt")
            saved.parent.mkdir(exist_ok=True)
            saved.write_bytes(data)
            record["saved"] = str(saved.relative_to(doc))
        generated[str(path)] = record

saved_log = doc / "日志" / (label + ".txt")
saved_log.parent.mkdir(exist_ok=True)
saved_log.write_bytes(raw)
result = {
    "label": label,
    "source_commit": baseline["source_commit"],
    "input_count": len(baseline["inputs"]),
    "exit_code": gate["exit_code"],
    "summary": summary,
    "passed": gate["exit_code"] == 0 and steps[1] == steps[2] and (checks is None or checks[1] == checks[2]),
    "tests_passed": int(checks[1]) if checks else None,
    "tests_total": int(checks[2]) if checks else None,
    "commands": commands,
    "actual_executions": executions,
    "generated_source": list(generated.values()),
    "formal_parser_options": formal_options,
    "cached_entries": [line for line in lines if " cached" in line and not line.startswith("info(verbose):")],
    "native_summaries": [line for line in lines if "run test" in line and re.search(r"pass|cached|failure", line)],
    "errors": [{"line": index + 1, "text": line} for index, line in enumerate(lines) if line.startswith("error:")],
    "log": str(saved_log.relative_to(doc)),
    "log_sha256": sha(raw),
    "scope": "loop-call-origins plus complete loop-initial-ownership and iterate-buffer; actual executions and cache entries remain separate.",
}
(doc / (label + "证据.json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: result[key] for key in ["label", "passed", "summary"]}, ensure_ascii=False))
