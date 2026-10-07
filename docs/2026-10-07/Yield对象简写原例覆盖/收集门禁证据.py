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
exit_code = int(sys.argv[4])
doc = Path(__file__).resolve().parent
raw = log.read_bytes()
lines = raw.decode().splitlines()
summary = next((line for line in reversed(lines) if line.startswith("Build Summary:")), None)
assert summary is not None, "terminal build summary is required"
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
tests = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps is not None
errors = [{"line": index + 1, "text": line} for index, line in enumerate(lines) if line.startswith("error:") or line.startswith("failed command:")]
commands = []
binaries = {}
for index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue
    command = line.removeprefix("info(verbose): ")
    try:
        args = shlex.split(command)
    except ValueError:
        commands.append({"line": index + 1, "command": command, "parsed": False})
        continue
    commands.append({"line": index + 1, "command": command, "parsed": True})
    if len(args) > 1 and args[1].startswith("--cache-dir="):
        binary = (root / args[0]).resolve()
        assert binary.is_file(), str(binary)
        binaries[str(binary)] = {"path": str(binary), "sha256": hashlib.sha256(binary.read_bytes()).hexdigest()}

passed = exit_code == 0 and steps.group(1) == steps.group(2) and (tests is None or tests.group(1) == tests.group(2)) and not errors
if exit_code == 0:
    assert passed, summary
saved = doc / "日志" / f"{label}.txt"
saved.parent.mkdir(exist_ok=True)
saved.write_bytes(raw)
artifacts = []
for item in commands:
    if not item["parsed"]:
        continue
    for arg in shlex.split(item["command"]):
        if not arg.startswith(("-Mroot=", "-Mprogram=", "-Mzxc_abi=", "-Moptions=", "-Mparser_options=")):
            continue
        path = (root / arg.split("=", 1)[1]).resolve()
        if not path.is_file() or path.is_relative_to(root):
            continue
        data = path.read_bytes()
        sha = hashlib.sha256(data).hexdigest()
        saved_source = doc / "生成物" / (sha + ".zig.txt")
        saved_source.parent.mkdir(exist_ok=True)
        saved_source.write_bytes(data)
        artifacts.append({"executed_source": str(path), "saved": str(saved_source.relative_to(doc)), "sha256": sha})

artifacts = list({(item["executed_source"], item["sha256"]): item for item in artifacts}.values())

formal_options = []
for item in commands:
    if not item["parsed"]:
        continue
    args = shlex.split(item["command"])
    if "--name" not in args or args[args.index("--name") + 1] not in ["zxc", "compile-object-shorthand"]:
        continue
    option = next(arg for arg in args if arg.startswith("-Mparser_options="))
    path = Path(option.split("=", 1)[1])
    data = path.read_bytes()
    assert b"generated_parser: bool = true" in data or b"generated_parser = true" in data
    formal_options.append({"compiler_name": args[args.index("--name") + 1], "path": str(path), "sha256": hashlib.sha256(data).hexdigest(), "generated_parser": True})

result = {"includes_uncommitted_test_drafts": True, "artifacts": artifacts, "label": label, "source_commit": subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip(), "packages_tree": subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD:packages"], text=True).strip(), "exit_code": exit_code, "passed": passed, "summary": summary, "steps_passed": int(steps.group(1)), "steps_total": int(steps.group(2)), "tests_passed": int(tests.group(1)) if tests else None, "tests_total": int(tests.group(2)) if tests else None, "errors": errors, "log": str(saved.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(), "commands": commands, "logged_zig_test_binaries": list(binaries.values()), "cached_summary_entries": sum(" cached" in line and not line.startswith("info(verbose):") for line in lines), "formal_parser_options": formal_options, "scope": "full original object construction source gate or object shorthand source and decoded library gate; exact execution input identity is archived separately"}
(doc / f"{label}证据.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: result[key] for key in ["label", "exit_code", "passed", "summary", "cached_summary_entries"]}, ensure_ascii=False))
