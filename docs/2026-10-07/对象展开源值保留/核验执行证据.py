from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "最终输入冻结.json").read_text())

for item in freeze["paths"]:
    path = root / item["path"]
    if item.get("deleted"):
        assert not path.exists()
        continue
    data = path.read_bytes()
    assert hashlib.sha256(data).hexdigest() == item["sha256"]
    assert data == (doc / "草稿" / item["path"]).read_bytes()

unchanged = json.loads((doc / "未改输出证据.json").read_text())
assert unchanged["unchanged_count"] == len(unchanged["unchanged"]) == 14
for item in unchanged["unchanged"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"]

migration = json.loads((doc / "案例迁移证据.json").read_text())
assert migration["runtime_before"] == 6 and migration["runtime_after"] == 8
assert len(migration["retained_runtime_rows"]) == 6 and len(migration["added_runtime_rows"]) == 2
assert all(row["diagnostic"] is None for row in migration["frontend_rows"])
original = json.loads((doc / "原文执行证据.json").read_text())
assert original["executions"] == 4 and original["assertions"] == 24
assert all(row["passed"] for row in original["records"])
inputs = json.loads((doc / "输入冻结.json").read_text())
for sample in inputs["samples"]:
    raw = (doc / "原文" / (Path(sample["path"]).stem + ".js.txt")).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == sample["sha256"]

binaries = set()
checks = 0
for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{mode}执行证据.json").read_text())
    assert evidence["source_commit"] == freeze["execution_source_commit"]
    assert evidence["checks"] == 10 and len(evidence["records"]) == 4
    assert hashlib.sha256(Path(evidence["cli"]).read_bytes()).hexdigest() == evidence["cli_sha256"]
    for row in evidence["records"]:
        assert row["exit_code"] == 0 and row["binary"] not in binaries
        binaries.add(row["binary"])
        assert hashlib.sha256(Path(row["binary"]).read_bytes()).hexdigest() == row["binary_sha256"]
        raw = (doc / row["log"]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == row["log_sha256"]
        assert f"All {row['checks']} tests passed.".encode() in raw
        for item in row["artifacts"]:
            data = (doc / item["path"]).read_bytes()
            assert hashlib.sha256(data).hexdigest() == item["sha256"]
            assert data == Path(item["executed_source"]).read_bytes()
        checks += row["checks"]
assert len(binaries) == 8 and checks == 20
catalog = json.loads((doc / "目录审计.json").read_text())
assert catalog["catalog_cases"] == 128365 and catalog["unreviewed"] == 50635
print("PASS: six original runtime rows retained; two source observations restored; 14 outputs unchanged; 24 original assertions and 20 real Zig checks passed")
