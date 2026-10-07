from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "输入冻结.json").read_text())
assert len(freeze["paths"]) == 3
for item in freeze["paths"]:
    data = (root / item["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == item["sha256"], item["path"]
    assert data == (doc / "草稿" / item["path"]).read_bytes()
outputs = json.loads((doc / "原输出冻结.json").read_text())
assert len(outputs) == 14 and sum(item.get("cases", 0) for item in outputs) == 459
for item in outputs:
    assert hashlib.sha256((root / item["path"]).read_bytes()).hexdigest() == item["sha256"], item["path"]
generators = json.loads((doc / "生成器核验.json").read_text())
assert len(generators) == 3 and all(row["exit_code"] == 0 for row in generators)

binaries = set()
checks = 0
for label in ["Debug", "ReleaseSafe"]:
    for group, count in [("所有权", 428), ("分支类型", 11), ("可选类型", 12)]:
        evidence = json.loads((doc / f"{label}-{group}证据.json").read_text())
        assert evidence["source_commit"] == freeze["source_commit"] and evidence["checks"] == count
        assert len(evidence["records"]) == (5 if group == "所有权" else 1)
        for item in evidence["records"]:
            assert item["binary"] not in binaries
            binaries.add(item["binary"])
            assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["sha256"]
            replay = (doc / item["replay"]).read_bytes()
            assert hashlib.sha256(replay).hexdigest() == item["replay_sha256"]
            assert f"All {item['checks']} tests passed.".encode() in replay
            for artifact in item["artifacts"]:
                data = (doc / artifact["path"]).read_bytes()
                assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
                assert data == Path(artifact["executed_source"]).read_bytes()
            checks += item["checks"]
optional = json.loads((doc / "可选枚举执行证据.json").read_text())
assert optional["source_commit"] == freeze["source_commit"] and optional["independent_checks"] == 32
assert hashlib.sha256(Path(optional["cli"]).read_bytes()).hexdigest() == optional["cli_sha256"]
assert all(row["exit_code"] == 0 for row in optional["records"])
for item in optional["records"]:
    if "binary" not in item:
        continue
    assert item["binary"] not in binaries and item["checks"] == 16
    binaries.add(item["binary"])
    assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["sha256"]
    replay = (doc / item["replay"]).read_bytes()
    assert hashlib.sha256(replay).hexdigest() == item["replay_sha256"] and b"All 16 tests passed." in replay
    checks += item["checks"]
for artifact in optional["artifacts"]:
    data = (doc / artifact["path"]).read_bytes()
    assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
    assert data == Path(artifact["executed_source"]).read_bytes()
assert len(binaries) == 16 and checks == 934
reduce = json.loads((doc / "归约修复复验证据.json").read_text())
assert reduce["production_fix"] == freeze["publication_parent"] and reduce["independent_checks"] == 224
reduce_binaries = set()
reduce_checks = 0
assert {mode["label"] for mode in reduce["modes"]} == {"Debug", "ReleaseSafe"}
for mode in reduce["modes"]:
    assert mode["source_commit"] == reduce["production_fix"] and len(mode["records"]) == 8
    log = (doc / mode["log"]).read_bytes()
    assert hashlib.sha256(log).hexdigest() == mode["log_sha256"]
    assert b"62/62 steps succeeded; 112/112 tests passed" in log
    for item in mode["records"]:
        assert item["binary"] not in reduce_binaries
        reduce_binaries.add(item["binary"])
        assert hashlib.sha256(Path(item["binary"]).read_bytes()).hexdigest() == item["sha256"]
        replay = (doc / item["replay"]).read_bytes()
        assert hashlib.sha256(replay).hexdigest() == item["replay_sha256"]
        assert f"All {item['checks']} tests passed.".encode() in replay
        artifact = item["artifact"]
        data = (doc / artifact["path"]).read_bytes()
        assert hashlib.sha256(data).hexdigest() == artifact["sha256"]
        assert data == Path(artifact["executed_source"]).read_bytes()
        reduce_checks += item["checks"]
assert len(reduce_binaries) == 16 and reduce_checks == 224
print("PASS: three frozen generators, 14 unchanged outputs / 459 cases, 934 generator-related checks; fixed production reduce independently passes 224 checks")
