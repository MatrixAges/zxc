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
generation = json.loads((run / (mode + "-generation.json")).read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
sha = lambda data: hashlib.sha256(data).hexdigest()
command = generation["compile_command"].copy()
binary = run / mode / "compile-singleton"

for index, argument in enumerate(command):
    if argument.startswith("-Mroot="):
        command[index] = "-Mroot=tests/collections/filter_result_kind/compile.zig"
    elif argument.startswith("-femit-bin="):
        command[index] = "-femit-bin=" + str(binary)

source = root / "packages/test/tests/built_ins/list/callbacks/reduce/without_initial/cases.zx"
output = run / mode / "singleton.zig"
test_binary = run / mode / "singleton-test"
test_source = root / "packages/test/tests/collections/reduce_initial/pure_case_test.zig"
optimize = "-O" + mode
commands = [command, [str(binary), str(source), str(output)], [inputs["zig"], "test", optimize, "--dep", "program", "-Mroot=" + str(test_source), optimize, "-Mprogram=" + str(output), "-femit-bin=" + str(test_binary), "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]]
state = {"status": "running", "mode": mode, "steps": [], "source_sha256": sha(source.read_bytes()), "test_source_sha256": sha(test_source.read_bytes()), "started": datetime.datetime.now(datetime.timezone.utc).isoformat()}
state_path = run / (mode + "-pure.json")
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    for index, command in enumerate(commands):
        log = run / mode / ("singleton-" + str(index) + ".txt")

        with log.open("wb") as out:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=out, stderr=subprocess.STDOUT)

        state["steps"].append({"command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())})
        assert result.returncode == 0, log.read_text()

    for candidate in [binary, test_binary]:
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(candidate)], check=True)

    state.update(exit_code=0, compiler_binary=str(binary), compiler_sha256=sha(binary.read_bytes()), binary=str(test_binary), binary_sha256=sha(test_binary.read_bytes()), output=str(output), output_sha256=sha(output.read_bytes()))
    print(mode, "actual catalog singleton source compiled and executed", flush=True)
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
