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

names = [
    "contract revalidation with reversed export order false",
    "contract revalidation with reversed export order true",
    "valid digest cannot bypass compiled public contract verification or replace a valid publication",
    "RX cannot call a public bare transaction",
    "ZX cannot call a public bare transaction",
    "source package cannot act as a compiled module",
    "missing all initializers remains loadable but cannot start Store app",
    "missing counter initializers remains loadable but cannot start Store app",
    "unused settings omitted",
    "all declarations restored",
    "compiled Store transaction authorization and required initializers remain separate boundaries",
]

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((doc / ("库" + mode + "证据.json")).read_text())
    raw = (doc / evidence["log"]).read_bytes()

    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["source_commit"] == baseline["source_commit"]
    assert evidence["exit_code"] == 0
    assert evidence["steps_passed"] == evidence["steps_total"] == 33
    assert evidence["node_test_counts"] == evidence["node_pass_counts"] == [3, 8]
    assert evidence["node_fail_counts"] == [0, 0]
    passed = re.findall(r"^\s*✔ (.+?) \([\d.]+ms\)$", raw.decode(), re.M)
    assert passed == names, passed
    assert len(evidence["cli_binaries"]) == 1

    for path, sha in evidence["cli_binaries"].items():
        assert hashlib.sha256(Path(path).read_bytes()).hexdigest() == sha

for label, code, count in [("构建模式原超时", 1, 2), ("单独安装观察", 0, 42), ("构建模式缓存复验", 0, 2)]:
    evidence = json.loads((doc / (label + "证据.json")).read_text())
    raw = (doc / evidence["log"]).read_bytes()

    assert hashlib.sha256(raw).hexdigest() == evidence["log_sha256"]
    assert evidence["exit_code"] == code and evidence["steps_total"] == count

    if code == 0:
        assert evidence["steps_passed"] == count
    else:
        assert "spawnSync zig ETIMEDOUT" in raw.decode()

    if label == "构建模式缓存复验":
        assert "Build modes: app, relocated Zig library and relocated ZX library passed" in raw.decode()

whole_doc = doc.parent / "规范表达式列全量回归"
whole = json.loads((whole_doc / "函数列后Debug证据.json").read_text())
assert whole["source_commit"] == "a73d056c549876372d852e3670f7328243f0c753"
assert whole["exit_code"] == 1
assert (whole["steps_passed"], whole["steps_total"], whole["tests_passed"], whole["tests_total"]) == (6681, 6693, 111377, 111381)
assert hashlib.sha256((whole_doc / whole["log"]).read_bytes()).hexdigest() == whole["log_sha256"]

for item in whole["logged_zig_test_binaries"]:
    assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

print("PASS: frozen package inputs, 22 original library checks, installation timeout and unchanged warm gate, historical full Debug evidence")
