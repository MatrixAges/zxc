from pathlib import Path

import datetime
import hashlib
import json
import re
import subprocess
import sys

doc = Path(__file__).resolve().parent
main = doc.parents[2]
inputs = json.loads((doc / "执行输入.json").read_text())
root = Path(inputs["root"])
run = Path(inputs["run"])
mode = sys.argv[1]
assert mode in ["Debug", "ReleaseSafe"]
sha = lambda data: hashlib.sha256(data).hexdigest()
generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0
directory = run / mode
directory.mkdir()
state = {"status": "running", "mode": mode, "steps": [], "programs": []}
state_path = run / (mode + "-execution.json")


def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")


def execute(command, label):
    log = directory / (label + ".txt")

    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    entry = {"command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())}
    state["steps"].append(entry)
    save()
    assert result.returncode == 0, log.read_text()

    return entry


save()

try:
    command = [argument.replace(inputs["template_root"], str(root)).replace(inputs["template_run"], str(run)) for argument in inputs["compile_templates"][mode]]
    tool = directory / "compile-observers"
    command = ["-femit-bin=" + str(tool) if argument.startswith("-femit-bin=") else argument for argument in command]
    execute(command, "compile-tool")
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))
    source = root / "packages/test/tests/built_ins/list/callbacks/reduce/observers/cases.zx"
    catalog = source.with_suffix(".jsonl")
    test_source = run / "cases.zig"
    expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
    assert len(expected) == 66

    for route in ["source", "library"]:
        target = directory / route
        target.mkdir()
        execute([str(tool), str(source), route, str(target)], route + "-generate")
        modules = json.loads((target / "modules.json").read_text())
        assert json.loads((target / "native.json").read_text()) == []
        by_name = {module["name"]: module for module in modules}
        needed = set()
        pending = ["program"]

        while pending:
            name = pending.pop()

            if name in needed:
                continue

            needed.add(name)
            pending.extend(by_name[name]["imports"])

        optimize = "-O" + mode
        binary = target / "execution_test"
        command = [inputs["zig"], "test", optimize, "--dep", "program", "--dep", "support", "-Mroot=" + str(test_source)]

        for module in modules:
            if module["name"] not in needed:
                continue

            command += [optimize, "--dep", "zxc_abi"]

            for dependency in module["imports"]:
                command += ["--dep", dependency]

            command += ["-M" + module["name"] + "=" + str(target / (module["name"] + ".zig"))]

        command += [optimize, "-Mzxc_abi=" + str(target / "types.zig"), optimize, "-Msupport=" + str(root / "packages/test/tests/support/collections.zig"), "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]
        entry = execute(command, route + "-execute")
        log = Path(entry["log"]).read_text()
        names = re.findall(r"\d+/66 .*?\.test\.(.+?)\.\.\.", log)
        assert names == expected and "All 66 tests passed." in log
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True)
        state["programs"].append({"route": route, "names": names, "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "files": {str(path): sha(path.read_bytes()) for path in target.iterdir() if path.is_file() and path != binary}})
        save()
        print(mode, route, len(names), "actual tests passed", flush=True)

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
