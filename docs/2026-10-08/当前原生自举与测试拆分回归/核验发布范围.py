from pathlib import Path
import hashlib
import json
import subprocess
import sys


root = Path(sys.argv[1]).resolve()
phase = sys.argv[2]
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "执行输入.json").read_text())
publication = json.loads((doc / "发布基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
sha = lambda data: hashlib.sha256(data).hexdigest()
assert sha((root / publication["foreign_path"]).read_bytes()) == publication["foreign_sha256"]
subprocess.run([sys.executable, str(doc / "核验执行证据.py")], check=True)

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes(), path

for path in publication["parallel_paths"]:
    previous = subprocess.check_output(["git", "ls-tree", "-z", publication["parent"], "--", path], cwd=root)
    if previous:
        assert (root / path).read_bytes() == subprocess.check_output(["git", "show", publication["parent"] + ":" + path], cwd=root), path
    else:
        assert not (root / path).exists(), path

if phase == "staged":
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == publication["parent"]
    actual = set(subprocess.check_output(["git", "diff", "--cached", "--name-only", "-z"], cwd=root).decode().strip("\0").split("\0"))
    revision = ":"
elif phase == "committed":
    assert subprocess.check_output(["git", "rev-parse", "HEAD^"], cwd=root, text=True).strip() == publication["parent"]
    assert subprocess.check_output(["git", "log", "-1", "--format=%s"], cwd=root, text=True).strip() == "test(conformance): verify native bootstrap and split fixtures"
    assert not subprocess.check_output(["git", "diff", "--cached", "--name-only"], cwd=root)
    actual = set(subprocess.check_output(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"], cwd=root).decode().strip("\0").split("\0"))
    revision = "HEAD:"
else:
    raise ValueError(phase)

assert actual == expected, (actual - expected, expected - actual)

for path in expected:
    assert subprocess.check_output(["git", "show", revision + path], cwd=root) == (root / path).read_bytes(), path

print("PASS: exact owned publication scope and executed draft bytes; parallel implementation and foreign file preserved.")
