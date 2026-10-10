from pathlib import Path
import datetime
import json
import os
import subprocess
import sys
import time


run = Path(__file__).resolve().parent
label = sys.argv[1]
baseline = json.loads((run / "baseline.json").read_text())
command = [
    "/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/zig",
    "build", "test-array-callbacks", "-Doptimize=" + label,
    "-Dzig-archive=/Users/xiewendao/.codex/conformance/toolchains/zig-x86_64-macos-0.17.0.tar.xz",
    "--cache-dir", str(run / ("cache-" + label)),
    "-j1", "--verbose", "--summary", "all",
]
environment = dict(os.environ)
environment["ZXC_TEST_SOLVER"] = "/Users/xiewendao/.codex/conformance/toolchains/z3-5.1.0-x64-osx-13.3/bin/z3"
state = {
    "status": "running", "command": command,
    "cwd": str(Path(baseline["root"]) / "packages/test"),
    "started": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "log": str(run / (label + ".txt")), "exit_code": None,
    "solver": environment["ZXC_TEST_SOLVER"],
}
started = time.monotonic()

with open(state["log"], "wb") as output:
    process = subprocess.Popen(command, cwd=state["cwd"], env=environment, stdout=output, stderr=subprocess.STDOUT)
    state["pid"] = process.pid

    while process.poll() is None:
        state["elapsed_seconds"] = time.monotonic() - started
        (run / (label + "-state.json")).write_text(json.dumps(state, indent=2) + "\n")
        time.sleep(5)

    state.update(status="terminal", exit_code=process.returncode, finished=datetime.datetime.now(datetime.timezone.utc).isoformat(), elapsed_seconds=time.monotonic() - started)
    (run / (label + "-state.json")).write_text(json.dumps(state, indent=2) + "\n")

print(json.dumps(state))
sys.exit(process.returncode)
