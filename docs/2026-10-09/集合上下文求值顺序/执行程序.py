from pathlib import Path
import datetime
import hashlib
import json
import re
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
owner = root / "packages/test/tests/collections/context_effects"
names = re.findall(r'test "([^"\n]+)"', (owner / "root.zig").read_text())
assert len(names) == 8
state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "executions": []}
state_path = run / (mode + "-execution.json")

def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")

save()

try:
    for program in generation["programs"]:
        name = program["name"]
        options = run / mode / (name + "-options.zig")
        options.write_text('pub const method: []const u8 = "' + program["method"] + '";\npub const used: bool = ' + str(program["used"]).lower() + ';\n')
        binary = run / mode / ("test-" + name)
        optimize = "-O" + mode
        command = [inputs["zig"], "test", optimize, "--dep", "program", "--dep", "host", "--dep", "options", "-Mroot=" + str(owner / "root.zig"), optimize, "--dep", "host", "--dep", "zxc_abi", "-Mprogram=" + program["source"], optimize, "-Mzxc_abi=" + program["types"], optimize, "-Mhost=" + str(owner / "host.zig"), optimize, "-Moptions=" + str(options), "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global"), "--test-no-exec", "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]
        entry = {"name": name, "names": names, "command": command, "options": str(options), "options_sha256": sha(options.read_bytes()), "binary": str(binary)}
        state["executions"].append(entry)
        save()
        compile_log = run / mode / (name + "-runtime-compile.txt")

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
        print(mode, name, "eight checks passed", flush=True)
        save()

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
