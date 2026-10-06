# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
directory = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(name, value):
    (directory / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


sources = [Path(name) for name in (
    'packages/test/build.zig',
    'packages/test/build/runtime.zig',
    'packages/test/build/catalog.zig',
    'packages/test/suites.json',
    'packages/test/src/generate_reverse_projections.ts',
    'packages/test/src/emit_control_tests.ts',
    'packages/test/src/zig_string.ts',
    'packages/test/src/shared/catalog.ts',
    'packages/test/src/shared/json.ts',
    'packages/test/src/shared/zig_literal.ts',
    'packages/test/src/shared/files.ts',
    'packages/test/src/shared/upstream.ts',
    'packages/test/src/audit_matrix.ts',
    'packages/test/src/query_upstream.ts',
    'packages/test/tests/support/collections.zig',
    'packages/test/upstream/reviews/built_ins/array/reverse_remaining.jsonl',
)]
sources += sorted(path.relative_to(root) for path in (root / 'packages/test/tests/built_ins/list/reverse').rglob('*') if path.is_file())
fingerprints = {}

for source in sources:
    assert (root / source).read_bytes() == (fixed / source).read_bytes(), source
    fingerprints[str(source)] = digest(root / source)

gates = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    log = Path('/tmp/zxc-reverse-' + mode + '.log')
    text = log.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; 128/128 tests passed', text)
    assert summary and summary[1] == summary[2], text[-1000:]
    actual = 0
    cached = 0

    for name, count in [('list-reverse-owned-' + str(index), count) for index, count in enumerate((1, 3, 11, 28, 82, 1))] + [('list-reverse-projections', 2)]:
        matches = re.findall(r'run test ' + name + r' (\d+) pass(?: (cached))?', text)
        assert matches == [(str(count), '')] or matches == [(str(count), 'cached')], (name, matches)
        actual += sum(int(value) for value, cache in matches if not cache)
        cached += sum(int(value) for value, cache in matches if cache)

    assert actual + cached == 128
    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())
    gates[label] = {
        '命令': 'zig build test-list-reverse -Doptimize=' + mode + ' -j2 --summary all',
        '退出码': 0,
        '构建步骤': summary[1] + '/' + summary[2],
        '真实执行目录案例': actual,
        '已通过缓存案例': cached,
        '新增目录案例': 2,
        '复用既有目录案例': 126,
        '日志': label + '日志.txt',
        '日志SHA256': digest(log),
    }

generated = {}
programs = {}
started = Path('/tmp/zxc-reverse-debug.log').stat().st_birthtime

for path in sorted((fixed / 'packages/test/.zig-cache/o').glob('*/cases.zig')):
    if 'built_ins/list/reverse/' in path.read_text():
        generated[str(path)] = digest(path)

for path in sorted((fixed / 'packages/test/.zig-cache/o').glob('*/program.zig')):
    if path.stat().st_mtime >= started and 'reverse' in path.read_text():
        programs[str(path)] = digest(path)

assert len(programs) == 14, len(programs)

original = json.loads((directory / '原文结果.json').read_text())
assert original['files'] == 17 and len(original['results']) == 34
assert all(result['passed'] for result in original['results'])
constructors = [result['constructors'] for result in original['results'] if 'constructors' in result]
assert len(constructors) == 2 and constructors[0] == constructors[1] and len(constructors[0]) == 15
physical = json.loads((directory / '全目录源码核对.json').read_text())
assert physical['匹配索引数'] == physical['原文数'] == 18
audit = json.loads((directory / '覆盖审计.json').read_text())
closure = json.loads((directory / '目录闭合.json').read_text())
assert sum(audit['reviewed'].values()) == 2476
assert audit['catalog_cases'] == 80161 and audit['unreviewed'] == 51121
assert closure['matched_unreviewed'] == 0

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '生成测试SHA256': generated,
    '本次两模式生成程序SHA256': programs,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()},
    '门禁': gates,
    '类型检查': {'命令': 'pnpm typecheck', '退出码': 0},
    '生成一致性': {'命令': 'node packages/test/src/generate_reverse_projections.ts --check', '退出码': 0},
    '新增完整原文审阅': 17,
    '原文执行': {'文件': 17, '普通与严格模式执行': 34, '通过': 34, 'RAB实际构造器': constructors[0], '计为ZX兼容通过': False},
    '本目录': {'原文总数': 18, 'adapted': 0, 'equivalent': 0, 'excluded': 18, '未审阅': 0},
    '完整矩阵审计': audit,
    '审计命令': {'命令': 'node packages/test/src/audit_matrix.ts', '退出码': 0},
    '自我复核': '17份新完整文件均excluded；旧A1_T1此前已撤回adapted。本次只新增两个RAB原值稠密顺序投影；[0,1]和[1]复用既有准确案例。通用map建立独占列表，reverse消费列表但不强制新地址，collections支持核对原输入未变并释放arena。动态接收者身份、空洞、原型、ToLength、Proxy首错误与部分写入、冻结单元素正常完成、共享RAB视图及resize不由普通列表替代。34次参考执行不计为ZX兼容通过，没有生产实现违约，不通知实现聊天。',
})

print(json.dumps({'新增目录案例': 2, '新增审阅': 17, 'ZX两模式门禁': gates, '总目录案例': audit['catalog_cases'], '未审阅': audit['unreviewed']}, ensure_ascii=False))
