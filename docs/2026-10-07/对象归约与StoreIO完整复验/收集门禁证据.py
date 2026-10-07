from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

mode, log_path, exit_code = sys.argv[1:]
root = Path.cwd()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]
raw = Path(log_path).read_bytes()
log = raw.decode()
lines = log.splitlines()
summary = next((line for line in reversed(lines) if line.startswith("Build Summary:")), None)
assert summary
steps = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", summary)
tests = re.search(r"(\d+)/(\d+) tests passed", summary)
assert steps and tests
commands = []
binaries = []
generators = {}
artifacts = {}
store_runs = []

for index, line in enumerate(lines):
    if not line.startswith("info(verbose): "):
        continue
    command = line.removeprefix("info(verbose): ")
    original_argv = shlex.split(command)
    commands.append({"line": index + 1, "argv": original_argv})
    argv = original_argv[original_argv.index("node"):] if "node" in original_argv else original_argv
    if len(argv) > 1 and argv[1].startswith("--cache-dir="):
        path = Path(argv[0])
        binaries.append({"path": str(path), "sha256": hashlib.sha256(path.read_bytes()).hexdigest()})
    if argv[0].endswith("/compile-rx-store-io"):
        generators[argv[2]] = argv[1]
        sources = list(Path(argv[2]).glob("*.zig")) + [Path(argv[2]) / "modules.json"]
    else:
        sources = [Path(arg.split("=", 1)[1]) for arg in argv if arg.startswith(("-Mprogram=", "-Mzxc_abi=", "-Moptions="))]
    for source in sources:
        data = source.read_bytes()
        sha = hashlib.sha256(data).hexdigest()
        saved = doc / "生成物" / (sha + source.suffix + ".txt")
        saved.parent.mkdir(exist_ok=True)
        saved.write_bytes(data)
        artifacts[str(source)] = {"executed_source": str(source), "sha256": sha, "saved": str(saved.relative_to(doc))}
    if argv[0] != "node" or not argv[1].endswith("/store/memory/run_test.ts"):
        continue
    end = next((number for number in range(index + 1, len(lines)) if lines[number].startswith("info(verbose): ") or lines[number].startswith("Build Summary:")), len(lines))
    section = "\n".join(lines[index + 1:end]) + "\n"
    passed = re.search(r"All (\d+) tests passed", section)
    assert passed and "ℹ pass 1" in section and "not ok" not in section
    directory = argv[3]
    test_name = Path(argv[4]).stem
    store_mode = generators[directory]
    expected_count = {"continuity_test": 6, "failure_test": 7, "allocation_test": 4, "readonly_test": 5}[test_name]
    assert int(passed[1]) == expected_count
    saved = doc / "Store运行" / f"{mode}-{store_mode}-{test_name}.txt"
    saved.parent.mkdir(exist_ok=True)
    saved.write_text(section)
    store_runs.append({"mode": store_mode, "test": test_name, "tests": int(passed[1]), "node_test_blocks": 1, "command": original_argv, "log": str(saved.relative_to(doc)), "log_sha256": hashlib.sha256(saved.read_bytes()).hexdigest()})

errors = [{"line": index + 1, "text": line} for index, line in enumerate(lines) if line.startswith("error:") or line.startswith("failed command:") or line.startswith("not ok")]
passed = int(exit_code) == 0 and steps[1] == steps[2] and tests[1] == tests[2] and not errors
if int(exit_code) == 0:
    assert passed
    assert len(binaries) == 20 and len({binary["path"] for binary in binaries}) == 20
    assert int(tests[1]) == 192
    assert len(store_runs) == 7 and sum(run["tests"] for run in store_runs) == 39
    assert set(generators.values()) == {"write", "service", "readonly"}
    assert {(run["mode"], run["test"]) for run in store_runs} == {(store_mode, test_name) for store_mode in ["write", "service"] for test_name in ["continuity_test", "failure_test", "allocation_test"]} | {("readonly", "readonly_test")}
archive = doc / "日志" / (mode + "-完整门禁.txt")
archive.parent.mkdir(exist_ok=True)
archive.write_bytes(raw)
evidence = {"mode": mode, "source_commit": baseline["source_commit"], "packages_tree": baseline["packages_tree"], "exit_code": int(exit_code), "passed": passed, "summary": summary, "steps_passed": int(steps[1]), "steps_total": int(steps[2]), "zig_tests_passed": int(tests[1]), "zig_tests_total": int(tests[2]), "store_zig_tests": sum(run["tests"] for run in store_runs), "node_test_blocks": len(store_runs), "log": str(archive.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(), "cached_summary_entries": sum(" cached" in line and not line.startswith("info(verbose):") for line in lines), "commands": commands, "binaries": binaries, "artifacts": list(artifacts.values()), "store_runs": store_runs, "errors": errors}
(doc / (mode + "执行证据.json")).write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: evidence[key] for key in ["mode", "source_commit", "exit_code", "passed", "summary", "store_zig_tests", "node_test_blocks", "cached_summary_entries"]}, ensure_ascii=False))
