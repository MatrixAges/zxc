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
generation = json.loads((run / (mode + "-generation.json")).read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
owner = root / "packages/test/tests/collections/context_borrow"
state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "executions": []}
state_path = run / (mode + "-execution.json")

def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")

save()

try:
    for program in generation["programs"]:
        directory = Path(program["directory"])
        roots = ["root", "capacity_test"] if program["method"] in ["every", "some"] else ["root"]

        for root_name in roots:
            runtime = directory / "runtime" / root_name
            log = run / mode / (program["name"] + "-" + root_name + "-runtime.txt")
            command = ["/usr/local/bin/node", str(owner / "run_test.ts"), inputs["zig"], str(directory), str(owner / (root_name + ".zig")), mode, str(owner / "host.zig"), str(root / "packages/test/tests/collections/context_effects/oracle.zig"), program["method"], program["kind"], "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]
            entry = {"name": program["name"], "root_name": root_name, "directory": str(runtime), "command": command, "log": str(log)}
            state["executions"].append(entry)
            save()

            with log.open("wb") as output:
                result = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT)

            entry.update(exit_code=result.returncode, log_sha256=sha(log.read_bytes()))
            if (runtime / "execution.json").is_file():
                entry["execution"] = json.loads((runtime / "execution.json").read_text())

            assert result.returncode == 0, log.read_text()
            binary = Path(entry["execution"]["binary"])
            signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
            entry.update(signature_exit=signature.returncode, binary_sha256=sha(binary.read_bytes()), options_sha256=sha((runtime / "options.zig").read_bytes()))
            assert signature.returncode == 0, signature.stderr
            assert entry["execution"]["binary_sha256"] == entry["binary_sha256"]
            print(mode, program["name"], root_name, len(entry["execution"]["names"]), "checks passed", flush=True)
            save()

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
