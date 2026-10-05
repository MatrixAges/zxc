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
source = ROOT / 'packages/test/src/data/for_each.jsonl'
generated = ROOT / 'packages/test/upstream/reviews/built_ins/array/for_each.jsonl'
lock = json.loads((ROOT / 'packages/test/upstream/lock.json').read_text())
indexed = {row['path']: row['sha256'] for row in map(json.loads, (ROOT / 'packages/test/upstream/index/built-ins.jsonl').read_text().splitlines())}
rows = {row['path']: row for row in map(json.loads, source.read_text().splitlines())}
assert source.read_bytes() == generated.read_bytes()
assert len(rows) == 95 and len(records) == 37
assert {row['path'] for row in records} == {path for path in indexed if path.startswith(('test/built-ins/Array/prototype/forEach/15.4.4.18-3-', 'test/built-ins/Array/prototype/forEach/15.4.4.18-4-'))}
assert lock['revision'] == UPSTREAM.name.removeprefix('test262-')
assert sum(row['original_assertions'] for row in records) == 46
assert result['files'] == 37 and len(result['results']) == 74

for record in records:
    path = record['path']
    assert fingerprint(UPSTREAM / path) == indexed[path] == record['sha256']
    assert rows[path] == {key: record[key] for key in ['path', 'sha256', 'status', 'reason', 'contract', 'cases', 'assertions']}
    executions = [row for row in result['results'] if row['path'] == path]
    assert len(executions) == 2 and {row['strict'] for row in executions} == {False, True}
    assert all(row['passed'] and row['original_assertions'] == record['original_assertions'] and row['sha256'] == record['sha256'] for row in executions)

for harness in result['harness']:
    assert fingerprint(UPSTREAM / 'harness' / harness['name']) == harness['sha256']

assert audit['reviewed'] == {'adapted': 690, 'equivalent': 103, 'excluded': 1550}
assert audit['unreviewed'] == 51254 and audit['catalog_cases'] == 80155 and audit['linked_cases'] == 4933
sources = {str(path.relative_to(ROOT)): fingerprint(path) for path in [source, generated, ROOT / 'packages/test/src/generate_for_each_reviews.ts', ROOT / 'packages/test/upstream/lock.json']}
evidence = {str(path.relative_to(ROOT)): fingerprint(path) for path in DIRECTORY.iterdir() if path.is_file() and path.name != '验证结果.json'}
report = {
    '固定原文检出': lock['revision'],
    '新增审阅': 37,
    '新增状态': 'excluded',
    '原文执行': {'普通': 37, '严格': 37, '总计': 74, '顶层断言总计': 92},
    '新增ZX目录案例': 0,
    '当前矩阵': audit,
    '命令退出码': {'原文验证': 0, '生成审阅': 0, '生成一致性检查': 0, '矩阵审计': 0, '登记重复执行': 0},
    '源指纹': sources,
    '证据指纹': evidence,
    '边界': '原文断言与明确语言差异审阅；不等于 ZX 行为通过；未运行全量 Zig 回归',
}

(DIRECTORY / '验证结果.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print('37 reviews and 74 original executions verified')
