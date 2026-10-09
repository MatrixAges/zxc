from pathlib import Path

import hashlib
import json
import subprocess
import sys

doc = Path(__file__).resolve().parent
main = doc.parents[2]

phase = sys.argv[1]
inputs = json.loads((doc / "执行输入.json").read_text())
baseline = json.loads((doc / "发布基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
sha = lambda data: hashlib.sha256(data).hexdigest()

subprocess.run([sys.executable, str(doc / "核验执行证据.py")], check=True)

for group in ["protected_inputs", "protected_root_inputs", "foreign_inputs"]:
    for name, identity in baseline[group].items():
        assert sha((main / name).read_bytes()) == identity, name

for name in inputs["formal"]:
    assert (main / name).read_bytes() == (doc / "草稿" / name).read_bytes(), name

if phase == "staged":
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=main, text=True).strip() == baseline["parent"]

    paths = subprocess.check_output(["git", "diff", "--cached", "--name-only", "-z"], cwd=main)
    revision = ":"

elif phase == "committed":
    assert subprocess.check_output(["git", "rev-parse", "HEAD^"], cwd=main, text=True).strip() == baseline["parent"]
    assert subprocess.check_output(["git", "log", "-1", "--format=%s"], cwd=main, text=True).strip() == "test(rx): verify parallel floating capture and result lifetimes"
    message = subprocess.check_output(["git", "log", "-1", "--format=%B"], cwd=main, text=True)
    assert message.isascii(), "commit title and body must be English"
    assert all(len(line) <= 72 for line in message.splitlines()), "wrap commit text at 72 columns"
    assert not subprocess.check_output(["git", "diff", "--cached", "--name-only"], cwd=main)

    paths = subprocess.check_output(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"], cwd=main)
    revision = "HEAD:"
else:
    raise ValueError(phase)

actual = set(paths.decode().strip("\0").split("\0"))
assert actual == expected, (actual - expected, expected - actual)

for name in expected:
    assert subprocess.check_output(["git", "show", revision + name], cwd=main) == (main / name).read_bytes(), name

print("PASS: exact owned publication scope, executed test bytes and protected inputs")
