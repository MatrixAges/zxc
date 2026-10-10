from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys

doc = Path(__file__).resolve().parent
label = sys.argv[1]
exit_code = int(sys.argv[2])
baseline = json.loads((doc / "开始基线.json").read_text())
state = json.loads((doc / "运行状态.json").read_text())
root = Path(baseline["execution_root"])
cwd = root / "packages/test"
sha = lambda data: hashlib.sha256(data).hexdigest()

assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip() == baseline["source_commit"]
assert state["gates"][label]["status"] == "terminal"
assert state["gates"][label]["exit_code"] == exit_code

for item in baseline["inputs"]:
    assert sha((root / item["path"]).read_bytes()) == item["sha256"], item["path"]
    assert sha((Path(baseline["source_snapshot"]) / item["path"]).read_bytes()) == item["sha256"], item["path"]

raw = Path(state["gates"][label]["raw_log"]).read_bytes()
lines = raw.decode().splitlines()
summary = next(line for line in reversed(lines) if line.startswith("Build Summary:"))
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
tests = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps is not None
commands = []
binaries = {}
generated = {}
options = {}
links = []
pending = {}

for line_index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue

    command = line.removeprefix("info(verbose): ")
    args = shlex.split(command)
    commands.append({"line": line_index + 1, "command": command})

    if len(args) > 1 and args[1] == "test" and "--name" in args:
        name = args[args.index("--name") + 1]
        pending[name] = {"compile_line": line_index + 1, "root": next(arg.split("=", 1)[1] for arg in args if arg.startswith("-Mroot="))}

    if len(args) > 1 and args[1].startswith("--cache-dir="):
        binary = (cwd / args[0]).resolve()
        identity = binaries.get(str(binary))
        if identity is None:
            identity = {"path": str(binary), "sha256": sha(binary.read_bytes())}
            binaries[str(binary)] = identity
        compiled = pending.pop(binary.name, None)
        links.append({"run_line": line_index + 1, "binary": identity, "compiled": compiled})

    for arg in args:
        if not re.match(r"-M(?:root|program|generated[^=]*|parser_options|options|zxc_abi)=", arg):
            continue

        path = (cwd / arg.split("=", 1)[1]).resolve()
        if not path.is_file() or path.is_relative_to(root):
            continue
        if str(path) in generated:
            continue

        data = path.read_bytes()
        identity = {"path": str(path), "sha256": sha(data)}
        generated[str(path)] = identity

        if arg.startswith("-Mparser_options="):
            match = re.search(rb"generated_parser(?:: bool)?\s*=\s*(true|false)", data)
            assert match is not None
            saved = doc / "解析选项" / (identity["sha256"] + ".zig.txt")
            saved.parent.mkdir(exist_ok=True)
            saved.write_bytes(data)
            options[str(path)] = {**identity, "generated_parser": match.group(1) == b"true", "saved": str(saved.relative_to(doc))}

saved_log = doc / "日志" / (label + ".txt")
saved_log.parent.mkdir(exist_ok=True)
saved_log.write_bytes(raw)
native_summaries = [line for line in lines if re.search(r"run test.*(?:pass|cached|failure)", line)]
markers = [{"line": index + 1, "text": line} for index, line in enumerate(lines) if line.startswith("failed command:")]
errors = [{"line": index + 1, "text": line} for index, line in enumerate(lines) if line.startswith("error:")]
passed = exit_code == 0 and steps.group(1) == steps.group(2) and (tests is None or tests.group(1) == tests.group(2))

result = {
    "label": label,
    "source_commit": baseline["source_commit"],
    "packages_tree": baseline["packages_tree"],
    "includes_uncommitted_test_drafts": False,
    "input_count": len(baseline["inputs"]),
    "exit_code": exit_code,
    "passed": passed,
    "summary": summary,
    "steps_passed": int(steps.group(1)),
    "steps_total": int(steps.group(2)),
    "tests_passed": int(tests.group(1)) if tests else None,
    "tests_total": int(tests.group(2)) if tests else None,
    "log": str(saved_log.relative_to(doc)),
    "log_sha256": sha(raw),
    "commands": commands,
    "logged_native_test_binaries": list(binaries.values()),
    "native_execution_links": links,
    "generated_source_identities": list(generated.values()),
    "parser_options": list(options.values()),
    "native_summary_entries": native_summaries,
    "cached_summary_entries": sum(" cached" in line and not line.startswith("info(verbose):") for line in lines),
    "errors": errors,
    "command_markers": markers,
    "scope": "complete packages/test zig build test at the frozen commit; nested Node/CLI checks remain separate from the Zig summary",
    "archive_limit": "generated modules and native executables retain their content-addressed cache paths and SHA identities; only parser options are copied here, not all generated modules or binaries",
}

(doc / (label + "完整证据.json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: result[key] for key in ["label", "exit_code", "passed", "summary"]}, ensure_ascii=False))
