from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "生成器修复冻结.json").read_text())
assert len(freeze["paths"]) == 1
for item in freeze["paths"]:
    data = (root / item["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == item["sha256"]
    assert data == (doc / "草稿" / item["path"]).read_bytes()
outputs = json.loads((doc / "原输出冻结.json").read_text())
assert len(outputs) == 23 and sum(item.get("cases", 0) for item in outputs) == 941
for item in outputs:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]
evidence = json.loads((doc / "枚举独立执行证据.json").read_text())
assert evidence["source_commit"] == freeze["source_commit"] and evidence["independent_replay_checks"] == 54
assert hashlib.sha256(Path(evidence["cli"]).read_bytes()).hexdigest() == evidence["cli_sha256"]
records = [row for row in evidence["records"] if "binary" in row]
assert len(records) == 2 and {row["label"] for row in records} == {"Debug", "ReleaseSafe"}
for row in records:
    assert row["checks"] == 27 and row["exit_code"] == 0
    assert hashlib.sha256(Path(row["binary"]).read_bytes()).hexdigest() == row["sha256"]
    replay = (doc / row["replay"]).read_bytes()
    assert hashlib.sha256(replay).hexdigest() == row["replay_sha256"]
    assert b"All 27 tests passed." in replay
for item in evidence["artifacts"]:
    data = (doc / item["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == item["sha256"]
    assert data == Path(item["executed_source"]).read_bytes()
assert all(row["exit_code"] == 0 for row in evidence["records"])
print("PASS: one frozen generator fix; all 23 original outputs and 941 cases unchanged; both enum binaries independently pass 54 checks")
