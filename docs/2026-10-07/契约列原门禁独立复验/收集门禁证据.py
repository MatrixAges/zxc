from pathlib import Path
import hashlib
import json
import re
import shlex
import sys

doc = Path(__file__).resolve().parent
mode, log_path, exit_text = sys.argv[1:]
raw = Path(log_path).read_bytes()
lines = raw.decode().splitlines()
summary = next(line for line in reversed(lines) if line.startswith("Build Summary:"))
assert int(exit_text) == 0 and summary == "Build Summary: 39/39 steps succeeded"
expected = {
    "tests/verification/public_test.ts": 8,
    "tests/verification/enumeration/verify_test.ts": 74,
    "tests/library_publish/contract_test.ts": 3,
    "tests/library_publish/rx_boundary_test.ts": 8,
    "tests/verification/verify_test.ts": None,
}
starts = []

for index, line in enumerate(lines):
    if line.startswith("info(verbose): node "):
        argv = shlex.split(line.removeprefix("info(verbose): "))
        starts.append((index, argv))

assert len(starts) == 5
runs = []

for position, (start, argv) in enumerate(starts):
    end = starts[position + 1][0] if position + 1 < len(starts) else len(lines)
    script = argv[1].removeprefix("./")
    assert script in expected
    section = "\n".join(lines[start:end])
    names = re.findall(r"^\s*✔ (.*?) \([\d.]+ms\)$", section, re.M)
    count = expected[script]

    if count is None:
        assert "Verification CLI: 20 scenarios passed" in section
        assert not names
    else:
        assert len(names) == count
        assert re.findall(r"^ℹ tests (\d+)$", section, re.M) == [str(count)]
        assert re.findall(r"^ℹ pass (\d+)$", section, re.M) == [str(count)]
        assert re.findall(r"^ℹ fail (\d+)$", section, re.M) == ["0"]

    binary = Path(argv[2])
    runs.append({"script": script, "argv": argv, "node_checks": count, "cli_scenarios": 20 if count is None else 0, "names": names, "cli_binary": str(binary), "cli_sha256": hashlib.sha256(binary.read_bytes()).hexdigest()})

assert {item["script"] for item in runs} == set(expected)
assert sum(item["node_checks"] or 0 for item in runs) == 93
assert not any(line.startswith(("error:", "failed command:")) for line in lines)
saved = doc / "日志" / (mode + ".txt")
saved.parent.mkdir(exist_ok=True)
saved.write_bytes(raw)
baseline = json.loads((doc / "开始基线.json").read_text())
result = {"source_commit": baseline["source_commit"], "packages_tree": baseline["packages_tree"], "mode": mode, "exit_code": 0, "summary": summary, "log": str(saved.relative_to(doc)), "log_sha256": hashlib.sha256(raw).hexdigest(), "runs": runs, "node_checks": 93, "cli_scenarios": 20, "cached_summary_entries": sum(" cached" in line and not line.startswith("info(verbose):") for line in lines)}
(doc / (mode + "门禁证据.json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({key: result[key] for key in ["mode", "exit_code", "summary", "node_checks", "cli_scenarios"]}))
