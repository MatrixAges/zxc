import hashlib
import json
import re
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[3]
base = Path(__file__).resolve().parent
worktree = Path("/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc")
fixed = json.loads((base / "固定检出指纹.json").read_text())
manifest = json.loads((base / "迁移清单.json").read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for name, expected in fixed["sha256"].items():
    assert sha(root / name) == sha(worktree / name) == expected, name

assert subprocess.check_output(
    ["git", "diff", "--name-only", "--", "packages/compiler", "packages/core", "packages/genz"],
    cwd=worktree,
    text=True,
) == ""

report = {
    "固定生产提交": fixed["固定生产提交"],
    "构建入口": "test-rx-attributes",
    "正式修改文件": manifest["正式文件"],
    "解析声明数": 70,
    "Schema声明数": 78,
    "Schema行调整数": 6,
    "CLI应用执行数": 55,
    "CLI拒绝数": 6,
    "模式": {},
    "源指纹": fixed["sha256"],
    "边界": "API清理及真实CLI执行；结构接受不代替推导；未新增Test262案例",
    "生产缺陷反馈": "没有新生产缺陷，不向实现会话发送通过消息",
}

for mode, tag in [("Debug", "debug"), ("ReleaseSafe", "safe")]:
    log = base / f"固定检出{mode}日志.txt"
    log.write_bytes(log.read_bytes().rstrip(b"\n") + b"\n")
    source = log.read_text()
    summary = re.search(r"Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed", source)

    assert summary and list(map(int, summary.groups())) == [22, 22, 148, 148]
    assert f"55 RX attribute executions passed ({tag})" in source
    assert "6 RX attribute semantic rejection cases passed" in source

    actual = sum(map(int, re.findall(r"run test (\d+) pass", source)))
    cached = len(re.findall(r"run test cached", source))

    assert actual == 148 and cached == 0

    report["模式"][mode] = {
        "退出码": 0,
        "构建步骤": 22,
        "通过Zig声明": 148,
        "实际执行Zig声明": actual,
        "缓存运行步": cached,
        "CLI应用实际执行": 55,
        "CLI应用优化标记": tag,
        "CLI语义拒绝": 6,
        "日志": str(log.relative_to(root)),
    }

report["证据指纹"] = {
    str(path.relative_to(root)): sha(path)
    for path in sorted(base.iterdir())
    if path.is_file() and path.name != "结果.json"
}
(base / "结果.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")

print(json.dumps(report["模式"], ensure_ascii=False))
