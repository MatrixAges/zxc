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
    expected_count = {"every": 87, "some": 86, "map": 59}[argv[-1]]
    assert int(count[1]) == expected_count
    saved_dir = doc / "运行" / mode / directory.name
    saved_dir.mkdir(parents=True, exist_ok=True)
    artifacts = []
    sources = list(directory.glob("*.zig")) + [Path(execution["source"])]
    for source in sources:
        data = source.read_bytes()
        saved = doc / "生成物" / (hashlib.sha256(data).hexdigest() + ".zig.txt")
        saved.parent.mkdir(exist_ok=True)
        saved.write_bytes(data)
        artifacts.append({"executed_source": str(source), "saved": str(saved.relative_to(doc)), "sha256": hashlib.sha256(data).hexdigest()})
    for name in ["execution.json", "execution.log", "modules.json", "native.json"]:
        (saved_dir / (name + ".txt")).write_bytes((directory / name).read_bytes())
    runs.append({"method": argv[-1], "route": directory.name.split("-")[-1], "directory": str(directory), "tests": int(count[1]), "execution": str((saved_dir / "execution.json.txt").relative_to(doc)), "log": str((saved_dir / "execution.log.txt").relative_to(doc)), "log_sha256": hashlib.sha256(result_log).hexdigest(), "artifacts": artifacts})

assert len(runs) == 6
assert sum(run["tests"] for run in runs) == 464
assert {(run["method"], run["route"]) for run in runs} == {(method, route) for method in ["every", "some", "map"] for route in ["source", "library"]}
archive = doc / "日志" / (mode + "-完整门禁.txt")
archive.parent.mkdir(exist_ok=True)
archive.write_bytes(raw)
evidence = {"mode": mode, "exit_code": int(exit_code), "summary": summary[0], "log": str(archive.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(), "cached_summary_entries": sum("cached" in line for line in log.splitlines()), "runs": runs, "zig_tests": 464, "node_test_blocks": 6}
(doc / (mode + "门禁证据.json")).write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"mode": mode, "exit_code": int(exit_code), "zig_tests": 464, "node_test_blocks": 6, "summary": summary[0]}))
