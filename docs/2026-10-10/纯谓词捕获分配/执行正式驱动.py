from pathlib import Path

import datetime
import hashlib
import json
import subprocess


doc = Path(__file__).resolve().parent
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
sha = lambda data: hashlib.sha256(data).hexdigest()
for group in ["packages", "formal_sha256"]:
    for name, identity in inputs[group].items():
        assert sha((root / name).read_bytes()) == identity, name
for group in ["tools", "external"]:
    for name, identity in inputs[group].items():
        assert sha(Path(name).read_bytes()) == identity, name
state = {"status": "running", "programs": []}
state_path = run / "registered-execution.json"
fixture = root / "packages/test/tests/collections/predicate_allocation"


def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")


save()
try:
    for mode in ["Debug", "ReleaseSafe"]:
        measured = json.loads((run / (mode + "-execution.json")).read_text())
        assert measured["status"] == "terminal" and measured["exit_code"] == 0
        for item in measured["programs"]:
            method, variant = item["suite"].split("/")
            directory = Path(item["binary"]).parent
            command = ["/usr/local/bin/node", str(fixture / "run_test.ts"), inputs["zig"], str(directory), str(fixture / "root.zig"), mode, str(root / "packages/test/tests/support/allocation_testing.zig"), method, variant, "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-registered-" + mode)), "--global-cache-dir", str(run / "cache-global")]
            log = directory / "registered-runner.log"
            with log.open("wb") as output:
                result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)
            assert result.returncode == 0, str(log)
            record_path = directory / "runtime/root/execution.json"
            record = json.loads(record_path.read_text())
            assert record["status"] == 0 and record["signal"] is None and record["names"] == item["names"]
            assert sha(Path(record["binary"]).read_bytes()) == record["binary_sha256"]
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", record["binary"]], check=True, capture_output=True)
            saved = {"mode": mode, "suite": item["suite"], "route": item["route"], "command": command, "exit_code": result.returncode, "record": str(record_path), "binary": record["binary"], "binary_sha256": record["binary_sha256"], "signature_verified": True, "files": {str(path): sha(path.read_bytes()) for path in [log, record_path, record_path.with_suffix(".log"), record_path.parent / "options.zig"]}}
            state["programs"].append(saved)
            save()
            print(mode, item["suite"], item["route"], "formal runner: five checks passed", flush=True)
    state.update(exit_code=0, named_executions=240)
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
