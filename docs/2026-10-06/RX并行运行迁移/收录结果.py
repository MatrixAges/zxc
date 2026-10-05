import hashlib
import json
import re
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[3]
base = Path(__file__).resolve().parent
worktree = Path("/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc")
fixed = json.loads((base / "固定检出指纹.json").read_text())
paths = list(fixed["sha256"])


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for name, expected in fixed["sha256"].items():
    assert sha(root / name) == sha(worktree / name) == expected, name

assert subprocess.check_output(
    ["git", "diff", "--name-only", "--", "packages/compiler", "packages/core", "packages/genz"],
    cwd=worktree,
    text=True,
) == ""

resources = subprocess.check_output(
    ["git", "ls-files", "--", "packages/test/tests/rx/runtime/parallel", "packages/test/tests/rx/support/collections"],
    cwd=root,
    text=True,
).splitlines()
resources += [
    "packages/test/tests/rx/runtime/fixtures/first.zx",
    "packages/test/tests/rx/runtime/fixtures/map_values.zx",
    "packages/test/tests/support/allocation_testing.zig",
]
sources = sorted(set(paths + resources))

for name in sources:
    assert sha(root / name) == sha(worktree / name), name

report = {
    "固定生产提交": fixed["固定生产提交"],
    "构建入口": "test-rx-parallel",
    "正式修改文件": paths,
    "正式源文件数": len(paths),
    "材料种类": 22,
    "每种来源与库路由数": 9,
    "运行路径数": 198,
    "不同Zig声明数": 39,
    "模式": {},
    "源指纹": {name: sha(root / name) for name in sources},
    "边界": "39份既有声明沿22种材料和9条路由重复执行；未新增Test262，不覆盖新增ZX特性",
    "生产缺陷反馈": "没有新生产缺陷；已有void命名缺陷使用修复后0d0f8409基线",
}

for mode in ["Debug", "ReleaseSafe"]:
    log = base / f"固定检出{mode}日志.txt"
    log.write_bytes(log.read_bytes().rstrip(b"\n") + b"\n")
    source = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", source)

    assert summary and list(map(int, summary.groups())) == [1155, 1155, 927, 927]

    actual = sum(map(int, re.findall(r"run test (\d+) pass", source)))
    runs = len(re.findall(r"run test \d+ pass", source))
    cached = len(re.findall(r"run test cached", source))

    assert actual == 927 and runs == 198 and cached == 0

    report["模式"][mode] = {
        "退出码": 0,
        "构建步骤": 1155,
        "通过Zig声明": 927,
        "实际执行Zig声明": actual,
        "实际运行步": runs,
        "缓存运行步": cached,
        "日志": str(log.relative_to(root)),
    }

report["证据指纹"] = {
    str(path.relative_to(root)): sha(path)
    for path in sorted(base.iterdir())
    if path.is_file() and path.name != "结果.json"
}
(base / "结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")

print(json.dumps({"正式源": len(paths), "指纹源": len(sources), "模式": report["模式"]}, ensure_ascii=False))
