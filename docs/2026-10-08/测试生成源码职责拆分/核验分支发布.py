from pathlib import Path
import hashlib
import json
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
phase = sys.argv[2]
doc = Path(__file__).resolve().parent
plan = json.loads((doc / "分支发布约束.json").read_text())
baseline = json.loads((doc / "开始基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
main = Path("/Users/xiewendao/Documents/MatrixAges/zxc")
assert hashlib.sha256((main / baseline["foreign_path"]).read_bytes()).hexdigest() == baseline["foreign_sha256"]
assert subprocess.check_output(["git", "-C", str(root), "branch", "--show-current"], text=True).strip() == plan["branch"]

for path in baseline["formal_files"]:
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()

subprocess.run([sys.executable, str(doc / "核验执行证据.py")], check=True)

if phase == "staged":
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip() == plan["parent"]
    actual = set(subprocess.check_output(["git", "-C", str(root), "diff", "--cached", "--name-only", "-z"]).decode().strip("\0").split("\0"))
    revision = ":"
    subprocess.run(["git", "-C", str(root), "diff", "--cached", "--check", "--", *sorted(path for path in expected if not path.endswith((".txt", ".zx")))], check=True)
elif phase == "committed":
    assert not subprocess.check_output(["git", "-C", str(root), "diff", "--cached", "--name-only"])
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD^"], text=True).strip() == plan["parent"]
    assert subprocess.check_output(["git", "-C", str(root), "log", "-1", "--format=%s"], text=True).strip() == plan["commit_subject"]
    actual = set(subprocess.check_output(["git", "-C", str(root), "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"]).decode().strip("\0").split("\0"))
    revision = "HEAD:"
else:
    raise ValueError(phase)

assert actual == expected, (actual - expected, expected - actual)
for path in expected:
    assert subprocess.check_output(["git", "-C", str(root), "show", revision + path]) == (root / path).read_bytes(), path

print("PASS: exact isolated branch publication, frozen execution preserved, original main foreign file unchanged")
