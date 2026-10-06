import hashlib
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
WORKTREE = Path('/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc')
BASELINE = 'ae31a16cac36f32f0f2e053c17869e5479bb216d'


def git(*args):
    return subprocess.check_output(['git', '-C', str(WORKTREE), *args], text=True).strip()


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


paths = ['packages/test/build.zig', 'packages/test/build/tasks.zig']
paths += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/tasks/analysis').glob('*.zig'))

assert len(paths) == 7
assert git('rev-parse', 'HEAD') == BASELINE
assert not git('status', '--porcelain', '--', 'packages/compiler', 'packages/core', 'packages/genz')

counts = {}

for group, expected in [('shape', 12), ('acceptance', 15), ('rejection', 24), ('allocation', 3)]:
    path = ROOT / f'packages/test/tests/language/expressions/tasks/analysis/{group}_test.zig'
    count = len(re.findall(r'^test "', path.read_text(), re.MULTILINE))
    assert count == expected
    counts[group] = count

sources = {}

for name in paths:
    sources[name] = fingerprint(ROOT / name)
    assert sources[name] == fingerprint(WORKTREE / name), name
    assert sources[name] == fingerprint(DIRECTORY / '草稿' / name), name

modes = {}

for mode in ['Debug', 'ReleaseSafe']:
    log = DIRECTORY / f'{mode}最终日志.txt'
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and int(summary[1]) == int(summary[2]) == 19
    assert int(summary[3]) == int(summary[4]) == 54
    assert 'failure' not in text
    runs = [int(value) for value in re.findall(r'run test (\d+) pass', text)]
    assert runs == [12, 15, 24, 3]
    cached = len(re.findall(r'run test.*cached', text))
    assert cached == 0
    modes[mode] = {'退出码': 0, '成功构建步骤': 19, '实际执行声明': sum(runs), '运行缓存步': cached, '日志': str(log.relative_to(ROOT))}

evidence = {}

for path in sorted(DIRECTORY.rglob('*')):
    if path.is_file() and path.name != '结果.json':
        evidence[str(path.relative_to(ROOT))] = fingerprint(path)

report = {
    '验证检出': BASELINE,
    '独立Zig源码声明数': sum(counts.values()),
    '分类': counts,
    '正式修改文件': paths,
    '模式': modes,
    '源指纹': sources,
    '证据指纹': evidence,
    '生产缺陷': '独立void await语句被前端拒绝；已向实现会话反馈，ae31a16c修复后通过原语义测试',
    '边界': '公开项目分析及独立IR校验；不代替实际IO并发、退出等待或显式cancel运行证据；未新增Test262条目',
}

(DIRECTORY / '结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(modes, ensure_ascii=False))
