from pathlib import Path
import hashlib
import json
import subprocess
import sys


root = Path(sys.argv[1]).resolve()
phase = sys.argv[2]
doc = Path(__file__).resolve().parent
publication = json.loads((doc / "发布基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
sha = lambda data: hashlib.sha256(data).hexdigest()
subprocess.run([sys.executable, str(doc / "核验审查证据.py")], check=True)

for path, identity in publication["protected_inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path

for path, identity in publication["foreign_inputs"].items():
    assert sha((root / path).read_bytes()) == identity, path

if phase == "staged":
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == publication["parent"]
    paths = subprocess.check_output(["git", "diff", "--cached", "--name-only", "-z"], cwd=root)
    revision = ":"
elif phase == "committed":
    assert subprocess.check_output(["git", "rev-parse", "HEAD^"], cwd=root, text=True).strip() == publication["parent"]
    assert subprocess.check_output(["git", "log", "-1", "--format=%s"], cwd=root, text=True).strip() == "test(upstream): record dynamic callback identity boundaries"
    assert not subprocess.check_output(["git", "diff", "--cached", "--name-only"], cwd=root)
    paths = subprocess.check_output(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"], cwd=root)
    revision = "HEAD:"
else:
    raise ValueError(phase)

actual = set(paths.decode().strip("\0").split("\0"))
assert actual == expected, (actual - expected, expected - actual)

for path in expected:
    assert subprocess.check_output(["git", "show", revision + path], cwd=root) == (root / path).read_bytes(), path

print("PASS: exact review scope and all protected package and foreign inputs preserved")
