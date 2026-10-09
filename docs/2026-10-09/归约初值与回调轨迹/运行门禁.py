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
directory = run / (mode + "-corrected")
directory.mkdir()
state = {"status": "running", "mode": mode, "steps": [], "programs": []}
state_path = run / (mode + "-corrected-execution.json")


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
    original_path = run / (mode + "-execution.json")
    original = json.loads(original_path.read_text())
    assert original["status"] == "terminal" and original["steps"][0]["exit_code"] == 0
    tool = Path(original["tool"])
    assert sha(tool.read_bytes()) == original["tool_sha256"]
    subprocess.run(["/usr/bin/codesign", "--verify", "--strict", str(tool)], check=True)
    state.update(tool=str(tool), tool_sha256=sha(tool.read_bytes()), reuse_from=str(original_path), reuse_state_sha256=sha(original_path.read_bytes()))

    for initial in ["seeded", "unseeded"]:
        source = root / ("packages/test/tests/built_ins/list/callbacks/reduce/trace/" + initial + ".zx")
        catalog = source.with_suffix(".jsonl")
        test_source = run / (initial + "-cases.zig")
        expected = [json.loads(line)["id"] for line in catalog.read_text().split("\n") if line.strip()]
        assert len(expected) == inputs["counts"][initial]

        for route in ["source", "library"]:
            label = initial + "-" + route
            target = directory / label
            target.mkdir()
            execute([str(tool), str(source), str(root / "packages/test/tests/collections/reduce_initial/fixtures/numeric/host.d.zx"), route, str(target)], label + "-generate")
            command = ["node", str(root / "packages/test/tests/collections/reduce_initial/run_test.ts"), inputs["zig"], str(target), str(test_source), mode, str(root / "packages/test/tests/collections/reduce_initial/host.zig"), str(root / "packages/test/tests/collections/context_effects/oracle.zig"), "numeric", initial, "--entitlements", inputs["entitlements"], "--cache-dir", str(run / ("cache-" + mode)), "--global-cache-dir", str(run / "cache-global")]
            entry = execute(command, label + "-execute")
            execution_path = target / "runtime" / test_source.stem / "execution.json"
            execution = json.loads(execution_path.read_text())
            assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
            assert execution["names"] == expected
            subprocess.run(["/usr/bin/codesign", "--verify", "--strict", execution["binary"]], check=True)
            files = {str(path): sha(path.read_bytes()) for path in target.rglob("*") if path.is_file() and path.suffix in [".zig", ".json", ".log"]}
            state["programs"].append({"initial": initial, "route": route, "execution": str(execution_path), "names": expected, "binary": execution["binary"], "binary_sha256": execution["binary_sha256"], "files": files})
            save()
            print(mode, label, len(expected), "actual tests passed", flush=True)

    state["exit_code"] = 0
except BaseException as error:
    state.update(exit_code=1, error=str(error))
    raise
finally:
    state.update(status="terminal", finished=datetime.datetime.now(datetime.timezone.utc).isoformat())
    save()
