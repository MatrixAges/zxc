import hashlib
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1]).resolve()
doc = root / "docs/2026-10-07/整数复合赋值安全边界"
freeze = json.loads((doc / "输入冻结.json").read_text())
for item in freeze["paths"]:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]
    assert (root / item["path"]).read_bytes() == (doc / "草稿" / item["path"]).read_bytes()
    if "executed_path" in item:
        executed = (doc / item["executed_path"]).read_bytes()
        assert hashlib.sha256(executed).hexdigest() == item["executed_sha256"]
        assert [line for line in executed.splitlines() if line.strip()] == [line for line in (root / item["path"]).read_bytes().splitlines() if line.strip()]
checks = 0
panics = 0
errors = 0
for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}证据.json").read_text())
    assert evidence["source_commit"] == freeze["source_commit"]
    assert len(evidence["records"]) == 20
    identities = set()
    for item in evidence["records"]:
        identities.add((item["mode"], item["route"]))
        binary = pathlib.Path(item["binary"])
        assert hashlib.sha256(binary.read_bytes()).hexdigest() == item["sha256"]
        replay = doc / item["replay"]
        assert hashlib.sha256(replay.read_bytes()).hexdigest() == item["replay_sha256"]
        data = json.loads(replay.read_text())
        assert data["mode"] == item["mode"] and data["sha256"] == item["sha256"]
        expected_count = 100 if item["mode"].endswith("divide") else 99 if item["mode"].endswith("remainder") else 104
        assert data["total"] == data["passed"] == item["checks"] == expected_count
        rows = data["results"]
        assert len(rows) == len({row["id"] for row in rows}) == expected_count
        assert sum(row["id"].startswith("boundary/") for row in rows) == 81
        for row in rows:
            assert row["passed"] and row["signal"] is None and row["stdout"] == "" and not row.get("error")
            assert row["status"] == row["expected"]["status"]
            assert row["stderr"] == row["expected"]["stderr"]
            assert row["stderr"].endswith(f"ZX_INPUT=-1234567,{row['argv'][0]},3,9,7654321\n")
            if row["status"] == 86:
                assert row["stderr"].startswith(("ZX_PANIC=integer overflow\n", "ZX_PANIC=division by zero\n"))
                assert "ZX_EVENT=after," not in row["stderr"] or (row["id"] == "trap/second-round" or row["id"].startswith("trap/later-error/"))
            if row["id"] in ["trap/zero-outer", "trap/zero-inner"]:
                assert row["status"] == 0 and "ZX_EVENT=" not in row["stderr"]
        assert item["panics"] == sum(row["status"] == 86 for row in rows) > 0
        assert item["application_errors"] == sum(row["stderr"].startswith("ZX_ERROR=") for row in rows) > 0
        for artifact in item["artifacts"]:
            assert hashlib.sha256((doc / artifact["path"]).read_bytes()).hexdigest() == artifact["sha256"]
        checks += data["total"]
        panics += item["panics"]
        errors += item["application_errors"]
    assert len(identities) == 20
assert checks == 4088
regression_checks = 0
for label in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{label}回归证据.json").read_text())
    assert evidence["source_commit"] == freeze["source_commit"]
    assert len(evidence["records"]) == 42 and evidence["checks"] == 1216
    assert hashlib.sha256((doc / evidence["log_path"]).read_bytes()).hexdigest() == evidence["log_sha256"]
    for record in evidence["records"]:
        assert record["exit_code"] == 0
        assert hashlib.sha256(pathlib.Path(record["binary_path"]).read_bytes()).hexdigest() == record["binary_sha256"]
        replay = (doc / record["replay_path"]).read_bytes()
        assert hashlib.sha256(replay).hexdigest() == record["replay_sha256"]
        assert f"All {record['tests']} tests passed.".encode() in replay
        for artifact in record["generated"]:
            assert hashlib.sha256((doc / artifact["path"]).read_bytes()).hexdigest() == artifact["sha256"]
        regression_checks += record["tests"]
assert regression_checks == 2432
print(f"PASS: 6 frozen paths, 124 binary hashes, {checks} process checks, {regression_checks} regression checks, {panics} observed panics, {errors} application errors")
