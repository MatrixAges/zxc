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

for name, expected in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == expected, name

for name, expected in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == expected, name

state = {"status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "steps": []}
(run / "generator-state.json").write_text(json.dumps(state, indent=4) + "\n")

try:
    for name in ["generator_compile", "generator_run"]:
        log = run / (name + ".txt")
        command = inputs[name]

        with log.open("wb") as output:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

        state["steps"].append({"name": name, "command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())})
        assert result.returncode == 0, log.read_text()

        if name == "generator_compile":
            signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(run / "generate-parser")], capture_output=True, text=True)

            assert signature.returncode == 0, signature.stderr

            state["generator_binary_sha256"] = sha((run / "generate-parser").read_bytes())

        print(name, "exit", result.returncode, flush=True)

    state["generated"] = {str(path): sha(path.read_bytes()) for path in (run / "generated").glob("*.zig")}

    assert len(state["generated"]) == 85

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))

    raise

finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())

    (run / "generator-state.json").write_text(json.dumps(state, indent=4) + "\n")
