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
command = json.loads((run / ("final2-" + mode + "-state.json")).read_text())["command"].copy()
directory = run / mode
directory.mkdir(exist_ok=True)
tool = directory / "compile-artifact-imports"

for index, argument in enumerate(command):
    if argument == "test":
        command[index] = "build-exe"
    elif argument.startswith("-Mroot="):
        command[index] = "-Mroot=tests/incremental/artifact/imports/compile.zig"
    elif argument.startswith("-femit-bin="):
        command[index] = "-femit-bin=" + str(tool)

state = {"status": "running", "mode": mode, "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "compile_command": command, "programs": []}
state_path = run / (mode + "-runtime.json")

def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")

save()

try:
    log = directory / "compile-tool.txt"

    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    state.update(compile_exit=result.returncode, compile_log=str(log), compile_log_sha256=sha(log.read_bytes()))
    assert result.returncode == 0, log.read_text()
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state["tool_sha256"] = sha(tool.read_bytes())
    names = re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests/incremental/artifact/imports/runtime_test.zig").read_text(), re.M)
    assert len(names) == 3

    for ordering in range(6):
        for route in ["source", "library"]:
            name = str(ordering) + "-" + route
            source = directory / (name + ".zig")
            generate = [str(tool), str(ordering), route, str(source)]
            log = directory / (name + "-generation.txt")

            with log.open("wb") as output:
                result = subprocess.run(generate, stdout=output, stderr=subprocess.STDOUT)

            entry = {"name": name, "ordering": ordering, "route": route, "generate_command": generate, "generate_exit": result.returncode, "generate_log": str(log), "generate_log_sha256": sha(log.read_bytes())}
            state["programs"].append(entry)
            save()
            assert result.returncode == 0, log.read_text()
            entry.update(source=str(source), source_sha256=sha(source.read_bytes()))
            binary = directory / ("runtime-" + name)
            optimize = "-O" + mode
            command = [inputs["zig"], "test", optimize, "--dep", "program", "--dep", "allocation_testing", "-Mroot=" + str(root / "packages/test/tests/incremental/artifact/imports/runtime_test.zig"), optimize, "-Mprogram=" + str(source), optimize, "-Mallocation_testing=" + str(root / "packages/test/tests/support/allocation_testing.zig"), "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global"), "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]
            log = directory / (name + "-execution.txt")

            with log.open("wb") as output:
                result = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT)

            entry.update(command=command, exit_code=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()), names=names)
            save()
            assert result.returncode == 0, log.read_text()
            assert "All 3 tests passed." in log.read_text()
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True)
            entry.update(binary=str(binary), binary_sha256=sha(binary.read_bytes()))
            print(mode, name, "three runtime checks passed", flush=True)
            save()

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
