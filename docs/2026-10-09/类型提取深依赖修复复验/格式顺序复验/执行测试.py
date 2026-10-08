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

assert mode in ["Audit", "Debug", "ReleaseSafe"]

sha = lambda data: hashlib.sha256(data).hexdigest()
generated = json.loads((run / "generator-state.json").read_text())

assert generated["status"] == "terminal" and generated["exit_code"] == 0

for name, expected in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == expected, name

for name, expected in inputs["tools"].items():
    assert sha(Path(name).read_bytes()) == expected, name

for name, expected in generated["generated"].items():
    assert sha(Path(name).read_bytes()) == expected, name

state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "executions": [], "external": {}}

state_path = run / (mode + "-state.json")
state_path.write_text(json.dumps(state, indent=4) + "\n")

templates = inputs["test_templates"] if mode != "Audit" else [inputs["test_templates"][-1]]

try:
    for template in templates:
        command = []
        original_root = next(item for item in template if item.startswith("-Mroot="))
        name = original_root.split("artifact/", 1)[1].removesuffix("_test.zig").replace("/", "-") if mode != "Audit" else "source-audit"
        binary = run / (name + "-" + mode)

        for argument in template:
            if argument == "--listen=-":
                continue

            if argument.startswith("-O"):
                argument = "-O" + ("Debug" if mode == "Audit" else mode)

            if argument.startswith("-M"):
                prefix, value = argument.split("=", 1)

                path = Path(value)

                if prefix == "-Mfrontend":
                    command += ["--dep", "generated_artifact_roots"]

                if mode == "Audit" and prefix == "-Mroot":
                    value = str(doc / "生成源核验.zig")

                elif path.is_absolute():
                    candidate = run / "generated" / path.name

                    if candidate.is_file():
                        value = str(candidate)

                    elif str(path) in inputs["external_inputs"]:
                        value = inputs["external_inputs"][str(path)]["snapshot"]
                    else:
                        value = str(path)

                        state["external"][value] = sha(path.read_bytes())

                argument = prefix + "=" + value

            command.append(argument)

        command[0] = inputs["zig"]

        for flag, value in [("--cache-dir", str(run / ("cache-" + mode))), ("--global-cache-dir", str(run / "cache-global"))]:
            command[command.index(flag) + 1] = value

        optimize = "-O" + ("Debug" if mode == "Audit" else mode)
        command += [optimize, "--dep", "integers", "--dep", "zxc_abi=zxc_abi32", "-Mgenerated_artifact_roots=" + str(run / "generated/artifact_roots.zig")]
        command += [optimize, "-Mzxc_abi32=" + str(run / "generated/artifact_roots_abi.zig")]

        if mode == "Audit":
            command.insert(command.index(original_root) if original_root in command else next(i for i, item in enumerate(command) if item.startswith("-Mroot=")), "frontier_source")

            index = command.index("frontier_source")

            command.insert(index, "--dep")
            command += [optimize, "--dep", "compiler", "-Mfrontier_source=" + str(root / "packages/test/tests/incremental/artifact/frontier/source.zig")]

        command += ["--test-no-exec", "-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]
        entry = {"name": name, "command": command, "binary": str(binary)}
        compile_log = run / (name + "-" + mode + "-compile.txt")

        with compile_log.open("wb") as output:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

        entry.update(compile_exit=result.returncode, compile_log=str(compile_log), compile_log_sha256=sha(compile_log.read_bytes()))
        state["executions"].append(entry)
        assert result.returncode == 0, compile_log.read_text()

        signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
        entry["signature_exit"] = signature.returncode

        assert signature.returncode == 0, signature.stderr

        entry["binary_sha256"] = sha(binary.read_bytes())
        log = run / (name + "-" + mode + ".txt")

        with log.open("wb") as output:
            result = subprocess.run([str(binary)], stdout=output, stderr=subprocess.STDOUT)

        entry.update(exit_code=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()))
        state_path.write_text(json.dumps(state, indent=4) + "\n")
        assert result.returncode == 0, log.read_text()

        print(mode, name, "exit", result.returncode, flush=True)

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))

    raise

finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
