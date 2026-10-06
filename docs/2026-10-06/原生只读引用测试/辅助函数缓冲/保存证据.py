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
assert declarations == 45, declarations

gates = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    reports = []

    for path in (fixed / 'packages/test/.zig-cache/o').glob('*/**/execution.json'):
        report = json.loads(path.read_text())

        if report['optimize'] != mode or '/native/references/runtime/' not in report['source']:
            continue

        generated = {str(source.relative_to(path.parent)): digest(source) for source in path.parent.iterdir() if source.suffix in ('.zig', '.json')}
        reports.append({'运行报告路径': str(path), '生成文件SHA256': generated, **report})

    latest = {}

    for report in reports:
        key = (report['source'], report['native_identity'] is not None)

        if key not in latest or Path(report['运行报告路径']).stat().st_mtime_ns > Path(latest[key]['运行报告路径']).stat().st_mtime_ns:
            latest[key] = report

    reports = sorted(latest.values(), key=lambda report: (report['source'], report['native_identity'] or ''))
    assert len(reports) == 28, (mode, len(reports))
    assert sum(report['native_identity'] is not None for report in reports) == 14

    for report in reports:
        assert report['status'] == 0 and report['signal'] is None and report['error'] is None, report['运行报告路径']

        current_mode = None

        for argument in report['argv']:
            if argument.startswith('-O'):
                current_mode = argument[2:]

            if argument.startswith('-M'):
                assert current_mode == mode, (report['运行报告路径'], argument)

    write(label + '运行报告.json', reports)

    log = Path('/tmp/zxc-native-references-transfers-' + mode + '-all.log')
    text = log.read_text()
    instances = sum(int(number) for number in re.findall(r'All (\d+) tests passed\.', text))
    assert instances == 90, (mode, instances)
    assert 'Build Summary: 79/79 steps succeeded' in text
    assert text.count('ℹ pass 1') == 28
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())

    gates[label] = {
        '命令': 'zig build test-native-references-runtime ' + ('-Doptimize=safe ' if mode == 'safe' else '') + '-j2 --summary all',
        '退出码': 0,
        '构建步骤': '79/79',
        '独立声明': declarations,
        '源码执行声明': declarations,
        '统一库执行声明': declarations,
        '实际Zig执行总数': instances,
        '实际Node驱动组数': 28,
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
    '新增独立声明': 12,
    '既有回归独立声明': 33,
    '门禁独立声明合计': declarations,
    '接替后累计新增独立声明': 132,
    '新增Test262审阅': 0,
    '新增JSONL目录案例': 0,
    '自我复核': '新增12个声明，含受支持的状态helper链、保守嵌套列表helper与两个独立append缓冲。列表容量复用不等于消除全部临时对象分配；成本标准为循环次数加列表长度的线性上界。首轮夹具的import/owned使用和常量成本预期错误均保留原始日志，不计为生产缺陷。CLI/Wasm构建边界仍待验证。',
})

attempts = {}

for name, suffix in (
    ('首轮分组失败日志', 'debug'),
    ('普通初值拥有权失败日志', 'debug-final'),
    ('临时初值字段赋值失败日志', 'debug-owned'),
    ('诊断定位日志', 'debug-diagnostic'),
    ('嵌套调用成本失败日志', 'debug-replacement'),
    ('状态链成本失败日志', 'debug-supported'),
    ('专项Debug通过日志', 'debug-bounded'),
):
    path = Path('/tmp/zxc-native-references-transfers-' + suffix + '.log')
    (directory / (name + '.txt')).write_bytes(path.read_bytes())
    attempts[name] = {'日志': name + '.txt', '日志SHA256': digest(path), '退出码': 0 if suffix == 'debug-bounded' else 1}

write('修正过程日志.json', attempts)

print(json.dumps({'声明': declarations, '门禁': list(gates), '来源': len(fingerprints)}, ensure_ascii=False))
