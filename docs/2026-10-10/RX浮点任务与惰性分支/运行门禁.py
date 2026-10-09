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
    tool = directory / "compile-rx-floating"
    command = ["-femit-bin=" + str(tool) if arg.startswith("-femit-bin=") else arg for arg in inputs["compile_templates"][mode]]
    execute(command, "compile-tool")
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()))
    for suite, count in inputs["counts"].items():
        source = root / ("packages/test/tests/rx/runtime/floating/" + suite + ".rx")
        catalog = source.with_suffix(".jsonl")
        label = suite.replace("/", "-")
        test_source = directory / (label + "-cases.zig")
        execute(["/usr/local/bin/node", "src/emit_rx_floating.ts", str(catalog), "tests/rx/runtime/floating/check.zig", str(test_source)], label + "-emit-tests")
        expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
        assert len(expected) == count
        for route in ["source", "forward", "reverse", "rx_forward", "rx_reverse", "zx_forward", "zx_reverse", "republish_forward", "republish_reverse"]:
            name = label + "-" + route
            target = directory / name
            target.mkdir()
            execute([str(tool), str(source), route, str(target)], name + "-generate")
            assert json.loads((target / "native.json").read_text()) == []
            command = ["/usr/local/bin/node", "tests/rx/runtime/floating/run_test.ts", inputs["zig"], str(target), str(test_source), mode, "tests/support/allocation_testing.zig", "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]
            execute(command, name + "-execute")
            runtime = target / "runtime" / test_source.stem
            record = json.loads((runtime / "execution.json").read_text())
            assert record["status"] == 0 and record["signal"] is None and record["error"] is None
            assert record["names"] == expected
            log = (runtime / "execution.log").read_text()
            assert "All " + str(count) + " tests passed." in log
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", record["binary"]], check=True)
            state["programs"].append({"suite": suite, "route": route, "names": expected, "source_sha256": sha(source.read_bytes()), "catalog_sha256": sha(catalog.read_bytes()), "test_source": str(test_source), "test_source_sha256": sha(test_source.read_bytes()), "signature_verified": True, "record": str(runtime / "execution.json"), "binary": record["binary"], "binary_sha256": sha(Path(record["binary"]).read_bytes()), "files": {str(path): sha(path.read_bytes()) for path in target.rglob("*") if path.is_file() and str(path) != record["binary"]}})
            save()
            print(mode, name, count, "actual named tests passed", flush=True)
    state.update(exit_code=0, named_executions=sum(len(item["names"]) for item in state["programs"]))
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
