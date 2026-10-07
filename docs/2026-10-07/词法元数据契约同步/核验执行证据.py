from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
freeze = json.loads((doc / "输入冻结.json").read_text())
data = (root / freeze["path"]).read_bytes()
assert hashlib.sha256(data).hexdigest() == freeze["sha256"]
assert data == (doc / "草稿" / freeze["path"]).read_bytes()
words = json.loads((doc / "词表保持证据.json").read_text())
assert len(words["current_words"]) == words["word_count"]
assert len(words["original_words"]) == words["word_count"]
assert set(words["current_words"]) == set(words["original_words"])
original = json.loads((doc / "原门禁参数.json").read_text())
scanner = (doc / "生成物/扫描器.zig.txt").read_bytes()
assert hashlib.sha256(scanner).hexdigest() == original["scanner_sha256"]
assert scanner == Path(original["scanner"]).read_bytes()
binaries = set()
checks = 0

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / f"{mode}执行证据.json").read_text())
    assert evidence["source_commit"] == original["source_commit"]
    assert evidence["scanner_sha256"] == original["scanner_sha256"]
    assert evidence["checks"] == 11 and len(evidence["records"]) == 5
    assert {row["group"] for row in evidence["records"]} == {"boundaries", "words", "symbols", "templates", "resources"}

    for item in evidence["sources"]:
        assert hashlib.sha256((doc / item["path"]).read_bytes()).hexdigest() == item["sha256"]

    for row in evidence["records"]:
        assert row["build_exit_code"] == row["run_exit_code"] == 0
        assert row["binary"] not in binaries
        binaries.add(row["binary"])
        assert hashlib.sha256(Path(row["binary"]).read_bytes()).hexdigest() == row["binary_sha256"]
        for name in ["log", "build_log"]:
            assert hashlib.sha256((doc / row[name]).read_bytes()).hexdigest() == row[name + "_sha256"]
        assert f"All {row['checks']} tests passed.".encode() in (doc / row["log"]).read_bytes()
        checks += row["checks"]

assert checks == 22 and len(binaries) == 10
print("PASS: one exact source; all original words retained; ten binaries and 22 scanner checks passed")
