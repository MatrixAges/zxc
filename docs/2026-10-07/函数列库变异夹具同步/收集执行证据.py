from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

doc = Path(__file__).resolve().parent
label, log_path, exit_text = sys.argv[1:]
raw = Path(log_path).read_bytes()
lines = raw.decode().splitlines()
summary = next(line for line in reversed(lines) if line.startswith("Build Summary:"))
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
assert steps is not None
saved = doc / "日志" / (label + ".txt")
saved.parent.mkdir(exist_ok=True)
saved.write_bytes(raw)
commands = [line.removeprefix("info(verbose): ") for line in lines if line.startswith("info(verbose): ")]
binaries = {}

for command in commands:
    args = shlex.split(command)

    if args[0] == "node" and "/library_publish/" in args[1]:
        path = Path(args[2]).resolve()
        binaries[str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()

baseline = json.loads((doc / "开始基线.json").read_text())
result = {
    "source_commit": baseline["source_commit"],
    "packages_tree": baseline["packages_tree"],
    "includes_uncommitted_test_drafts": True,
    "label": label,
    "exit_code": int(exit_text),
    "summary": summary,
    "steps_passed": int(steps.group(1)),
    "steps_total": int(steps.group(2)),
    "log": str(saved.relative_to(doc)),
    "log_sha256": hashlib.sha256(raw).hexdigest(),
    "commands": commands,
    "cli_binaries": binaries,
    "node_test_counts": [int(value) for value in re.findall(r"^ℹ tests (\d+)$", raw.decode(), re.M)],
    "node_pass_counts": [int(value) for value in re.findall(r"^ℹ pass (\d+)$", raw.decode(), re.M)],
    "node_fail_counts": [int(value) for value in re.findall(r"^ℹ fail (\d+)$", raw.decode(), re.M)],
    "cached_summary_entries": sum(" cached" in line and not line.startswith("info(verbose):") for line in lines),
}
(doc / (label + "证据.json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: result[key] for key in ["label", "exit_code", "summary", "node_test_counts"]}, ensure_ascii=False))
