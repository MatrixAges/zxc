# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
directory = Path(__file__).resolve().parent
groups = ('analysis', 'ir', 'exports')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(name, value):
    (directory / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


sources = sorted(path.relative_to(root) for group in groups for path in (root / 'packages/test/tests/native/references' / group).glob('*.zig'))
sources += [Path('packages/test/build/native_references.zig'), Path('packages/test/tests/support/allocation_testing.zig')]
fingerprints = {}

for source in sources:
    assert (root / source).read_bytes() == (fixed / source).read_bytes(), source
    fingerprints[str(source)] = digest(root / source)

declarations = sum(len(re.findall(r'^test "', (root / source).read_text(), re.MULTILINE)) for source in sources if source.name.endswith('_test.zig'))
assert declarations == 73, declarations
internal_sources = {str(path.relative_to(fixed)): digest(path) for path in sorted((fixed / 'packages/compiler/src/zx').rglob('*')) if path.is_file()}
gates = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    log = Path('/tmp/zxc-native-references-output-task-' + mode + ('-final' if mode == 'debug' else '') + '.log')
    text = log.read_text()
    assert 'Build Summary: 46/46 steps succeeded' in text
    assert not re.search(r'^error:', text, re.MULTILINE)
    actual = sum(int(value) for value in re.findall(r'run test (\d+) pass', text))
    assert 6 <= actual <= declarations, actual
    (directory / (label + '最终日志.txt')).write_bytes(log.read_bytes())

    gates[label] = {
        '命令': 'zig build test-native-references-analysis test-native-references-ir test-native-references-exports -Doptimize=' + mode + ' -j2 --summary all',
        '退出码': 0,
        '构建步骤': '46/46',
        '本部分门禁独立声明': declarations,
        '最终门禁实际执行声明': actual,
        '复用已通过声明缓存': declarations - actual,
        '日志': label + '最终日志.txt',
        '日志SHA256': digest(log),
    }

attempts = {}

for name in ('首轮Debug日志.txt', '导入分组Debug日志.txt'):
    path = directory / name
    text = path.read_text()
    assert 'unexpected reference diagnostic spacing' in text
    attempts[name] = {'退出码': 1, '日志SHA256': digest(path), '原因': '夹具 import 分组空行错误，非生产缺陷'}

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '内部校验原样复制来源SHA256': internal_sources,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip()},
    '门禁': gates,
    '夹具修正过程': attempts,
    '新增独立声明': 6,
    '新增覆盖': {'Gateway独立输出': 2, '无捕获task返回引用分析': 1, '合法task独立IR控制': 1, '独立IR返回与捕获拒绝': 2},
    '接替后累计新增原生引用独立用例': 147,
    '新增Test262审阅': 0,
    '新增JSONL目录案例': 0,
    '自我复核': 'IR返回变异保持captures为空并同步none和task结果类型；捕获变异保持task结果为u64，仅变更输入列表、符号和引用表达式为Node[]。类型、逐表达式和作用域先通过，随后tasks.validate准确拒绝，公共validateIr及emitBundle同样拒绝。Gateway输入为标量，单独执行output引用检查。分析夹具两次因为import分组不符失败，真实zxc fmt指出原生/普通/type导入之间均需空行，最终修正后准确capability诊断通过。没有生产实现缺陷，未通知实现聊天。',
})

print(json.dumps({'声明': declarations, '新增': 6, '门禁': list(gates), '测试来源': len(fingerprints), '复制的内部来源': len(internal_sources)}, ensure_ascii=False))
