from pathlib import Path
import hashlib
import json
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
phase = sys.argv[2]
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "开始基线.json").read_text())
publication = json.loads((doc / "发布基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
sha = lambda data: hashlib.sha256(data).hexdigest()

assert sha((root / baseline["foreign_path"]).read_bytes()) == baseline["foreign_sha256"]

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()

subprocess.run([sys.executable, str(doc / "核验执行证据.py")], check=True)

if phase == "staged":
    actual = set(subprocess.check_output(["git", "-C", str(root), "diff", "--cached", publication["publication_parent"], "--name-only", "-z"]).decode().strip("\0").split("\0"))
    head = subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip()
    if head != publication["publication_parent"]:
        assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD^"], text=True).strip() == publication["publication_parent"]
        assert subprocess.check_output(["git", "-C", str(root), "log", "-1", "--format=%s"], text=True).strip() == "test(native): cover input name column topology"
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "origin/master"], text=True).strip() == publication["publication_parent"]
    revision = ":"
    subprocess.run(["git", "-C", str(root), "diff", "--cached", "--check", "--", *sorted(path for path in expected if not path.endswith(".txt"))], check=True)
elif phase == "committed":
    assert not subprocess.check_output(["git", "-C", str(root), "diff", "--cached", "--name-only"])
    actual = set(subprocess.check_output(["git", "-C", str(root), "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"]).decode().strip("\0").split("\0"))
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD^"], text=True).strip() == publication["publication_parent"]
    message = subprocess.check_output(["git", "-C", str(root), "log", "-1", "--format=%s"], text=True).strip()
    assert message == "test(native): cover input name column topology"
    revision = "HEAD:"
else:
    raise ValueError(phase)

assert actual == expected, (actual - expected, expected - actual)

for path in expected:
    assert subprocess.check_output(["git", "-C", str(root), "show", revision + path]) == (root / path).read_bytes(), path

for path in publication["remote_only_paths"]:
    tracked = subprocess.check_output(["git", "-C", str(root), "ls-tree", "-z", publication["publication_parent"], "--", path])
    if tracked:
        assert (root / path).read_bytes() == subprocess.check_output(["git", "-C", str(root), "show", publication["publication_parent"] + ":" + path]), path
    else:
        assert not (root / path).exists(), path

print("PASS: exact publication scope, exact draft identities, foreign file and parallel implementation paths preserved")
