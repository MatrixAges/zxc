from pathlib import Path

import gzip
import hashlib
import json
import subprocess
import sys

doc = Path(__file__).resolve().parent
root = doc.parents[2]
phase = sys.argv[1]
baseline = json.loads((doc / "发布基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
records = root / "docs/2026-10-10/集合复制更新与原输入身份"
sha = lambda data: hashlib.sha256(data).hexdigest()
subprocess.run([sys.executable, str(records / "核验执行证据.py")], check=True)
for name, identity in baseline["protected"].items():
    assert sha((root / name).read_bytes()) == identity, name
for record in json.loads((doc / "压缩结果.json").read_text()):
    data = (records / record["saved"]).read_bytes()
    assert sha(data) == record["gzip_sha256"] and len(data) == record["gzip_bytes"]
    raw = gzip.decompress(data)
    assert sha(raw) == record["raw_sha256"] and len(raw) == record["raw_bytes"]
if phase == "staged":
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == baseline["parent"]
    actual = subprocess.check_output(["git", "diff", "--cached", "--name-only", "-z"], cwd=root)
    revision = ":"
elif phase == "committed":
    assert subprocess.check_output(["git", "rev-parse", "HEAD^"], cwd=root, text=True).strip() == baseline["parent"]
    assert subprocess.check_output(["git", "log", "-1", "--format=%s"], cwd=root, text=True).strip() == "chore(test): compress generated analyzer evidence"
    message = subprocess.check_output(["git", "log", "-1", "--format=%B"], cwd=root, text=True)
    assert message.isascii() and all(len(line) <= 72 for line in message.splitlines())
    assert not subprocess.check_output(["git", "diff", "--cached", "--name-only"], cwd=root)
    actual = subprocess.check_output(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"], cwd=root)
    revision = "HEAD:"
else:
    raise ValueError(phase)
assert set(actual.decode().strip("\0").split("\0")) == expected
for name in expected:
    result = subprocess.run(["git", "show", revision + name], cwd=root, capture_output=True)
    path = root / name
    if path.exists():
        assert result.returncode == 0 and result.stdout == path.read_bytes(), name
    else:
        assert result.returncode != 0, name
print("PASS: lossless compressed evidence, exact publication scope and protected inputs")
