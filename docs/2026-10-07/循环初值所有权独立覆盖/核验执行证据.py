from pathlib import Path
import hashlib
import json
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())

subprocess.run([sys.executable, str(doc / "核验新门禁证据.py"), str(root)], check=True)

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / ("原循环" + mode + "证据.json")).read_text())

    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["packages_tree"] == baseline["packages_tree"]
    assert evidence["exit_code"] == 0 and evidence["passed"] is True
    assert evidence["steps_passed"] == evidence["steps_total"] == 245
    assert evidence["tests_passed"] == evidence["tests_total"] == 411
    assert evidence["errors"] == []

    binaries = evidence["logged_zig_test_binaries"]
    names = [Path(item["path"]).name for item in binaries]
    expected = {f"{prefix}-{name}-{route}" for prefix, modes in [("iterate-calls", ["identity", "child", "pair", "branch_return", "tuple_identity", "list_alias"]), ("aggregate-loop", ["stack", "nested", "two_lanes", "bounds", "old_list", "call", "escaping", "consumer"]), ("loop-columns", ["mixed", "direct", "borrowed", "shrink", "nested", "dual", "leaves", "consumer", "fallback"])] for name in modes for route in ["source", "library"]}

    assert len(binaries) == len({item["path"] for item in binaries}) == 58
    assert set(names) == expected | {"test"}
    assert names.count("test") == 12

    raw = (doc / evidence["log"]).read_bytes()

    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert "✔ loop public library relocation and compiled manifest republication preserve returned aliases" in raw.decode()
    assert "ℹ tests 1" in raw.decode() and "ℹ pass 1" in raw.decode() and "ℹ fail 0" in raw.decode()

    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

    for item in evidence["artifacts"]:
        data = (doc / item["saved"]).read_bytes()
        assert hashlib.sha256(data).hexdigest() == item["sha256"]
        assert Path(item["executed_source"]).read_bytes() == data

observation = json.loads((doc / "分配观察证据.json").read_text())
assert hashlib.sha256((doc / "分配观察.zig.txt").read_bytes()).hexdigest() == observation["observer_source_sha256"]
assert hashlib.sha256((doc / "分配观察日志.txt").read_bytes()).hexdigest() == observation["log_sha256"]
raw = (doc / "分配观察日志.txt").read_text()
assert "rounds=1 forbid_resize=false bytes=467738" in raw
assert "rounds=1 forbid_resize=false bytes=1025846" in raw
assert raw.count("bytes=679824 allocations=7 resizes=0 capacity=679656") == 6

print("PASS: 256 new checks, 822 original loop checks, both original CLI relocation blocks; all evidence corresponds to one frozen package input set")
