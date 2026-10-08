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
mode, label = sys.argv[1:3]
root_source = sys.argv[3] if len(sys.argv) > 3 else "tests/collections/predicates/analysis_test.zig"
assert mode in ["Debug", "ReleaseSafe"]
sha = lambda data: hashlib.sha256(data).hexdigest()
state_path = run / (label + "-" + mode + "-state.json")
assert not state_path.exists()
command = []
external = {}

for argument in inputs["test_templates"][0]:
    if argument == "--listen=-":
        continue

    if argument.startswith("-O"):
        argument = "-O" + mode
    elif argument.startswith("-M"):
        prefix, value = argument.split("=", 1)

        if prefix == "-Mroot":
            command += ["--dep", "zx"]
            value = root_source
        elif prefix == "-Mfrontend":
            command += ["--dep", "generated_artifact_roots"]

        path = Path(value)
        candidate = run / "generated" / path.name

        if path.is_absolute() and candidate.is_file():
            value = str(candidate)
        elif path.is_absolute() and str(path) in inputs["external_inputs"]:
            value = inputs["external_inputs"][str(path)]["snapshot"]
        elif path.is_absolute():
            external[str(path)] = sha(path.read_bytes())

        argument = prefix + "=" + value

    command.append(argument)

command[0] = inputs["zig"]
for flag, value in [("--cache-dir", str(run / ("cache-" + mode))), ("--global-cache-dir", str(run / "cache-global"))]:
    command[command.index(flag) + 1] = value

optimize = "-O" + mode
command += [optimize, "--dep", "integers", "--dep", "zxc_abi=zxc_abi32", "-Mgenerated_artifact_roots=" + str(run / "generated/artifact_roots.zig"), optimize, "-Mzxc_abi32=" + str(run / "generated/artifact_roots_abi.zig")]
binary = run / (label + "-" + mode)
command += ["-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]
state = {"status": "running", "mode": mode, "label": label, "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "command": command, "external": external, "source_sha256": sha((root / "packages/test" / root_source).read_bytes()), "formal_sources": {name: sha((root / name).read_bytes()) for name in inputs["formal"]}}
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    log = run / (label + "-" + mode + ".txt")

    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    state.update(exit_code=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()))
    assert binary.is_file(), log.read_text()
    state["binary_sha256"] = sha(binary.read_bytes())
    signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
    state["signature_exit"] = signature.returncode
    assert signature.returncode == 0, signature.stderr
    print(log.read_text(), flush=True)
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
