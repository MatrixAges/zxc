from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys

mode, log_path, exit_text = sys.argv[1:]
exit_code = int(exit_text)
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
root = Path(baseline["worktree"])
raw = Path(log_path).read_bytes()
lines = raw.decode().splitlines()
summary = next((line for line in reversed(lines) if line.startswith("Build Summary:")), None)
assert summary is not None, "actual terminal summary required"
steps = re.search(r"(\d+)/(\d+) steps succeeded", summary)
tests = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps and tests
assert exit_code == 0 and steps.group(1) == steps.group(2) and tests.group(1) == tests.group(2), summary
assert not any(line.startswith("error:") or line.startswith("failed command:") for line in lines)
process = re.search(r"Process application entry: (\d+) checks passed", raw.decode())
assert process is not None
assert "ℹ tests 5" in raw.decode() and "ℹ pass 5" in raw.decode()

for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

commands = []
binaries = {}
cli = {}
artifacts = {}

for index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue
    text = line.removeprefix("info(verbose): ")
    args = shlex.split(text)
    commands.append({"line": index + 1, "command": text})
    if len(args) > 1 and args[1].startswith("--cache-dir="):
        path = Path(args[0])
        if path.is_file():
            binaries[str(path)] = {"path": str(path), "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
    for arg in args:
        if arg.endswith("/zxc") and Path(arg).is_file():
            cli[arg] = {"path": arg, "sha256": hashlib.sha256(Path(arg).read_bytes()).hexdigest()}
        if not (arg.startswith("-Mprogram=") or arg.startswith("-Moptions=")):
            continue
        path = Path(arg.split("=", 1)[1])
        if not path.is_absolute():
            path = root / "packages/test" / path
        data = path.read_bytes()
        sha = hashlib.sha256(data).hexdigest()
        saved = doc / "生成物" / f"{sha}.zig.txt"
        saved.parent.mkdir(exist_ok=True)
        saved.write_bytes(data)
        artifacts[str(path)] = {"executed_source": str(path), "sha256": sha, "saved": str(saved.relative_to(doc))}

saved = doc / "日志" / f"{mode}-完整门禁.txt"
saved.parent.mkdir(exist_ok=True)
saved.write_bytes(raw)
evidence = {"mode": mode, "source_commit": baseline["source_commit"], "packages_tree": baseline["packages_tree"],
            "exit_code": exit_code, "summary": summary, "zig_tests": int(tests.group(2)),
            "process_checks": int(process.group(1)), "node_iterate_test_blocks": 5,
            "log": str(saved.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(),
            "commands": commands, "test_binaries": list(binaries.values()), "cli_binaries": list(cli.values()),
            "artifacts": list(artifacts.values()),
            "cached_summary_entries": sum(" cached" in line and not line.startswith("info(verbose):") for line in lines),
            "scope": "complete original test-iterate and test-process-entry steps, without changed fixtures; Zig/Node/Process counts reported separately; not the entire root test"}
(doc / f"{mode}执行证据.json").write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: evidence[key] for key in ["mode", "exit_code", "summary", "process_checks", "node_iterate_test_blocks", "cached_summary_entries"]}, ensure_ascii=False))
