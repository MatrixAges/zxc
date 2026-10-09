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

merge_names = ["bulk/permutation", "bulk/late_failure", "identity", "invalid", "resources", "storage", "storage_append", "preflight/prefix", "preflight/origins", "preflight/resources", "bulk/mapping", "bulk/nominal", "bulk/ownership", "bulk/resources", "compaction/mapping", "compaction/resources"]
artifact_names = ["extract", "invalid", "resources", "mixed/extract", "mixed/resources", "frontier/graph", "frontier/resources", "imports/mapping", "imports/rejection", "imports/lifetime", "imports/resources", "imports/columns"]
roots = ["incremental/type_merge/" + name for name in merge_names] + ["incremental/artifact/" + name for name in artifact_names] + ["library/imports/identity", "library/imports/rejection", "library/imports/native"]
state_path = run / (mode + "-execution.json")
previous = json.loads(state_path.read_text())
assert previous["status"] == "terminal"
formatted = len(sys.argv) > 2 and sys.argv[2] == "formatted"
assert previous["exit_code"] == (0 if formatted else 1)
history = run / "history"
history.mkdir(exist_ok=True)
(history / (mode + ("-before-format.json" if formatted else "-before-root-recovery.json"))).write_bytes(state_path.read_bytes())
completed = {entry["name"]: entry for entry in previous["tests"] if entry.get("signature_verified") and entry.get("exit_code") == 0}
selected = roots[:2] if formatted else [name for name in roots if name not in completed]
state = {"status": "running", "mode": mode, "started": datetime.datetime.now(datetime.timezone.utc).isoformat(), "tests": list(completed.values()), "recovery": "format" if formatted else "module-root"}
state_path.write_text(json.dumps(state, indent=4) + "\n")

try:
    for name in selected:
        output = run / mode / ("formatted" if formatted else "module-root") / name
        output.parent.mkdir(parents=True, exist_ok=True)
        source = root / "packages/test/tests" / (name + "_test.zig")
        wrapper = root / "packages/test/tests" / ("conformance_" + mode.lower() + "_" + name.replace("/", "_") + ".zig")
        wrapper.write_text('comptime {\n    _ = @import("' + name + '_test.zig");\n}\n')
        command = ["-Mroot=" + str(wrapper) if arg == "-Mroot=ROOT" else "-femit-bin=" + str(output) if arg == "-femit-bin=BINARY" else arg for arg in inputs["compile_templates"][mode]]
        root_index = next(i for i, arg in enumerate(command) if arg.startswith("-Mroot="))
        command[root_index:root_index] = ["--dep", "record_fixture", "--dep", "type_merge_fixture"]
        command += ["-O" + mode, "--dep", "compiler", "-Mrecord_fixture=" + str(root / "packages/test/tests/incremental/module_records/fixture.zig"), "-O" + mode, "--dep", "compiler", "-Mtype_merge_fixture=" + str(root / "packages/test/tests/incremental/type_merge/preflight/fixture.zig")]
        log = Path(str(output) + ".log.txt")
        entry = {"name": name, "command": command, "source": str(source), "source_sha256": sha(source.read_bytes()), "binary": str(output), "log": str(log)}
        entry.update(wrapper=str(wrapper), wrapper_sha256=sha(wrapper.read_bytes()))
        state["tests"] = [item for item in state["tests"] if item["name"] != name] + [entry]

        with log.open("wb") as stream:
            result = subprocess.run(command, cwd=root / "packages/test", stdout=stream, stderr=subprocess.STDOUT)

        entry.update(exit_code=result.returncode, log_sha256=sha(log.read_bytes()))
        assert result.returncode == 0, log.read_text()
        signature = subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(output)], capture_output=True, text=True)
        assert signature.returncode == 0, signature.stderr
        text = log.read_text()
        names = re.findall(r"^\d+/\d+ (.+?)\.\.\.OK$", text, re.MULTILINE)
        summary = re.search(r"All (\d+) tests passed\.", text)
        assert summary and len(names) == int(summary.group(1)) and len(names) > 0, text
        entry.update(binary_sha256=sha(output.read_bytes()), signature_verified=True, test_names=names, test_count=len(names))
        state_path.write_text(json.dumps(state, indent=4) + "\n")
        print(mode, name, len(names), "passed", flush=True)

    state["tests"] = sorted(state["tests"], key=lambda entry: roots.index(entry["name"]))
    assert len(state["tests"]) == 31
    state.update(exit_code=0, named_executions=sum(entry["test_count"] for entry in state["tests"]))
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    state_path.write_text(json.dumps(state, indent=4) + "\n")
