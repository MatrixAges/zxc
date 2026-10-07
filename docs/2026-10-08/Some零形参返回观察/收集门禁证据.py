from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

mode, log_path, exit_code = sys.argv[1:]
doc = Path(__file__).resolve().parent
raw = Path(log_path).read_bytes()
log = raw.decode()
baseline = json.loads((doc / "开始基线.json").read_text())
for item in baseline["inputs"]:
    assert hashlib.sha256((Path(baseline["execution_root"]) / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

assert int(exit_code) == 0
summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded[^\n]*", log)
assert summary and summary[1] == summary[2]
assert "not ok" not in log and "error:" not in log

runs = []
for line in log.splitlines():
    if not line.startswith("info(verbose): node "):
        continue
    argv = shlex.split(line.removeprefix("info(verbose): "))
    if not argv[1].endswith("/predicates/run_test.ts"):
        continue
    directory = Path(argv[3])
    execution = json.loads((directory / "execution.json").read_text())
    assert execution["status"] == 0 and execution["signal"] is None and execution["error"] is None
    result_log = (directory / "execution.log").read_bytes()
    count = re.search(rb"All (\d+) tests passed", result_log)
    assert count
    expected_count = {"every": 88, "some": 87, "map": 59}[argv[-1]]
    assert int(count[1]) == expected_count
    catalog = Path(json.loads((doc / "开始基线.json").read_text())["execution_root"]) / "packages/test/tests/built_ins/list/predicates/observations" / (argv[-1] + ".jsonl")
    ids = [json.loads(line)["id"] for line in catalog.read_text().splitlines()]
    observed = re.findall(r"^\d+/\d+ \S*\.test\.(.*?)\.\.\.OK$", result_log.decode(), re.M)
    assert observed == ids, (argv[-1], len(observed), len(ids))
    saved_dir = doc / "运行" / mode / directory.name
    saved_dir.mkdir(parents=True, exist_ok=True)
    artifacts = []
    sources = sorted({Path(arg.split("=", 1)[1]) for arg in execution["argv"] if arg.startswith("-M")})
    for source in sources:
        data = source.read_bytes()
        saved = doc / "生成物" / (hashlib.sha256(data).hexdigest() + ".zig.txt")
        saved.parent.mkdir(exist_ok=True)
        saved.write_bytes(data)
        artifacts.append({"executed_source": str(source), "saved": str(saved.relative_to(doc)), "sha256": hashlib.sha256(data).hexdigest()})
    for name in ["execution.json", "execution.log", "modules.json", "native.json"]:
        (saved_dir / (name + ".txt")).write_bytes((directory / name).read_bytes())
    runs.append({"method": argv[-1], "route": directory.name.split("-")[-1], "directory": str(directory), "tests": int(count[1]), "test_names": observed, "execution": str((saved_dir / "execution.json.txt").relative_to(doc)), "log": str((saved_dir / "execution.log.txt").relative_to(doc)), "log_sha256": hashlib.sha256(result_log).hexdigest(), "artifacts": artifacts})

assert len(runs) == 6
assert sum(run["tests"] for run in runs) == 468
assert {(run["method"], run["route"]) for run in runs} == {(method, route) for method in ["every", "some", "map"] for route in ["source", "library"]}
archive = doc / "日志" / (mode + "-完整门禁.txt")
archive.parent.mkdir(exist_ok=True)
archive.write_bytes(raw)
formal_options = []
for line in log.splitlines():
    if not line.startswith("info(verbose): "):
        continue
    args = shlex.split(line.removeprefix("info(verbose): "))
    if "--name" not in args or args[args.index("--name") + 1] != "compile-predicate-reviews":
        continue
    option = next((arg for arg in args if arg.startswith("-Mparser_options=")), None)
    if option is None:
        continue
    path = Path(option.split("=", 1)[1])
    data = path.read_bytes()
    assert b"generated_parser: bool = true" in data or b"generated_parser = true" in data
    saved = doc / "生成物" / (hashlib.sha256(data).hexdigest() + ".zig.txt")
    saved.write_bytes(data)
    formal_options.append({"path":str(path), "saved":str(saved.relative_to(doc)), "sha256":hashlib.sha256(data).hexdigest(), "generated_parser":True})

evidence = {"source_commit":baseline["source_commit"], "packages_tree":baseline["packages_tree"], "formal_parser_options":formal_options,"mode": mode, "exit_code": int(exit_code), "summary": summary[0], "log": str(archive.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(), "cached_summary_entries": sum("cached" in line for line in log.splitlines()), "runs": runs, "zig_tests": 468, "node_test_blocks": 6}
(doc / (mode + "门禁证据.json")).write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"mode": mode, "exit_code": int(exit_code), "zig_tests": 468, "node_test_blocks": 6, "summary": summary[0]}))
