import hashlib
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
WORKTREE = Path('/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc')
BASELINE = '2617ae6e'
GROUPS = {'cancel': 2, 'scope_exit': 2, 'early_return': 1, 'caller_error': 1, 'block_exit': 1, 'completed': 2, 'direct': 2, 'cleanup': 2}


def git(*args):
    return subprocess.check_output(['git', '-C', str(WORKTREE), *args], text=True).strip()


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


paths = ['packages/test/build/tasks.zig', 'packages/test/build/tasks_lifecycle.zig']
paths += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/tasks/runtime/lifecycle').rglob('*') if path.is_file())

assert len(paths) == 24
assert git('rev-parse', 'HEAD') == git('rev-parse', BASELINE)
assert not git('status', '--porcelain', '--', 'packages/compiler', 'packages/core', 'packages/genz')

for group, expected in GROUPS.items():
    path = ROOT / f'packages/test/tests/language/expressions/tasks/runtime/lifecycle/{group}/execution_test.zig'
    assert len(re.findall(r'^test "', path.read_text(), re.MULTILINE)) == expected

invocations = 0
inline_calls = 0
completed_starts = 0

for group in GROUPS:
    source = (ROOT / f'packages/test/tests/language/expressions/tasks/runtime/lifecycle/{group}/execution_test.zig').read_text()
    invocations += source.count('check.run(')
    inline_calls += source.count('.mode = .inline_execution')
    completed_starts += source.count('.completed_start = true')

assert invocations == 15 and inline_calls == 2 and completed_starts == 4

sources = {}

for name in paths + ['packages/test/build.zig']:
    sources[name] = fingerprint(ROOT / name)
    assert sources[name] == fingerprint(WORKTREE / name), name
    if name in paths:
        assert sources[name] == fingerprint(DIRECTORY / '草稿' / name), name

modes = {}

for mode in ['Debug', 'ReleaseSafe']:
    log = DIRECTORY / f'{mode}日志.txt'
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and int(summary[1]) == int(summary[2]) == 36
    assert int(summary[3]) == int(summary[4]) == 13
    assert 'failure' not in text
    runs = dict((name, int(count)) for name, count in re.findall(r'run test zx-lifecycle-(\S+) (\d+) pass', text))
    assert runs == GROUPS, runs
    cached = len(re.findall(r'run test zx-lifecycle-\S+ cached', text))
    assert cached == 0
    modes[mode] = {'退出码': 0, '成功构建步骤': 36, '实际执行声明': sum(runs.values()), '内联同步完成应用执行次数': 2, '线程应用执行次数': 13, '应用执行总次数': 15, '运行缓存步': cached, '日志': str(log.relative_to(ROOT))}

evidence = {}

for path in sorted(DIRECTORY.rglob('*')):
    if path.is_file() and path.name != '结果.json':
        evidence[str(path.relative_to(ROOT))] = fingerprint(path)

report = {
    '验证检出': git('rev-parse', 'HEAD'),
    '生产功能提交': git('rev-parse', 'ae31a16c'),
    '独立Zig源码声明数': sum(GROUPS.values()),
    '分类': GROUPS,
    '正式修改文件': paths,
    '模式': modes,
    '源指纹': sources,
    '证据指纹': evidence,
    '边界': '13个独立声明、15次应用执行；事件与原子探针在宿主销毁前验证取消/结束/调用者结果；completed组通过标准Io同步完成契约，委派真实Threaded async+await；不代替parallel重叠与启动失败门禁；未新增Test262条目',
}

(DIRECTORY / '结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(modes, ensure_ascii=False))
