# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
directory = Path(__file__).resolve().parent
runtime = Path('packages/test/tests/native/references/runtime')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(name, value):
    (directory / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


sources = sorted(path.relative_to(root) for path in (root / runtime).rglob('*') if path.is_file())
sources += [Path(name) for name in (
    'packages/test/build/native_reference_runtime.zig',
    'packages/test/build/native_references.zig',
    'packages/test/tests/library/runtime/save.zig',
    'packages/test/tests/support/allocation_testing.zig',
)]

fingerprints = {}

for source in sources:
    assert (root / source).read_bytes() == (fixed / source).read_bytes(), source
    fingerprints[str(source)] = digest(root / source)

declarations = sum(len(re.findall(r'^test "', (root / source).read_text(), re.MULTILINE)) for source in sources if source.name == 'execution_test.zig')
assert declarations == 14, declarations

gates = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    reports = []

    for path in (fixed / 'packages/test/.zig-cache/o').glob('*/**/execution.json'):
        report = json.loads(path.read_text())

        if report['optimize'] != mode or '/native/references/runtime/' not in report['source']:
            continue

        assert report['status'] == 0 and report['signal'] is None and report['error'] is None, path

        current_mode = None

        for argument in report['argv']:
            if argument.startswith('-O'):
                current_mode = argument[2:]

            if argument.startswith('-M'):
                assert current_mode == mode, (path, argument)

        generated = {str(source.relative_to(path.parent)): digest(source) for source in path.parent.iterdir() if source.suffix in ('.zig', '.json')}
        reports.append({'运行报告路径': str(path), '生成文件SHA256': generated, **report})

    reports.sort(key=lambda report: (report['source'], report['native_identity'] or ''))
    assert len(reports) == 12, (mode, len(reports))
    assert len({(report['source'], report['native_identity'] is not None) for report in reports}) == 12
    assert sum(report['native_identity'] is not None for report in reports) == 6

    write(label + '运行报告.json', reports)

    log = Path('/tmp/zxc-native-references-runtime-' + mode + '.log')
    text = log.read_text()
    instances = sum(int(number) for number in re.findall(r'All (\d+) tests passed\.', text))
    assert instances == 28, (mode, instances)
    assert 'Build Summary: 46/46 steps succeeded' in text
    assert text.count('ℹ pass 1') == 12
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())

    gates[label] = {
        '命令': 'zig build test-native-references-runtime ' + ('-Doptimize=safe ' if mode == 'safe' else '') + '-j2 --summary all',
        '退出码': 0,
        '构建步骤': '46/46',
        '独立声明': declarations,
        '源码执行声明': declarations,
        '统一库执行声明': declarations,
        '实际Zig执行总数': instances,
        '实际Node驱动组数': 12,
        '运行测试缓存': 0,
        '日志': label + '日志.txt',
        '日志SHA256': digest(log),
        '运行报告': label + '运行报告.json',
    }

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()},
    '门禁': gates,
    'TypeScript检查': {'命令': 'pnpm typecheck', '目录': 'packages/test', '退出码': 0},
    '新增独立声明': declarations,
    '接替后累计新增独立声明': 101,
    '新增Test262审阅': 0,
    '新增JSONL目录案例': 0,
    '自我复核': '两模式各两路线共28次实际Zig声明执行，仍只有14个独立声明。宿主明确存活，容器仅释放自己的缓冲；不证明任意可信accessor只读，不制造UAF。未覆盖引用遍历/loop/多缓冲优化与CLI/Wasm构建边界。',
})

print(json.dumps({'声明': declarations, '门禁': list(gates), '来源': len(fingerprints)}, ensure_ascii=False))
