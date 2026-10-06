# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
directory = Path(__file__).resolve().parent
targets = Path('packages/test/tests/native/references/targets')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(name, value):
    (directory / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


sources = sorted(path.relative_to(root) for path in (root / 'packages/test/tests/native/references').rglob('*') if path.is_file())
sources += [Path(name) for name in (
    'packages/test/build.zig',
    'packages/test/build/native_references.zig',
    'packages/test/build/native_reference_runtime.zig',
    'packages/test/build/native_reference_targets.zig',
    'packages/test/tests/library/runtime/save.zig',
    'packages/test/tests/support/allocation_testing.zig',
    'packages/test/tests/targets/wasm/host.ts',
    'packages/test/tests/targets/wasm/wasi_host.ts',
)]
fingerprints = {}

for source in sources:
    assert (root / source).read_bytes() == (fixed / source).read_bytes(), source
    fingerprints[str(source)] = digest(root / source)

expected = sorted(str(path.relative_to(root / targets / 'fixtures')) for path in (root / targets / 'fixtures').rglob('*.zx') if not path.name.endswith('.d.zx'))
assert len(expected) == 9, expected
gates = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    candidates = []

    for path in (fixed / 'packages/test/.zig-cache/o').glob('*/application-targets.json'):
        report = json.loads(path.read_text())

        if report['optimize'] == mode and sorted(case['name'] for case in report['reports']) == expected:
            candidates.append(path)

    assert candidates, mode
    path = max(candidates, key=lambda item: item.stat().st_mtime_ns)
    report = json.loads(path.read_text())
    commands = []

    for case in report['reports']:
        assert case['passed'], case['name']
        assert len(case['commands']) == (38 if case['name'] == 'control/scalar.zx' else 26), case['name']

        for command in case['commands']:
            assert command['signal'] is None and command['error'] is None, command

            if command['status'] != 0:
                assert re.search(r'error: UnsupportedHostReference\b', command['stderr']), command

            commands.append(command)

    rejected = sum(command['status'] != 0 for command in commands)
    assert rejected == 192 and len(commands) == 246, (mode, rejected, len(commands))
    write(label + '构建运行报告.json', {'原始报告路径': str(path), **report})

    log = Path('/tmp/zxc-native-references-targets-final-' + mode + '.log')
    text = log.read_text()
    assert 'Build Summary: 123/123 steps succeeded' in text
    runtime = sum(int(value) for value in re.findall(r'All (\d+) tests passed\.', text))
    assert runtime == 90, (mode, runtime)
    assert len(re.findall(r'native reference application boundary .* \(' + mode + r'\)', text)) == 9
    actual_units = sum(int(value) for value in re.findall(r'run test (\d+) pass', text))
    assert 0 <= actual_units <= 87, actual_units
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())

    gates[label] = {
        '命令': 'zig build test-native-references -Doptimize=' + mode + ' -j2 --summary all',
        '退出码': 0,
        '构建步骤': '123/123',
        '应用边界独立登记用例': 9,
        '真实命令数': len(commands),
        '准确拒绝构建数': rejected,
        '成功命令数': len(commands) - rejected,
        '标量实际观察数': 36,
        '标量直接Wasm实例调用数': 12,
        '既有运行独立声明': 45,
        '既有运行源码与统一库实际Zig声明执行数': runtime,
        '既有分析IR出口库独立声明': 87,
        '本次实际执行的既有内部声明': actual_units,
        '复用已通过内部声明缓存': 87 - actual_units,
        '日志': label + '日志.txt',
        '日志SHA256': digest(log),
        '运行报告': label + '构建运行报告.json',
    }

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()},
    '门禁': gates,
    '类型检查': {'命令': 'pnpm typecheck', '退出码': 0},
    '新增独立登记用例': 9,
    '接替后累计新增原生引用独立用例': 141,
    '新增Test262审阅': 0,
    '新增JSONL目录案例': 0,
    '自我复核': '首轮七例完整Debug已通过87个内部声明及90次外部Zig声明执行；复核发现可空引用输出可由null构造，新增两例隔离output检查。同步命令两次因相对路径与固定工作目录不符失败，均为执行操作错误，最终以绝对路径同步后重新执行Debug/Safe。未改变生产源码，未发现实现缺陷。一个语义用例中的目标、路线、策略和文件存在状态均不增加独立用例计数。',
})

print(json.dumps({'登记用例': len(expected), '门禁': list(gates), '来源': len(fingerprints)}, ensure_ascii=False))
