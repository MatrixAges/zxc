from pathlib import Path
import hashlib
import json
import subprocess
import sys

doc = Path(__file__).resolve().parent
root = doc.parents[2]
evidence = json.loads((doc / "规范表达式Safe证据.json").read_text())
status = json.loads((doc / "运行状态.json").read_text())
expected = {str((doc / name).relative_to(root)) for name in ["规范表达式Safe证据.json", "日志/规范表达式Safe.txt", "运行状态.json", "规范表达式Safe终态记录.md", "规范表达式Safe终态核验.py"]}

assert evidence["exit_code"] == 1 and evidence["passed"] is False
assert (evidence["steps_passed"], evidence["steps_total"], evidence["tests_passed"], evidence["tests_total"]) == (6639, 6688, 111781, 111789)
assert status["session_id"] == 55686 and status["terminal"] is True
assert status["source_commit"] == evidence["source_commit"] == "dd909e006261883e88375779c94ada8d4b33c836"
assert status["packages_tree"] == evidence["packages_tree"] == "a7797e6dadb21e0a7522600455dc5e51b9700f2b"
assert hashlib.sha256((doc / evidence["log"]).read_bytes()).hexdigest() == evidence["log_sha256"]
assert len(evidence["logged_zig_test_binaries"]) == 1443

for item in evidence["logged_zig_test_binaries"]:
    assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

assert subprocess.check_output(["git", "-C", status["cwd"], "rev-parse", "HEAD"], text=True).strip() == evidence["source_commit"]
assert subprocess.check_output(["git", "-C", status["cwd"], "diff", "HEAD", "--name-only"]) == b""
foreign = json.loads((doc.parent / "函数列库变异夹具同步/发布前状态.json").read_text())
assert hashlib.sha256((root / foreign["foreign_path"]).read_bytes()).hexdigest() == foreign["foreign_sha256"]

if sys.argv[1] == "staged":
    command = ["git", "diff", "--cached", "--name-only", "-z"]
    subprocess.run(["git", "diff", "--cached", "--check", "--", *sorted(path for path in expected if not path.endswith(".txt"))], check=True)
else:
    command = ["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"]
    assert subprocess.check_output(["git", "diff", "--cached", "--name-only"]) == b""

actual = set(subprocess.check_output(command).decode().strip("\0").split("\0"))
assert actual == expected
print("PASS: historical terminal, log and 1,443 binary identities, exact owned scope, unchanged foreign file")
