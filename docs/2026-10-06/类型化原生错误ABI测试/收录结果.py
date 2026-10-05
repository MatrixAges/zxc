import hashlib
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
WORKTREE = Path('/Users/xiewendao/.codex/worktrees/release-safe-regression/zxc')


def git(*args):
    return subprocess.check_output(['git', '-C', str(WORKTREE), *args], text=True).strip()


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


paths = ['packages/test/build/typed_try.zig', 'packages/test/build/typed_try_native_abi.zig']
paths += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/typed_try/native_abi').rglob('*') if path.is_file())

assert len(paths) == 21
assert git('rev-parse', 'HEAD') == '0f371fe5bd32957115935988955157a174d4c18d'
assert not git('status', '--porcelain', '--', 'packages/compiler', 'packages/core', 'packages/genz')
count = sum(len(re.findall(r'^test "', (ROOT / name).read_text(), re.MULTILINE)) for name in paths)
assert count == 1

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
    assert summary and summary[1] == summary[2] and int(summary[3]) == int(summary[4]) == 3, mode
    assert 'failure' not in text
    cached = len(re.findall(r'run test typed-try-abi-\S+ cached', text))
    assert cached == 0, mode
    for name in ['scalar', 'optional', 'void', 'empty', 'opaque']:
        assert re.search(r'compile test typed-try-abi-' + name + r' (debug|safe) native success', text), name
    modes[mode] = {'退出码': 0, '成功构建步骤': int(summary[1]), '实际预期编译拒绝实例': 5, '实际正例执行实例': 3, '缓存运行步': cached, '日志': str(log.relative_to(ROOT))}

evidence = {}

for path in sorted(DIRECTORY.rglob('*')):
    if path.is_file() and path.name != '结果.json':
        evidence[str(path.relative_to(ROOT))] = fingerprint(path)

report = {
    '验证检出': git('rev-parse', 'HEAD'),
    '生产功能提交': git('rev-parse', '039a7ce0'),
    '正式修改文件': paths,
    '独立Zig源码声明数': 1,
    '预期编译拒绝实例数': 5,
    '正例执行实例数': 3,
    '模式': modes,
    '源指纹': sources,
    '证据指纹': evidence,
    '边界': '真实 ZX 分析生成、静态原生 Zig 错误联合边界；预期编译错误检查与运行实例分别记录；未新增 Test262 条目',
}

(DIRECTORY / '结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(modes, ensure_ascii=False))
