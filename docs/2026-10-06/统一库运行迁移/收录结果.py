import hashlib
import json
import re
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[3]
base = Path(__file__).resolve().parent
worktree = Path("/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc")
fixed = json.loads((base / "固定检出指纹.json").read_text())
before = json.loads((base / "模式修正前指纹.json").read_text())
paths = list(fixed["sha256"])


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for name, expected in fixed["sha256"].items():
    assert sha(root / name) == sha(worktree / name) == expected, name

for name, expected in before["sha256"].items():
    assert sha(root / name) == expected, name

assert subprocess.check_output(
    ["git", "diff", "--name-only", "--", "packages/compiler", "packages/core", "packages/genz"],
    cwd=worktree,
    text=True,
) == ""

resources = subprocess.check_output(
    ["git", "ls-files", "--", "packages/test/tests/library", "packages/test/tests/support/allocation_testing.zig"],
    cwd=root,
    text=True,
).splitlines()
sources = sorted(set(paths + resources))

for name in sources:
    assert sha(root / name) == sha(worktree / name), name

report = {
    "固定生产提交": fixed["固定生产提交"],
    "构建入口": ["test-library-link", "test-library-initializers", "test-library-runtime"],
    "正式修改文件": paths,
    "源指纹": {name: sha(root / name) for name in sources},
    "模式": {},
    "边界": "统一库内部消费与重放；不替代CLI发行全量回归，不计作新增Test262",
    "生产缺陷反馈": "没有新生产缺陷；本部分修正测试消费者未显式传优化模式的问题",
}

for log in base.glob("*日志.txt"):
    log.write_bytes(log.read_bytes().rstrip(b"\n") + b"\n")

old_log = base / "Debug模式修正前日志.txt"
old_source = old_log.read_text()

assert "Build Summary: 101/101 steps succeeded; 68/68 tests passed" in old_source
assert sum(map(int, re.findall(r"run test (\d+) pass", old_source))) == 68

report["Debug同源码API实际执行证据"] = {
    "实际执行Zig声明": 68,
    "日志": str(old_log.relative_to(root)),
    "说明": "五份调用材料与最终一致；之后仅修正消费者模式接线，API运行步复用缓存",
}

for mode, tag in [("Debug", "debug"), ("ReleaseSafe", "safe")]:
    log = base / f"固定检出{mode}日志.txt"
    source = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded", source)
    actual = sum(map(int, re.findall(r"run test (\d+) pass", source)))
    cached = len(re.findall(r"run test cached", source))
    external = sum(map(int, re.findall(r"All (\d+) tests passed\.", source)))
    groups = len(re.findall(r"ℹ tests 1\n", source))
    explicit = len(re.findall(r"unified library runtime consumer .*\(" + tag + r"\)", source))

    assert summary and list(map(int, summary.groups())) == [101, 101]
    assert external == 108 and groups == explicit == 22
    assert (actual, cached) == ((0, 12) if mode == "Debug" else (68, 0))

    report["模式"][mode] = {
        "退出码": 0,
        "构建步骤": 101,
        "API实际执行Zig声明": actual,
        "API缓存运行步": cached,
        "外部Node组实际执行": groups,
        "外部Zig声明实际执行": external,
        "外部消费者优化模式": tag,
        "日志": str(log.relative_to(root)),
    }

report["证据指纹"] = {
    str(path.relative_to(root)): sha(path)
    for path in sorted(base.iterdir())
    if path.is_file() and path.name != "结果.json"
}
(base / "结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")

print(json.dumps({"正式源": len(paths), "指纹源": len(sources), "模式": report["模式"]}, ensure_ascii=False))
