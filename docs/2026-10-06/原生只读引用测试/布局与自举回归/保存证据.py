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

    log = Path('/tmp/zxc-native-references-layout-' + mode + '.log')
    text = log.read_text()
    assert 'Build Summary: 126/126 steps succeeded; 93/93 tests passed' in text
    runtime = sum(int(value) for value in re.findall(r'All (\d+) tests passed\.', text))
    assert runtime == 90, (mode, runtime)
    assert len(re.findall(r'native reference application boundary .* \(' + mode + r'\)', text)) == 9
    actual_units = sum(int(value) for value in re.findall(r'run test (\d+) pass', text))
    assert actual_units == 93, actual_units
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())

    latest = {}

    for runtime_path in (fixed / 'packages/test/.zig-cache/o').glob('*/**/execution.json'):
        value = json.loads(runtime_path.read_text())

        if value['optimize'] != mode or '/native/references/runtime/' not in value['source']:
            continue

        key = (value['source'], value['native_identity'] is not None)

        if key not in latest or runtime_path.stat().st_mtime_ns > latest[key][0].stat().st_mtime_ns:
            latest[key] = (runtime_path, value)

    assert len(latest) == 28, (mode, len(latest))
    runtime_reports = []

    for runtime_path, value in sorted(latest.values(), key=lambda item: str(item[0])):
        assert value['status'] == 0 and value['signal'] is None and value['error'] is None
        assert runtime_path.stat().st_mtime >= log.stat().st_birthtime
        current_mode = None

        for argument in value['argv']:
            if argument.startswith('-O'):
                current_mode = argument[2:]

            if argument.startswith('-M'):
                assert current_mode == mode, (runtime_path, argument)

        generated = {str(source.relative_to(runtime_path.parent)): digest(source) for source in runtime_path.parent.iterdir() if source.suffix in ('.zig', '.json')}
        runtime_reports.append({'运行报告路径': str(runtime_path), '生成文件SHA256': generated, **value})

    write(label + '引用运行报告.json', runtime_reports)

    gates[label] = {
        '命令': 'zig build test-native-references -Doptimize=' + mode + ' -j2 --summary all',
        '退出码': 0,
        '构建步骤': '126/126',
        '应用边界独立登记用例': 9,
        '真实命令数': len(commands),
        '准确拒绝构建数': rejected,
        '成功命令数': len(commands) - rejected,
        '标量实际观察数': 36,
        '标量直接Wasm实例调用数': 12,
        '既有运行独立声明': 45,
        '既有运行源码与统一库实际Zig声明执行数': runtime,
        '既有分析IR出口库独立声明': 93,
        '本次实际执行的既有内部声明': actual_units,
        '复用已通过内部声明缓存': 93 - actual_units,
        '日志': label + '日志.txt',
        '日志SHA256': digest(log),
        '运行报告': label + '构建运行报告.json',
        '引用运行报告': label + '引用运行报告.json',
    }

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()},
    '门禁': gates,
    '新增独立登记用例': 0,
    '本次回归原生引用独立用例': 147,
    '接替后累计新增原生引用独立用例': 147,
    '新增Test262审阅': 0,
    '新增JSONL目录案例': 0,
    '自我复核': '在明确固定的新生产版本回归全部147个既有独立用例，不增加案例或上游审阅数量。两模式各93个内部声明、45个真实运行声明沿两路线共90次外部Zig执行、九个Node应用边界登记实际通过。任意可信Zig内部行为或宿主生命周期不由专项证明；专项通过也不替代全仓库及发行构建。',
})

print(json.dumps({'登记用例': len(expected), '门禁': list(gates), '来源': len(fingerprints)}, ensure_ascii=False))
