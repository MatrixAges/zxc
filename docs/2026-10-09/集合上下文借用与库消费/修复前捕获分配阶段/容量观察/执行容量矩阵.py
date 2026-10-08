from pathlib import Path
import datetime
import hashlib
import json
import subprocess
import sys


doc = Path(__file__).resolve().parent
inputs = json.loads((doc.parent / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
mode = sys.argv[1]
assert mode in ["Debug", "ReleaseSafe"]
sha = lambda data: hashlib.sha256(data).hexdigest()
directory = run / "capacity" / mode
directory.mkdir(parents=True, exist_ok=True)
state = {"status": "running", "mode": mode, "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "source_sha256": sha((doc / "predicate_capacity.zig").read_bytes()), "executions": []}
state_path = directory / "state.json"
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    for kind in ["list", "object", "nested"]:
        for method in ["every", "some"]:
            for route in ["source", "library"]:
                name = kind + "-" + method + "-" + route
                source = run / mode / name
                record = json.loads((source / "execution.json").read_text())
                command = [inputs["zig"], *record["argv"]]
                index = next(index for index, value in enumerate(command) if value.startswith("-Mroot="))
                command[index] = "-Mroot=" + str(doc / "predicate_capacity.zig")
                command[index:index] = ["--dep", "fixture"]
                binary = directory / name
                command = [value if not value.startswith("-femit-bin=") else "-femit-bin=" + str(binary) for value in command]
                command += ["-O" + mode, "--dep", "program", "--dep", "options", "-Mfixture=" + str(root / "packages/test/tests/collections/context_borrow/fixture.zig")]
                log = directory / (name + ".txt")

                with log.open("wb") as output:
                    result = subprocess.run(command, cwd=source, stdout=output, stderr=subprocess.STDOUT)

                signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
                assert signature.returncode == 0, signature.stderr
                assert result.returncode in [0, 1], log.read_text()
                assert b"count=4096 capacity=" in log.read_bytes(), log.read_text()
                entry = {"name": name, "command": command, "exit_code": result.returncode, "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "signature_exit": signature.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())}
                state["executions"].append(entry)
                state_path.write_text(json.dumps(state, indent=4) + "\n")
                print(mode, name, "capacity check exit", result.returncode, flush=True)

    state["exit_code"] = 0 if all(item["exit_code"] == 0 for item in state["executions"]) else 1
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
