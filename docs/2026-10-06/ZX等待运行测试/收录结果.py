import hashlib
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
WORKTREE = Path('/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc')
BASELINE = '24a12de4'
GROUPS = {'scalar': 3, 'capture': 1, 'direct': 2, 'nested': 2, 'optional': 3, 'void': 2, 'capture_error': 3, 'list': 2}


def git(*args):
    return subprocess.check_output(['git', '-C', str(WORKTREE), *args], text=True).strip()


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


paths = ['packages/test/build/tasks.zig', 'packages/test/build/tasks_await_runtime.zig']
paths += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/tasks/runtime/await').rglob('*') if path.is_file())

assert len(paths) == 22
assert git('rev-parse', 'HEAD') == git('rev-parse', BASELINE)
assert not git('status', '--porcelain', '--', 'packages/compiler', 'packages/core', 'packages/genz')

for group, expected in GROUPS.items():
    path = ROOT / f'packages/test/tests/language/expressions/tasks/runtime/await/{group}/execution_test.zig'
    assert len(re.findall(r'^test "', path.read_text(), re.MULTILINE)) == expected

sources = {}

for name in paths + ['packages/test/build.zig']:
    sources[name] = fingerprint(ROOT / name)
    assert sources[name] == fingerprint(WORKTREE / name), name
    if name in paths:
        assert sources[name] == fingerprint(DIRECTORY / '草稿' / name), name

for group in GROUPS:
    assert (DIRECTORY / '生成' / group / 'program.zig.txt').is_file()
    assert (DIRECTORY / '生成' / group / 'abi.zig.txt').is_file()

modes = {}

for mode in ['Debug', 'ReleaseSafe']:
    log = DIRECTORY / f'{mode}最终日志.txt'
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and int(summary[1]) == int(summary[2]) == 36
    assert int(summary[3]) == int(summary[4]) == 18
    assert 'failure' not in text
    runs = dict((name, int(count)) for name, count in re.findall(r'run test zx-await-(\S+) (\d+) pass', text))
    assert runs == GROUPS, runs
    cached = len(re.findall(r'run test zx-await-\S+ cached', text))
    assert cached == 0
    modes[mode] = {'退出码': 0, '成功构建步骤': 36, '实际执行声明': sum(runs.values()), '内联应用执行次数': 18, '线程应用执行次数': 18, '应用执行总次数': 36, '运行缓存步': cached, '日志': str(log.relative_to(ROOT))}

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
    '边界': '18个独立声明各含内联与线程执行；原子探针验证真实不同线程；不代替parallel重叠、未等待退出或显式cancel门禁；未新增Test262条目',
}

(DIRECTORY / '结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(modes, ensure_ascii=False))
