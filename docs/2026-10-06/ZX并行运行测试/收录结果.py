import hashlib
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
WORKTREE = Path('/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc')
BASELINE = 'db5e0040'
GROUPS = {'values': 1, 'source_order': 2, 'all_join': 1, 'mixed': 2, 'all_void': 2, 'capture': 3, 'initial_failure': 1, 'mid_failure': 1}


def git(*args):
    return subprocess.check_output(['git', '-C', str(WORKTREE), *args], text=True).strip()


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


paths = ['packages/test/build/tasks.zig', 'packages/test/build/tasks_parallel_runtime.zig']
paths += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/tasks/runtime/parallel').rglob('*') if path.is_file())

assert len(paths) == 24
assert git('rev-parse', 'HEAD') == git('rev-parse', BASELINE)
assert not git('status', '--porcelain', '--', 'packages/compiler', 'packages/core', 'packages/genz')

for group, expected in GROUPS.items():
    path = ROOT / f'packages/test/tests/language/expressions/tasks/runtime/parallel/{group}/execution_test.zig'
    assert len(re.findall(r'^test "', path.read_text(), re.MULTILINE)) == expected

invocations = sum((ROOT / f'packages/test/tests/language/expressions/tasks/runtime/parallel/{group}/execution_test.zig').read_text().count('check.run(') for group in GROUPS)

assert invocations == 14

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
    log = DIRECTORY / f'{mode}日志.txt'
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and int(summary[1]) == int(summary[2]) == 36
    assert int(summary[3]) == int(summary[4]) == 13
    assert 'transitive failure' not in text
    runs = dict((name, int(count)) for name, count in re.findall(r'run test zx-parallel-(\S+) (\d+) pass', text))
    assert runs == GROUPS, runs
    cached = len(re.findall(r'run test zx-parallel-\S+ cached', text))
    assert cached == 0
    modes[mode] = {'退出码': 0, '成功构建步骤': 36, '实际执行声明': sum(runs.values()), '完整分支并发应用执行次数': 12, '初次启动不可用应用执行次数': 1, '中途启动失败应用执行次数': 1, '应用执行总次数': 14, '运行缓存步': cached, '日志': str(log.relative_to(ROOT))}

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
    '边界': '13个独立声明、14次应用执行；真实Threaded重叠及标准Io观测接口核验源码启动/完成顺序、首错、全部await及启动失败清理；宿主销毁前断言；不代替结果组装OOM或统一库门禁；未新增Test262条目',
}

(DIRECTORY / '结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(modes, ensure_ascii=False))
