import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
UPSTREAM = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


records = json.loads((DIRECTORY / '原文清单.json').read_text())
result = json.loads((DIRECTORY / '原文结果.json').read_text())
audit = json.loads((DIRECTORY / '覆盖审计.json').read_text())
closure = json.loads((DIRECTORY / '目录闭合.json').read_text())
source = ROOT / 'packages/test/src/data/for_each.jsonl'
generated = ROOT / 'packages/test/upstream/reviews/built_ins/array/for_each.jsonl'
lock = json.loads((ROOT / 'packages/test/upstream/lock.json').read_text())
indexed = {row['path']: row['sha256'] for row in map(json.loads, (ROOT / 'packages/test/upstream/index/built-ins.jsonl').read_text().splitlines())}
metadata = {row['path']: row for row in map(json.loads, (ROOT / 'packages/test/upstream/metadata/built-ins.jsonl').read_text().splitlines())}
rows = {row['path']: row for row in map(json.loads, source.read_text().splitlines())}
expected = {path for path in indexed if path.startswith('test/built-ins/Array/prototype/forEach/')}
assert source.read_bytes() == generated.read_bytes()
assert len(rows) == len(expected) == 190 and set(rows) == expected
assert all(row['status'] == 'excluded' and row['sha256'] == indexed[path] for path, row in rows.items())
assert closure['未审阅路径'] == closure['多余登记路径'] == []
assert '"matched_unreviewed":0' in (DIRECTORY / '剩余查询.txt').read_text()
assert lock['revision'] == UPSTREAM.name.removeprefix('test262-')
assert result['files'] == len(records) == 11 and len(result['results']) == 22

for record in records:
    path = record['path']
    assert fingerprint(UPSTREAM / path) == indexed[path] == record['sha256']
    assert rows[path] == {key: record[key] for key in ['path', 'sha256', 'status', 'reason', 'contract', 'cases', 'assertions']}
    assert record['flags'] == metadata[path].get('flags', []) and record['includes'] == metadata[path].get('includes', [])
    executions = [row for row in result['results'] if row['path'] == path]
    assert len(executions) == 2 and {row['strict'] for row in executions} == {False, True}
    for row in executions:
        assert row['passed'] and row['sha256'] == record['sha256']
        assert row['direct_assertion_sites'] == record['direct_assertion_sites'] and row['property_helper_sites'] == record['property_helper_sites']
        assert row['harness'] == ['sta.js', 'assert.js', *record['includes']]
        typed = any(name in record['includes'] for name in ['testTypedArray.js', 'resizableArrayBufferUtils.js'])
        assert bool(row['constructors']) == typed

for harness in result['harness']:
    assert fingerprint(UPSTREAM / 'harness' / harness['name']) == harness['sha256']

assert audit['reviewed'] == {'adapted': 690, 'equivalent': 103, 'excluded': 1645}
assert audit['unreviewed'] == 51159 and audit['catalog_cases'] == 80155 and audit['linked_cases'] == 4933
sources = {str(path.relative_to(ROOT)): fingerprint(path) for path in [source, generated, ROOT / 'packages/test/src/generate_for_each_reviews.ts', ROOT / 'packages/test/upstream/lock.json']}
evidence = {str(path.relative_to(ROOT)): fingerprint(path) for path in DIRECTORY.iterdir() if path.is_file() and path.name != '验证结果.json'}
report = {
    '固定原文检出': lock['revision'],
    '新增审阅': 11,
    '新增状态': 'excluded',
    '原文执行': {'普通': 11, '严格': 11, '总计': 22, '参考运行时': result['node_version']},
    '断言计数边界': '源码调用点与辅助函数循环不计为动态执行次数；冻结原文以正常完成为判据',
    '目录闭合': closure,
    '新增ZX目录案例': 0,
    '当前矩阵': audit,
    '命令退出码': {'原文验证': 0, '生成审阅': 0, '生成一致性检查': 0, '矩阵审计': 0, '剩余查询': 0, '登记重复执行': 0},
    '源指纹': sources,
    '证据指纹': evidence,
    '边界': '完整目录审阅及明确语言排除；不等于ZX支持forEach；未运行全量Zig回归',
}

(DIRECTORY / '验证结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print('11 reviews, 22 original executions, and complete 190-file directory verified')
