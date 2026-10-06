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
    'packages/test/suites.json',
    'packages/test/src/generate_null_inequality.ts',
    'packages/test/src/emit_control_tests.ts',
    'packages/test/src/zig_string.ts',
    'packages/test/src/shared/catalog.ts',
    'packages/test/src/shared/json.ts',
    'packages/test/src/shared/zig_literal.ts',
    'packages/test/src/shared/files.ts',
    'packages/test/src/shared/upstream.ts',
    'packages/test/src/audit_matrix.ts',
    'packages/test/src/query_upstream.ts',
    'packages/test/tests/support/control.zig',
    'packages/test/upstream/reviews/language/expressions/does_not_equals_remaining.jsonl',
)]
sources += sorted(path.relative_to(root) for path in (root / 'packages/test/tests/language/expressions/comparison/null_inequality').iterdir())
sources += [Path('packages/test/tests/language/expressions/comparison/optional/' + name + suffix) for name in ('bool', 'f64') for suffix in ('.zx', '.jsonl')]
fingerprints = {}

for source in sources:
    assert (root / source).read_bytes() == (fixed / source).read_bytes(), source
    fingerprints[str(source)] = digest(root / source)

gates = {}

for mode, label in (('debug', 'Debug'), ('safe', 'ReleaseSafe')):
    log = Path('/tmp/zxc-null-inequality-' + mode + '.log')
    text = log.read_text()
    assert 'Build Summary: 46/46 steps succeeded; 29/29 tests passed' in text
    assert not re.search(r'run test .* cached', text)

    for name, count in (('optional-equality-f64', 16), ('optional-equality-bool', 9), ('null-inequality-string', 2), ('null-inequality-empty_object', 2)):
        assert 'run test ' + name + ' ' + str(count) + ' pass' in text

    (directory / (label + '日志.txt')).write_bytes(log.read_bytes())
    gates[label] = {
        '命令': 'zig build test-null-inequality -Doptimize=' + mode + ' -j2 --summary all',
        '退出码': 0,
        '构建步骤': '46/46',
        '真实执行目录案例': 29,
        '新增目录案例': 4,
        '复用既有目录案例': 25,
        '运行测试缓存': 0,
        '日志': label + '日志.txt',
        '日志SHA256': digest(log),
    }

generated = {}

for name, marker in (('program.zig', 'left_different: bool'), ('cases.zig', 'comparison/null_inequality/')):
    for path in sorted((fixed / 'packages/test/.zig-cache/o').glob('*/' + name)):
        if marker in path.read_text():
            generated[str(path)] = digest(path)

original = json.loads((directory / '原文结果.json').read_text())
assert original['files'] == 20 and len(original['results']) == 40
assert all(result['passed'] for result in original['results'])
assert original['static_same_value_calls'] == 179
audit = json.loads((directory / '覆盖审计.json').read_text())
closure = json.loads((directory / '目录闭合.json').read_text())
assert sum(audit['reviewed'].values()) == 2459
assert audit['catalog_cases'] == 80159 and audit['unreviewed'] == 51138
assert closure['matched_unreviewed'] == 0

write('执行结果.json', {
    '固定生产提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '固定生产源码树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '测试检出': str(fixed),
    '测试来源SHA256': fingerprints,
    '生成测试及程序SHA256': generated,
    '工具': {'Zig': subprocess.check_output(['zig', 'version'], text=True).strip(), 'Node': subprocess.check_output(['node', '--version'], text=True).strip()},
    '门禁': gates,
    '类型检查': {'命令': 'pnpm typecheck', '退出码': 0},
    '生成一致性': {'命令': 'node packages/test/src/generate_null_inequality.ts --check', '退出码': 0},
    '新增完整原文审阅': 20,
    '原文执行': {'文件': 20, '普通与严格模式执行': 40, '通过': 40, '静态sameValue调用点': 179, '计为ZX兼容通过': False},
    '本目录': {'原文总数': 38, 'adapted': 14, 'equivalent': 4, 'excluded': 20, '未审阅': 0},
    '完整矩阵审计': audit,
    '审计命令': {'命令': 'node packages/test/src/audit_matrix.ts', '退出码': 0},
    '审计修正': {'首轮退出码': 1, '原因': 'assertions.field只支持expected的顶层字段，原草稿错误地指向value对象内部字段。保留observation_field指明局部观察，再用完整value对象精确核对；未改变测试预期或放宽审计。'},
    '自我复核': '20份完整动态协议/BigInt文件登记excluded。前三份仅关联有明确optional上下文的null子观察；新增字符串null与空对象原值及null对照，复用bool false和f64零对照。1024位BigInt邻值经独立整数公式核对，转f64会删除差异。40次原文执行、179个静态调用点、29次每模式ZX目录执行以及20份文件审阅分开计数。没有发现已承诺语义的生产实现缺陷，未通知实现聊天。',
})

print(json.dumps({'新增目录案例': 4, '新增审阅': 20, 'ZX各模式执行': 29, '总目录案例': audit['catalog_cases'], '未审阅': audit['unreviewed']}, ensure_ascii=False))
