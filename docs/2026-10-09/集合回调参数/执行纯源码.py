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
generation = json.loads((run / (mode + "-generation.json")).read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
sha = lambda data: hashlib.sha256(data).hexdigest()
command = generation["compile_command"].copy()
tool = run / mode / "compile-catalog"

for index, argument in enumerate(command):
    if argument.startswith("-Mroot="):
        command[index] = "-Mroot=tests/collections/filter_result_kind/compile.zig"
    elif argument.startswith("-femit-bin="):
        command[index] = "-femit-bin=" + str(tool)

state = {"status": "running", "mode": mode, "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "steps": [], "programs": []}
state_path = run / (mode + "-pure.json")


def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")


def execute(command, name):
    log = run / mode / (name + ".txt")

    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    entry = {"command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())}
    state["steps"].append(entry)
    save()
    assert result.returncode == 0, log.read_text()

    return entry


save()

try:
    execute(command, "compile-catalog-tool")
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))

    for method in ["map", "filter", "every", "some"]:
        source = root / ("packages/test/tests/built_ins/list/callbacks/" + method + "/arguments/cases.zx")
        catalog = source.with_suffix(".jsonl")
        output = run / mode / (method + "-pure.zig")
        test_source = run / (method + "-cases.zig")
        binary = run / mode / (method + "-pure-test")
        expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
        assert len(expected) == 25
        execute([str(tool), str(source), str(output)], method + "-pure-generate")
        optimize = "-O" + mode
        command = [inputs["zig"], "test", optimize, "--dep", "program", "--dep", "support", "-Mroot=" + str(test_source), optimize, "-Mprogram=" + str(output), optimize, "-Msupport=" + str(root / "packages/test/tests/support/collections.zig"), "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]
        entry = execute(command, method + "-pure-execute")
        log = Path(entry["log"]).read_text()
        names = re.findall(r"\d+/25 .*?\.test\.(.+?)\.\.\.", log)
        assert names == expected, names
        assert "All 25 tests passed." in log
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True)
        state["programs"].append({"method": method, "names": names, "source": str(source), "source_sha256": sha(source.read_bytes()), "catalog": str(catalog), "catalog_sha256": sha(catalog.read_bytes()), "test_source": str(test_source), "test_source_sha256": sha(test_source.read_bytes()), "output": str(output), "output_sha256": sha(output.read_bytes()), "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "execution_log": entry["log"]})
        print(mode, method, len(names), "actual catalog tests passed", flush=True)
        save()

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
