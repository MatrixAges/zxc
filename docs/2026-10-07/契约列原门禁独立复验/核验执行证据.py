from pathlib import Path
import hashlib
import json
import re
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())

for item in baseline["inputs"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]

previous = None

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / (mode + "门禁证据.json")).read_text())
    raw = (doc / evidence["log"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["exit_code"] == 0 and evidence["summary"] == "Build Summary: 39/39 steps succeeded"
    assert evidence["node_checks"] == 93 and evidence["cli_scenarios"] == 20
    assert len(evidence["runs"]) == 5
    observed = re.findall(r"^\s*✔ (.*?) \([\d.]+ms\)$", raw.decode(), re.M)
    names = [name for item in evidence["runs"] for name in item["names"]]
    assert observed == names and len(names) == 93
    assert sum(item["cli_scenarios"] for item in evidence["runs"]) == 20
    assert "Verification CLI: 20 scenarios passed" in raw.decode()
    assert len({item["cli_binary"] for item in evidence["runs"]}) == 1
    current = {}

    for item in evidence["runs"]:
        assert hashlib.sha256(Path(item["cli_binary"]).read_bytes()).hexdigest() == item["cli_sha256"]
        assert item["node_checks"] is None or len(item["names"]) == item["node_checks"]
        current[item["script"]] = item["names"]

    if previous is not None:
        assert current == previous

    previous = current

status = json.loads((doc / "运行状态.json").read_text())
assert status["source_commit"] == baseline["source_commit"]
assert status["package_source_frozen"] is False

for mode in ["Debug", "ReleaseSafe"]:
    assert status[mode]["state"] == "completed" and status[mode]["exit_code"] == 0

print("PASS: unchanged frozen source, 186 original Node checks, 40 CLI scenarios, both generated CLI identities")
