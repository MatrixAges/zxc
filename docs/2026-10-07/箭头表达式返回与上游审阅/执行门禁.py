import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


doc = Path(__file__).resolve().parent
mode = sys.argv[1]
label = sys.argv[2] if len(sys.argv) > 2 else mode
manifest = json.loads((doc / "输入清单.json").read_text())
argv = ["zig", "build", "test-arrow-bodies", "-Doptimize=" + mode, "-Dzig-archive=/tmp/zig-x86_64-macos-0.17.0.tar.xz", "--cache-dir", "/tmp/zxc-detached-reader-" + mode.lower() + "-" + manifest["source"][:8], "--summary", "all", "-j2"]
started = datetime.now(timezone.utc).isoformat()
with (doc / (label + "原始日志.txt")).open("w") as stream:
    result = subprocess.run(argv, cwd=manifest["cwd"], stdout=stream, stderr=subprocess.STDOUT)
record = {"argv": argv, "cwd": manifest["cwd"], "started": started, "finished": datetime.now(timezone.utc).isoformat(), "exit_code": result.returncode, "source": manifest["source"], "source_tree": manifest["source_tree"], "inputs": manifest["inputs"]}
(doc / (label + "执行结果.json")).write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"label": label, "exit_code": result.returncode}))
sys.exit(result.returncode)
