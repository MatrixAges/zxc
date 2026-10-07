from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "最终输入冻结.json").read_text())
assert len(freeze["paths"]) == 7
original = json.loads((doc / "原始输入冻结.json").read_text())
assert hashlib.sha256((doc / "草稿/原始枚举案例.ts.txt").read_bytes()).hexdigest() == original["paths"][-1]["sha256"]

for item in freeze["paths"]:
    data = (root / item["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == item["sha256"], item["path"]
    assert data == (doc / "草稿" / item["path"]).read_bytes()

checks = 0
cli_hashes = set()

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{mode}执行证据.json").read_text())
    assert evidence["source_commit"] == freeze["source_commit"]
    assert evidence["draft_sources"] == freeze["paths"]
    assert evidence["checks"] == 141 and len(evidence["records"]) == 6
    assert hashlib.sha256(Path(evidence["cli"]).read_bytes()).hexdigest() == evidence["cli_sha256"]
    assert hashlib.sha256(Path(evidence["solver"]).read_bytes()).hexdigest() == evidence["solver_sha256"]
    cli_hashes.add(evidence["cli_sha256"])

    for row in evidence["records"]:
        assert row["exit_code"] == 0
        assert row["counts"]["tests"] == row["counts"]["pass"]
        assert all(row["counts"][key] == 0 for key in ["fail", "cancelled", "skipped", "todo"])
        raw = (doc / row["log"]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == row["log_sha256"]
        assert f"ℹ pass {row['counts']['tests']}".encode() in raw
        checks += row["counts"]["tests"]

assert len(cli_hashes) == 2 and checks == 282
assert b"Build Summary: 35/35 steps succeeded" in (doc / "日志/ReleaseSafe-CLI构建.txt").read_bytes()
audit = json.loads((doc / "目录审计.json").read_text())
assert audit["catalog_cases"] == 128363 and audit["unreviewed"] == 50635
print("PASS: seven exact executed sources; two real CLI builds; 282 existing checks; catalogs unchanged")
