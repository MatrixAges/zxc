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
generation = json.loads((run / "generator-state.json").read_text())
assert generation["status"] == "terminal" and generation["exit_code"] == 0

for name, value in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == value, name

directory = run / mode
directory.mkdir(exist_ok=True)
options = directory / "rx-options.zig"
options.write_text("pub const generated_paths: bool = true;\npub const generated_graph: bool = true;\npub const generated_rules: bool = true;\n")
command = []
external = {}

for argument in inputs["test_templates"][0]:
    if argument == "--listen=-":
        continue

    if argument == "test":
        argument = "build-exe"
    elif argument.startswith("-O"):
        argument = "-O" + mode
    elif argument.startswith("-M"):
        prefix, value = argument.split("=", 1)

        if prefix == "-Mroot":
            command += ["--dep", "library_output"]
            value = str(root / "packages/test/tests/collections/predicates/compile.zig")
        elif prefix == "-Mfrontend":
            command += ["--dep", "generated_artifact_roots", "--dep", "generated_artifact_prepare", "--dep", "generated_artifact_remap"]

        path = Path(value)
        candidate = run / "generated" / path.name

        if path.is_absolute() and candidate.is_file():
            value = str(candidate)
        elif path.is_absolute() and str(path) in inputs["external_inputs"]:
            value = inputs["external_inputs"][str(path)]["snapshot"]
        elif path.is_absolute() and prefix != "-Mroot":
            external[str(path)] = sha(path.read_bytes())

        argument = prefix + "=" + value

    command.append(argument)

command[0] = inputs["zig"]
for flag, value in [("--cache-dir", str(run / ("cache-host-" + mode))), ("--global-cache-dir", str(run / "cache-global"))]:
    command[command.index(flag) + 1] = value

optimize = "-O" + mode
command += [optimize, "--dep", "integers", "--dep", "zxc_abi=zxc_abi32", "-Mgenerated_artifact_roots=" + str(run / "generated/artifact_roots.zig")]
command += [optimize, "-Mzxc_abi32=" + str(run / "generated/artifact_roots_abi.zig")]
command += [optimize, "--dep", "integers", "--dep", "zxc_abi=zxc_abi33", "-Mgenerated_artifact_prepare=" + str(run / "generated/artifact_prepare.zig"), optimize, "-Mzxc_abi33=" + str(run / "generated/artifact_prepare_abi.zig")]
command += [optimize, "--dep", "integers", "--dep", "zxc_abi=zxc_abi34", "-Mgenerated_artifact_remap=" + str(run / "generated/artifact_remap.zig"), optimize, "-Mzxc_abi34=" + str(run / "generated/artifact_remap_abi.zig")]
command += [optimize, "-Mlibrary_output=tests/library/runtime/save.zig"]
binary = directory / "compile-callback-arguments"
command += ["-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]
state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "compile_command": command, "external": external, "options": str(options), "options_sha256": sha(options.read_bytes()), "programs": []}
state_path = run / (mode + "-generation.json")
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    log = directory / "compile.txt"
    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    state.update(compile_exit=result.returncode, compile_log=str(log), compile_log_sha256=sha(log.read_bytes()))
    assert result.returncode == 0, log.read_text()
    signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
    state["signature_exit"] = signature.returncode
    assert signature.returncode == 0, signature.stderr
    state["binary_sha256"] = sha(binary.read_bytes())

    for method in ["map", "filter", "every", "some"]:
        for route in ["source", "library"]:
            name = method + "-" + route
            target = directory / name
            target.mkdir(exist_ok=True)
            fixture = root / ("packages/test/tests/collections/callback_arguments/fixtures/" + method + ".zx")
            declaration = fixture.parent / "host.d.zx"
            command = [str(binary), str(fixture), str(declaration), route, str(target)]
            log = directory / (name + "-generation.txt")

            with log.open("wb") as output:
                result = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT)

            entry = {"name": name, "method": method, "route": route, "directory": str(target), "fixture": str(fixture), "fixture_sha256": sha(fixture.read_bytes()), "declaration": str(declaration), "declaration_sha256": sha(declaration.read_bytes()), "command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())}
            state["programs"].append(entry)
            assert result.returncode == 0, log.read_text()
            entry["files"] = {str(path): sha(path.read_bytes()) for path in target.iterdir() if path.is_file()}
            print(mode, name, "generated", flush=True)
            state_path.write_text(json.dumps(state, indent=4) + "\n")

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
