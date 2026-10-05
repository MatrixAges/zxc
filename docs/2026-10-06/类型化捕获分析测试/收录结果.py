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


paths = ['packages/test/build/typed_try.zig']
paths += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/typed_try/analysis').glob('*.zig'))
support = ['packages/test/build.zig', 'packages/test/tests/support/allocation_testing.zig']
support += sorted(str(path.relative_to(ROOT)) for path in (ROOT / 'packages/test/tests/language/expressions/typed_try/native_contract').glob('*.zig'))

assert git('rev-parse', 'HEAD') == '0f371fe5bd32957115935988955157a174d4c18d'
assert not git('diff', '--name-only', '--', 'packages/compiler', 'packages/core', 'packages/genz')

source_hashes = {}

for name in paths + support:
    source_hashes[name] = fingerprint(ROOT / name)
    assert source_hashes[name] == fingerprint(WORKTREE / name), name

modes = {}

for mode in ['Debug', 'ReleaseSafe']:
    log = DIRECTORY / f'{mode}最终日志.txt'
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4], mode
    assert 'fail (' not in text
    modes[mode] = {
        '退出码': 0,
        '成功构建步骤': int(summary[1]),
        '实际执行Zig声明': int(summary[3]),
        '缓存运行步': len(re.findall(r'run test cached', text)),
        '日志': str(log.relative_to(ROOT)),
    }

evidence = {}

for path in sorted(DIRECTORY.rglob('*')):
    if path.is_file() and path.name != '结果.json':
        evidence[str(path.relative_to(ROOT))] = fingerprint(path)

report = {
    '验证检出': git('rev-parse', 'HEAD'),
    '生产功能提交': git('rev-parse', '039a7ce0'),
    '正式修改文件': paths,
    '捕获分析独立Zig声明数': 45,
    '捕获分析分配失败声明数': 2,
    '联动原生声明数': 18,
    '模式': modes,
    '源指纹': source_hashes,
    '证据指纹': evidence,
    '边界': '静态分析和IR校验；不代表真实Zig运行与库重放；未新增Test262案例',
}

(DIRECTORY / '结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(modes, ensure_ascii=False))
