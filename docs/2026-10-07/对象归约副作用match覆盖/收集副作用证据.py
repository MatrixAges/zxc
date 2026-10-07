from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

root = Path(__file__).resolve().parent
mode = sys.argv[1]
evidence = json.loads((root / (mode + "证据.json")).read_text())
children = []

for item in evidence["commands"]:
    args = shlex.split(item["command"])

    if len(args) < 9 or not args[1].endswith("collections/object_reduce/effects/run_test.ts"):
        continue

    directory = Path(args[3])
    route = directory.name

    assert route in ["source", "library"]

    execution = json.loads((directory / "execution.json").read_text())
    binary = Path(execution["binary"])
    raw = (directory / "execution.log").read_bytes()
    summary = re.search(rb"All (\d+) tests passed\.", raw)

    assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
    assert summary is not None
    assert execution["optimize"] == mode.lower().removeprefix("release")
    assert summary.group(1) == b"18"

    saved = root / "执行物" / (mode + "-" + route)
    saved.mkdir(parents=True, exist_ok=True)
    artifacts = []

    for path in sorted(directory.iterdir()):
        if not path.is_file() or path.suffix not in [".zig", ".json", ".log"]:
            continue

        data = path.read_bytes()
        target = saved / (path.name + ".txt")
        target.write_bytes(data)
        artifacts.append({"original": str(path), "saved": str(target.relative_to(root)), "sha256": hashlib.sha256(data).hexdigest()})

    children.append({"route": route, "mode": mode, "checks": int(summary.group(1)), "binary": str(binary), "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "execution": execution, "artifacts": artifacts})

assert len(children) == 2
assert {item["route"] for item in children} == {"source", "library"}

(root / (mode + "副作用证据.json")).write_text(json.dumps(children, ensure_ascii=False, indent=2) + "\n")
print("PASS:", mode, "both actual effectful consumers, 36 native checks")
