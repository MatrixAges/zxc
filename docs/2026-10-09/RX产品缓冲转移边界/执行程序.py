from pathlib import Path
import datetime
import hashlib
import json
import subprocess
import sys


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
mode = sys.argv[1]
assert mode in ["Debug", "ReleaseSafe"]
sha = lambda data: hashlib.sha256(data).hexdigest()
generated = json.loads((run / (mode + "-generation.json")).read_text())
assert generated["status"] == "terminal" and generated["exit_code"] == 0
state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "executions": []}
state_path = run / (mode + "-execution.json")
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    for item in generated["programs"]:
        name = item["name"]
        for key in ["source", "types"]:
            assert sha(Path(item[key]).read_bytes()) == item[key + "_sha256"]

        options = run / mode / (name + "-options.zig")
        options.write_text('pub const mode: []const u8 = "' + name + '";\n')
        entries = ["root.zig", "capacity_test.zig"] if name in ["object", "nested"] else ["root.zig"]

        for entry in entries:
            label = name + ("-capacity" if entry == "capacity_test.zig" else "-runtime")
            binary = run / mode / label
            command = [
                inputs["zig"], "test", "-O" + mode, "--dep", "program", "--dep", "options", "--dep", "allocation_testing",
                "-Mroot=" + str(root / "packages/test/tests/rx/runtime/product_transfer" / entry),
                "-O" + mode, "--dep", "zxc_abi", "-Mprogram=" + item["source"],
                "-O" + mode, "-Mzxc_abi=" + item["types"],
                "-O" + mode, "-Moptions=" + str(options),
                "-O" + mode, "-Mallocation_testing=" + str(root / "packages/test/tests/support/allocation_testing.zig"),
                "--cache-dir", str(run / ("cache-runtime-" + mode)), "--global-cache-dir", str(run / "cache-global"),
                "--test-no-exec", "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"],
            ]
            record = {"label": label, "entry": entry, "command": command, "binary": str(binary), "options_sha256": sha(options.read_bytes())}
            state["executions"].append(record)
            log = run / mode / (label + "-compile.txt")
            with log.open("wb") as output:
                result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

            record.update(compile_exit=result.returncode, compile_log=str(log), compile_log_sha256=sha(log.read_bytes()))
            assert result.returncode == 0, log.read_text()
            signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
            record["signature_exit"] = signature.returncode
            assert signature.returncode == 0, signature.stderr
            record["binary_sha256"] = sha(binary.read_bytes())
            log = run / mode / (label + ".txt")
            with log.open("wb") as output:
                result = subprocess.run([str(binary)], stdout=output, stderr=subprocess.STDOUT)

            record.update(exit_code=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()))
            state_path.write_text(json.dumps(state, indent=4) + "\n")
            assert result.returncode == 0, log.read_text()
            print(mode, label, "exit", result.returncode, flush=True)

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
