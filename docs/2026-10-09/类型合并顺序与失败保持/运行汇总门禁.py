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
sha = lambda data: hashlib.sha256(data).hexdigest()
assert mode in inputs["compile_templates"]
assert json.loads((run / "generator-state.json").read_text())["exit_code"] == 0
for name, expected in {**inputs["packages"], **inputs["formal_sha256"]}.items():
    assert sha((root / name).read_bytes()) == expected, name

state_path = run / (mode + "-aggregate-execution.json")
assert not state_path.exists()
state = {"status": "running", "mode": mode, "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "gates": []}
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    for part in ["types_and_artifacts", "compaction"]:
        selected = [name for name in inputs["test_roots"] if ("/compaction/" in name) == (part == "compaction")]
        wrapper = root / "packages/test/tests" / ("conformance_" + mode.lower() + "_" + part + ".zig")
        wrapper.write_text("comptime {\n" + "".join('    _ = @import("' + name + '_test.zig");\n' for name in selected) + "}\n")
        binary = run / mode / ("aggregate-" + part)
        binary.parent.mkdir(exist_ok=True)
        command = ["-Mroot=" + str(wrapper) if arg == "-Mroot=ROOT" else "-femit-bin=" + str(binary) if arg == "-femit-bin=BINARY" else arg for arg in inputs["compile_templates"][mode]]
        index = next(i for i, arg in enumerate(command) if arg.startswith("-Mroot="))
        command[index:index] = ["--dep", "record_fixture", "--dep", "type_merge_fixture"]
        command += ["-O" + mode, "--dep", "compiler", "-Mrecord_fixture=" + str(root / "packages/test/tests/incremental/module_records/fixture.zig"), "-O" + mode, "--dep", "compiler", "-Mtype_merge_fixture=" + str(root / "packages/test/tests/incremental/type_merge/preflight/fixture.zig")]
        sources = {name: sha((root / "packages/test/tests" / (name + "_test.zig")).read_bytes()) for name in selected}
        expected = [name.replace("/", ".") + "_test.test." + description for name in selected for description in re.findall(r'^test "([^"\n]+)"', (root / "packages/test/tests" / (name + "_test.zig")).read_text(), re.MULTILINE)]
        log = Path(str(binary) + ".log.txt")
        entry = {"part": part, "roots": selected, "sources": sources, "wrapper": str(wrapper), "wrapper_sha256": sha(wrapper.read_bytes()), "command": command, "binary": str(binary), "log": str(log), "expected_names": expected}
        state["gates"].append(entry)

        with log.open("wb") as output:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

        entry.update(exit_code=result.returncode, log_sha256=sha(log.read_bytes()))
        assert result.returncode == 0, log.read_text()
        subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True, capture_output=True)
        names = re.findall(r"^\d+/\d+ (.+?)\.\.\.OK$", log.read_text(), re.MULTILINE)
        assert sorted(names) == sorted(expected), (names, expected)
        assert "All " + str(len(names)) + " tests passed." in log.read_text()
        entry.update(test_names=names, test_count=len(names), binary_sha256=sha(binary.read_bytes()), signature_verified=True)
        state_path.write_text(json.dumps(state, indent=4) + "\n")
        print(mode, part, len(names), "passed", flush=True)

    state.update(exit_code=0, named_executions=sum(entry["test_count"] for entry in state["gates"]))
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
