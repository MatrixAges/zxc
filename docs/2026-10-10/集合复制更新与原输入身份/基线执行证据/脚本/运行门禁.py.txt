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
for name, identity in generation["generated"].items():
    assert sha(Path(name).read_bytes()) == identity
directory = run / mode
directory.mkdir(exist_ok=True)
state = {"status": "running", "mode": mode, "steps": [], "programs": []}
state_path = run / (mode + "-execution.json")


def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")


def execute(name, command):
    log = directory / (name + ".log")
    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)
    state["steps"].append({"name": name, "command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())})
    save()
    print(name, "exit", result.returncode, flush=True)
    assert result.returncode == 0, log.read_text()
    return log


save()
try:
    tool = directory / "compile-immutable-list"
    command = [argument.replace("BINARY", str(tool)) for argument in inputs["compile_templates"][mode]]
    execute("compile-tool", command)
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True, capture_output=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))
    for suite in inputs["suites"]:
        operation = suite["operation"]
        case_source = directory / (operation + "-cases.zig")
        source = root / ("packages/test/tests/" + suite["path"] + ".zx")
        catalog = source.with_suffix(".jsonl")
        execute(operation + "-emit", ["/usr/local/bin/node", str(root / "packages/test/src/emit_immutable_list.ts"), str(catalog), operation, str(case_source)])
        outputs = [directory / (operation + "-" + route + suffix) for route in ["source", "library"] for suffix in [".zig", "_abi.zig"]]
        execute(operation + "-generate", [str(tool), str(source), *map(str, outputs)])
        names = [json.loads(line)["id"] for line in catalog.read_text().splitlines() if line.strip()]
        assert len(names) == suite["count"]
        for index, route in enumerate(["source", "library"]):
            binary = directory / (operation + "-" + route + "-test")
            program, abi = outputs[index * 2:index * 2 + 2]
            command = [inputs["zig"], "test", "-O" + mode, "--dep", "support", "-Mroot=" + str(case_source), "-O" + mode, "--dep", "program", "--dep", "allocation_testing", "-Msupport=" + str(root / "packages/test/tests/collections/immutable_list/check.zig"), "-O" + mode, "--dep", "zxc_abi", "-Mprogram=" + str(program), "-O" + mode, "-Mzxc_abi=" + str(abi), "-O" + mode, "-Mallocation_testing=" + str(root / "packages/test/tests/support/allocation_testing.zig"), "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global"), "-femit-bin=" + str(binary)]
            log = execute(operation + "-" + route + "-execute", command)
            observed = re.findall(r"\d+/" + str(len(names)) + r" .*?\.test\.(.+?)\.\.\.", log.read_text())
            assert observed == names and "All " + str(len(names)) + " tests passed." in log.read_text()
            assert log.read_text().count("Immutable list allocation sweep completed") == 1
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True, capture_output=True)
            state["programs"].append({"operation": operation, "route": route, "names": observed, "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "signature_verified": True, "source_sha256": sha(source.read_bytes()), "catalog_sha256": sha(catalog.read_bytes()), "files": {str(path): sha(path.read_bytes()) for path in [program, abi, case_source, log]}})
            save()
    state.update(exit_code=0, named_executions=sum(len(item["names"]) for item in state["programs"]))
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
