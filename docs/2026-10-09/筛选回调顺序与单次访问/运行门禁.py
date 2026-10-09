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

directory = run / mode
directory.mkdir()
state_path = run / (mode + "-execution.json")
state = {"status": "running", "mode": mode, "steps": [], "programs": [], "started": datetime.datetime.now(datetime.timezone.utc).isoformat()}


def save():
    state_path.write_text(json.dumps(state, indent=4) + "\n")


def execute(command, label):
    log = directory / (label + ".log.txt")

    with log.open("wb") as output:
        result = subprocess.run(command, cwd=root / "packages/test", stdout=output, stderr=subprocess.STDOUT)

    entry = {"command": command, "exit_code": result.returncode, "log": str(log), "log_sha256": sha(log.read_bytes())}
    state["steps"].append(entry)
    save()
    assert result.returncode == 0, str(log)

    return entry


save()
try:
    tool = directory / "compile-filter-traces"
    command = ["-femit-bin=" + str(tool) if arg == "-femit-bin=BINARY" else arg for arg in inputs["compile_templates"][mode]]
    execute(command, "compile-tool")
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True, capture_output=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))

    for suite, count in inputs["counts"].items():
        base = root / ("packages/test/tests/built_ins/list/callbacks/filter/trace/" + suite)
        source = base.with_suffix(".zx")
        catalog = base.with_suffix(".jsonl")
        test_source = directory / (suite + "_cases.zig")
        expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
        assert len(expected) == count
        execute(["/usr/local/bin/node", str(root / "packages/test/src/emit_filter_tests.ts"), str(catalog), str(root / "packages/test/tests/collections/filter_trace/check.zig"), str(test_source)], suite + "-emit")

        for route in ["source", "library"]:
            label = suite + "-" + route
            target = directory / label
            target.mkdir()
            execute([str(tool), str(source), str(root / "packages/test/tests/collections/callback_arguments/fixtures/host.d.zx"), route, str(target)], label + "-generate")
            execute(["/usr/local/bin/node", str(root / "packages/test/tests/collections/callback_arguments/run_test.ts"), inputs["zig"], str(target), str(test_source), mode, str(root / "packages/test/tests/collections/filter_trace/host.zig"), str(root / "packages/test/tests/collections/context_effects/oracle.zig"), "filter", "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-runtime-" + mode)), "--global-cache-dir", str(run / "cache-global")], label + "-execute")
            runtime = target / "runtime" / test_source.stem
            execution = json.loads((runtime / "execution.json").read_text())
            text = (runtime / "execution.log").read_text()
            names = re.findall(r"^\d+/\d+ .*?\.test\.(.+?)\.\.\.OK$", text, re.MULTILINE)
            assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
            assert names == execution["names"] == expected
            assert "All " + str(count) + " tests passed." in text
            binary = Path(execution["binary"])
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(binary)], check=True, capture_output=True)
            assert sha(binary.read_bytes()) == execution["binary_sha256"]
            state["programs"].append({"suite": suite, "route": route, "names": names, "source_sha256": sha(source.read_bytes()), "catalog_sha256": sha(catalog.read_bytes()), "test_source": str(test_source), "test_source_sha256": sha(test_source.read_bytes()), "binary": str(binary), "binary_sha256": sha(binary.read_bytes()), "signature_verified": True, "files": {str(path): sha(path.read_bytes()) for path in target.rglob("*") if path.is_file() and path != binary}})
            save()
            print(mode, label, len(names), "actual tests passed", flush=True)

    state.update(exit_code=0, named_executions=sum(len(item["names"]) for item in state["programs"]))
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
