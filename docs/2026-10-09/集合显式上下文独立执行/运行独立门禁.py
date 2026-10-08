from pathlib import Path
import datetime
import hashlib
import json
import subprocess
import sys


doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
root = Path(baseline["root"])
run = Path(baseline["run"])
mode = sys.argv[1]
assert mode in ["Debug", "ReleaseSafe"]
zig = "/Users/xiewendao/.codex/conformance/diagnostics/zig-signed-probe-20261009/zig"
entitlements = "/Users/xiewendao/.codex/conformance/diagnostics/zig-signed-probe-20261009/empty.plist"
sha = lambda data: hashlib.sha256(data).hexdigest()
records = json.loads((run / "programs.json").read_text())
state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "executions": []}
(run / (mode + "-state.json")).write_text(json.dumps(state, indent=4) + "\n")

for item in records:
    name = item["method"]
    assert sha(Path(item["source_path"]).read_bytes()) == item["source_sha256"]
    assert sha(Path(item["test_path"]).read_bytes()) == item["test_sha256"]
    binary = run / (name + "-" + mode)
    command = [
        zig, "test", "-O" + mode, "--dep", "program", "--dep", "support",
        "-Mroot=" + item["test_path"], "-Mprogram=" + item["source_path"],
        "-Msupport=" + str(root / "packages/test/tests/support/collections.zig"),
        "--cache-dir", str(run / ("cache-" + mode)),
        "--global-cache-dir", str(run / "cache-global"),
        "--test-no-exec", "-femit-bin=" + str(binary), "--entitlements", entitlements,
    ]
    entry = {"method": name, "command": command, "binary": str(binary)}
    compile_log = run / (name + "-" + mode + "-compile.txt")

    with compile_log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    entry["compile_exit"] = result.returncode
    assert result.returncode == 0, compile_log.read_text()
    signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
    entry["signature_exit"] = signature.returncode
    assert signature.returncode == 0, signature.stderr
    entry["binary_sha256"] = sha(binary.read_bytes())
    log = run / (name + "-" + mode + ".txt")

    with log.open("wb") as output:
        result = subprocess.run([str(binary)], stdout=output, stderr=subprocess.STDOUT)

    entry.update(exit_code=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()))
    state["executions"].append(entry)
    (run / (mode + "-state.json")).write_text(json.dumps(state, indent=4) + "\n")
    assert result.returncode == 0, log.read_text()
    print(mode, name, "exit", result.returncode, flush=True)

state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat(), exit_code=0)
(run / (mode + "-state.json")).write_text(json.dumps(state, indent=4) + "\n")
print(mode, "terminal", "four actual binaries")
