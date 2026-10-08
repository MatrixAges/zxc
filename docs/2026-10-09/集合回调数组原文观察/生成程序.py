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

for name, expected in inputs["packages"].items():
    assert sha((root / name).read_bytes()) == expected, name

state = {"mode": mode, "status": "running", "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "drivers": [], "programs": []}
state_path = run / (mode + "-generation.json")
directory = run / mode
directory.mkdir(exist_ok=True)

def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")

save()

try:
    for name, source, tool_kind in [
        ("contexts", doc / "编译真实源.zig", "test"),
        ("filter_false", root / "packages/test/tests/collections/filter_result_kind/compile.zig", "build-exe"),
    ]:
        binary = directory / ("compile-" + name)
        command = []
        external = {}

        for argument in inputs["test_templates"][0]:
            if argument == "--listen=-":
                continue

            if argument == "test":
                argument = tool_kind
            elif argument.startswith("-O"):
                argument = "-O" + mode
            elif argument.startswith("-M"):
                prefix, value = argument.split("=", 1)

                if prefix == "-Mroot":
                    value = str(source)
                elif prefix == "-Mfrontend":
                    command += ["--dep", "generated_artifact_roots"]

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

        command += ["-O" + mode, "--dep", "integers", "--dep", "zxc_abi=zxc_abi32", "-Mgenerated_artifact_roots=" + str(run / "generated/artifact_roots.zig")]
        command += ["-O" + mode, "-Mzxc_abi32=" + str(run / "generated/artifact_roots_abi.zig")]
        command += ["-femit-bin=" + str(binary), "--entitlements", inputs["entitlements"]]

        if tool_kind == "test":
            command += ["--test-no-exec"]

        log = directory / (name + "-compile.txt")
        entry = {"name": name, "command": command, "external": external, "source": str(source), "source_sha256": sha(source.read_bytes()), "binary": str(binary)}
        state["drivers"].append(entry)
        save()

        with log.open("wb") as output:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

        entry.update(compile_exit=result.returncode, compile_log=str(log), compile_log_sha256=sha(log.read_bytes()))
        assert result.returncode == 0, log.read_text()
        signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], capture_output=True, text=True)
        entry.update(signature_exit=signature.returncode, binary_sha256=sha(binary.read_bytes()))
        assert signature.returncode == 0, signature.stderr
        target = directory / "filter_false.zig"
        execute = [str(binary)] if tool_kind == "test" else [str(binary), str(root / "packages/test/tests/built_ins/list/callbacks/filter/constant_false/cases.zx"), str(target)]
        log = directory / (name + "-generation.txt")

        with log.open("wb") as output:
            result = subprocess.run(execute, stdout=output, stderr=subprocess.STDOUT)

        entry.update(execute_command=execute, execute_exit=result.returncode, log=str(log), log_sha256=sha(log.read_bytes()))
        assert result.returncode == 0, log.read_text()

        if tool_kind == "test":
            frames = {}

            for piece in log.read_bytes().split(b"\x1e")[1:]:
                label, separator, rest = piece.partition(b"\x1f")
                emitted, end, _ = rest.partition(b"\x1d")
                assert separator and end
                frames[label.decode().removesuffix(".zx")] = emitted

            assert set(frames) == {"map", "filter", "every", "some"}

            for label, emitted in frames.items():
                (directory / (label + ".zig")).write_bytes(emitted)

        print(mode, name, "generated", flush=True)
        save()

    for name in ["map", "filter", "every", "some", "filter_false"]:
        program = directory / (name + ".zig")
        path = "filter/constant_false" if name == "filter_false" else name + "/context"
        catalog = root / ("packages/test/tests/built_ins/list/callbacks/" + path + "/cases.jsonl")
        tests = directory / (name + "_test.zig")
        subprocess.run(["/usr/local/bin/node", "src/emit_control_tests.ts", str(catalog), str(tests)], cwd=root / "packages/test", check=True)
        rows = [json.loads(line) for line in catalog.read_text().split("\n") if line]
        state["programs"].append({"method": name, "source_path": str(program), "source_sha256": sha(program.read_bytes()), "test_path": str(tests), "test_sha256": sha(tests.read_bytes()), "catalog_path": str(catalog), "catalog_sha256": sha(catalog.read_bytes()), "names": [row["id"] for row in rows]})

    assert sum(len(item["names"]) for item in state["programs"]) == 90
    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
