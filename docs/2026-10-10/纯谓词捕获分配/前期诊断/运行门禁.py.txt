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
assert json.loads((run / "generator-state.json").read_text())["exit_code"] == 0
directory = run / mode
directory.mkdir()
state = {"status": "running", "mode": mode, "steps": [], "programs": []}
state_path = run / (mode + "-execution.json")
fixture = root / "packages/test/tests/collections/predicate_allocation"
expected = re.findall(r'^test "([^"\n]+)"', (fixture / "root.zig").read_text(), re.M)


def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")


def execute(command, label, allow_failure=False):
    log = directory / (label + ".txt")
    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)
    entry = {"command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())}
    state["steps"].append(entry)
    save()
    assert allow_failure or result.returncode == 0, str(log)
    return entry


save()
try:
    tool = directory / "compile-pure-predicates"
    command = ["-femit-bin=" + str(tool) if arg.startswith("-femit-bin=") else arg for arg in inputs["compile_templates"][mode]]
    execute(command, "compile-tool")
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))
    for suite in inputs["suites"]:
        method, variant = suite.split("/")
        source = fixture / (suite + ".zx")
        for route in ["source", "library"]:
            name = suite.replace("/", "-") + "-" + route
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
                if dependency not in needed:
                    needed.add(dependency)
                    pending.extend(by_name[dependency]["imports"])
            options = target / "options.zig"
            options.write_text("pub const universal = " + str(method == "every").lower() + ";\npub const captured_threshold = " + str(variant in ["scalar", "object", "scalar_source"]).lower() + ";\n")
            optimize = "-O" + mode
            binary = target / "execution_test"
            command = [inputs["zig"], "test", optimize, "--dep", "program", "--dep", "options", "-Mroot=" + str(fixture / "root.zig")]
            for module in modules:
                if module["name"] in needed:
                    command += [optimize, "--dep", "zxc_abi"]
                    for dependency in module["imports"]:
                        command += ["--dep", dependency]
                    command += ["-M" + module["name"] + "=" + str(target / (module["name"] + ".zig"))]
            command += [optimize, "-Mzxc_abi=" + str(target / "types.zig"), optimize, "-Moptions=" + str(options), "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]
            entry = execute(command, name + "-execute", allow_failure=True)
            log = Path(entry["log"]).read_text()
            names = re.findall(r"\d+/" + str(len(expected)) + r" .*?\.test\.(.+?)\.\.\.", log)
            assert names == expected, str(entry["log"])
            assert binary.is_file()
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True)
            observations = [dict(re.findall(r"(\w+)=([\w]+)", line)) for line in log.split("\n") if "ALLOCATION interface=" in line]
            assert len(observations) == 72, (name, len(observations))
            state["programs"].append({"suite": suite, "route": route, "names": names, "exit_code": entry["exit_code"], "observations": observations, "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "signature_verified": True, "files": {str(path): sha(path.read_bytes()) for path in target.iterdir() if path.is_file() and path != binary}})
            save()
            print(mode, name, "actual exit", entry["exit_code"], flush=True)
    state.update(exit_code=0, named_executions=sum(len(item["names"]) for item in state["programs"]), failing_binaries=sum(item["exit_code"] != 0 for item in state["programs"]))
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
