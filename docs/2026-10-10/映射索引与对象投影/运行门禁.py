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
for group in ["packages", "formal_sha256"]:
    for name, identity in inputs[group].items():
        assert sha((root / name).read_bytes()) == identity, name
for group in ["tools", "external"]:
    for name, identity in inputs[group].items():
        assert sha(Path(name).read_bytes()) == identity, name
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
    assert result.returncode == 0, str(log)

    return entry


save()

try:
    command = inputs["compile_templates"][mode]
    tool = directory / "compile-map-projection"
    command = ["-femit-bin=" + str(tool) if argument.startswith("-femit-bin=") else argument for argument in command]
    execute(command, "compile-tool")
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))

    for suite, count in inputs["counts"].items():
        source = root / ("packages/test/tests/built_ins/list/callbacks/map/projection/" + suite + ".zx")
        catalog = source.with_suffix(".jsonl")
        label = suite.replace("/", "-")
        test_source = directory / (label + "-cases.zig")
        execute(["/usr/local/bin/node", "src/emit_control_tests.ts", str(catalog), str(test_source)], label + "-emit-tests")
        expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
        assert len(expected) == count

        for route in ["source", "library"]:
            name = label + "-" + route
            target = directory / name
            target.mkdir()
            execute([str(tool), str(source), route, str(target)], name + "-generate")
            modules = json.loads((target / "modules.json").read_text())
            assert json.loads((target / "native.json").read_text()) == []
            by_name = {module["name"]: module for module in modules}
            needed = set()
            pending = ["program"]

            while pending:
                dependency = pending.pop()

                if dependency in needed:
                    continue

                needed.add(dependency)
                pending.extend(by_name[dependency]["imports"])

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
            entry = execute(command, name + "-execute")
            log = Path(entry["log"]).read_text()
            names = re.findall(r"\d+/" + str(count) + r" .*?\.test\.(.+?)\.\.\.", log)
            assert names == expected and "All " + str(count) + " tests passed." in log
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True)
            state["programs"].append({"suite": suite, "route": route, "names": names, "source_sha256": sha(source.read_bytes()), "catalog_sha256": sha(catalog.read_bytes()), "test_source": str(test_source), "test_source_sha256": sha(test_source.read_bytes()), "signature_verified": True, "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "files": {str(path): sha(path.read_bytes()) for path in target.iterdir() if path.is_file() and path != binary}})
            save()
            print(mode, name, len(names), "actual tests passed", flush=True)

    state["named_executions"] = sum(len(item["names"]) for item in state["programs"])
    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
