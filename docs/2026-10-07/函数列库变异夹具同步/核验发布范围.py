from pathlib import Path
import hashlib
import json
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
phase = sys.argv[2]
doc = Path(__file__).resolve().parent
baseline = json.loads((doc / "发布前状态.json").read_text())
publication = json.loads((doc / "发布基线.json").read_text())
expected = set(json.loads((doc / "提交文件清单.json").read_text()))
foreign = root / baseline["foreign_path"]

assert hashlib.sha256(foreign.read_bytes()).hexdigest() == baseline["foreign_sha256"]

frozen = {item["path"]: item["sha256"] for item in json.loads((doc / "开始基线.json").read_text())["inputs"]}

for path in json.loads((doc / "正式文件清单.json").read_text()):
    assert (root / path).read_bytes() == (doc / "代码草稿" / path).read_bytes()
    assert hashlib.sha256((root / path).read_bytes()).hexdigest() == frozen[path]

subprocess.run([sys.executable, str(doc / "核验执行证据.py"), publication["source_snapshot"]], check=True)

if phase == "staged":
    actual = set(subprocess.check_output(["git", "-C", str(root), "diff", "--cached", "--name-only", "-z"]).decode().strip("\0").split("\0"))
    assert actual == expected
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], text=True).strip() == publication["publication_parent"]
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "origin/master"], text=True).strip() == publication["publication_parent"]
    text_paths = sorted(path for path in expected if not path.endswith(".txt"))
    subprocess.run(["git", "-C", str(root), "diff", "--cached", "--check", "--", *text_paths], check=True)
elif phase == "committed":
    assert subprocess.check_output(["git", "-C", str(root), "diff", "--cached", "--name-only"]) == b""
    actual = set(subprocess.check_output(["git", "-C", str(root), "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"]).decode().strip("\0").split("\0"))
    assert actual == expected
    assert subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD^"], text=True).strip() == publication["publication_parent"]
else:
    raise ValueError(phase)

for path in publication["remote_only_paths"]:
    expected_bytes = subprocess.check_output(["git", "-C", str(root), "show", publication["publication_parent"] + ":" + path])
    assert (root / path).read_bytes() == expected_bytes

print("PASS: exact owned publication scope, draft/source identity, original foreign file and executable evidence")
