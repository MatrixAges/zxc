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
records = list(generation["programs"])
records.append({"method": "filter_result_kind", "source_path": str(run / mode / "filter_false.zig"), "test_path": str(root / "packages/test/tests/collections/filter_result_kind/result_test.zig"), "names": ["filter singleton false predicate returns a native list container", "filter empty source returns a native list container"]})
state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "executions": []}
state_path = run / (mode + "-execution.json")

def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")

save()

try:
    for item in records:
        name = item["method"]
        binary = run / mode / ("test-" + name)
        command = [inputs["zig"], "test", "-O" + mode, "--dep", "program", "--dep", "support", "-Mroot=" + item["test_path"], "-Mprogram=" + item["source_path"], "-Msupport=" + str(root / "packages/test/tests/support/collections.zig"), "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global"), "--test-no-exec", "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]
        entry = {**item, "command": command, "binary": str(binary), "source_sha256": sha(Path(item["source_path"]).read_bytes()), "test_sha256": sha(Path(item["test_path"]).read_bytes())}
        state["executions"].append(entry)
        save()
        compile_log = run / mode / (name + "-compile.txt")

        with compile_log.open("wb") as output:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

        entry.update(compile_exit=result.returncode, compile_log=str(compile_log), compile_log_sha256=sha(compile_log.read_bytes()))
        assert result.returncode == 0, compile_log.read_text()
        signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
        entry.update(signature_exit=signature.returncode, binary_sha256=sha(binary.read_bytes()))
        assert signature.returncode == 0, signature.stderr
        log = run / mode / (name + ".txt")

        with log.open("wb") as output:
            result = subprocess.run([str(binary)], stdout=output, stderr=subprocess.STDOUT)

        entry.update(exit_code=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()))
        assert result.returncode == 0, log.read_text()
        print(mode, name, len(item["names"]), "checks passed", flush=True)
        save()

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
