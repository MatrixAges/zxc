from pathlib import Path
import hashlib
import json
import subprocess
import sys

doc = Path(__file__).resolve().parent
root = doc.parents[2]
names = [
    "修复后完整Debug证据.json", "日志/修复后完整Debug.txt",
    "修复后完整ReleaseSafe证据.json", "日志/修复后完整ReleaseSafe.txt",
    "修复后完整Debug运行状态.json", "修复后完整ReleaseSafe运行状态.json",
    "修复后完整回归终态记录.md", "修复后完整回归终态核验.py",
]
expected = {str((doc / name).relative_to(root)) for name in names}
specifications = {
    "Debug": (1804, "9f2979bfca5abd9d976d8cad037e765daebd9478", 6780, 6784, 111546, 111546, 1434),
    "ReleaseSafe": (17752, "37d534314aa8027863ecd497d1c0d4e8b6787b0d", 6654, 6688, 111784, 111793, 1444),
}

for mode, spec in specifications.items():
    session, commit, steps_passed, steps_total, tests_passed, tests_total, binary_count = spec
    evidence = json.loads((doc / f"修复后完整{mode}证据.json").read_text())
    state = json.loads((doc / f"修复后完整{mode}运行状态.json").read_text())

    assert evidence["exit_code"] == 1 and evidence["passed"] is False
    assert state["status"] == "terminal" and state["terminal"] is True
    assert state["session_id"] == session and state["exit_code"] == 1
    assert state["source_commit"] == evidence["source_commit"] == commit
    assert (evidence["steps_passed"], evidence["steps_total"], evidence["tests_passed"], evidence["tests_total"]) == (steps_passed, steps_total, tests_passed, tests_total)
    assert hashlib.sha256((doc / evidence["log"]).read_bytes()).hexdigest() == evidence["log_sha256"]
    assert len(evidence["logged_zig_test_binaries"]) == binary_count
    assert subprocess.check_output(["git", "-C", state["worktree"], "rev-parse", "HEAD"], text=True).strip() == commit
    assert subprocess.check_output(["git", "-C", state["worktree"], "rev-parse", "HEAD:packages"], text=True).strip() == evidence["packages_tree"] == state["packages_tree"]
    assert subprocess.check_output(["git", "-C", state["worktree"], "diff", "HEAD", "--name-only"]) == b""

    for item in evidence["logged_zig_test_binaries"]:
        assert hashlib.sha256(Path(item["path"]).read_bytes()).hexdigest() == item["sha256"]

foreign = json.loads((doc.parent / "Yield对象简写原例覆盖/发布前状态.json").read_text())
assert hashlib.sha256((root / foreign["foreign_path"]).read_bytes()).hexdigest() == foreign["foreign_sha256"]

if sys.argv[1] == "staged":
    command = ["git", "diff", "--cached", "--name-only", "-z"]
    subprocess.run(["git", "diff", "--cached", "--check", "--", *sorted(path for path in expected if not path.endswith(".txt"))], check=True)
    assert subprocess.check_output(["git", "rev-parse", "HEAD"]) == subprocess.check_output(["git", "rev-parse", "origin/master"])
else:
    command = ["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD", "-z"]
    assert subprocess.check_output(["git", "diff", "--cached", "--name-only"]) == b""
    assert subprocess.check_output(["git", "rev-parse", "HEAD^"]) == subprocess.check_output(["git", "rev-parse", "origin/master"])

actual = set(subprocess.check_output(command).decode().strip("\0").split("\0"))
assert actual == expected
print("PASS: both actual terminals, fixed inputs, 2,878 binary identities, exact eight owned paths and original foreign bytes")
