# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

doc = Path(__file__).resolve().parent
root = doc.parents[2]
manifest = json.loads((doc / '输入清单.json').read_text())
worktree = Path(manifest['worktree'])


def read(name):
    return json.loads((doc / name).read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for row in manifest['paths']:
    assert digest(worktree / row['path']) == row['sha256'], row['path']
    assert digest(doc / '草稿' / row['path']) == row['sha256'], row['path']
    if '--formal' in sys.argv:
        assert digest(root / row['path']) == row['sha256'], row['path']

for row in read('原有修改清单.json'):
    assert digest(root / row['path']) == row['sha256'], row['path']

catalog = {}
for method in ['every', 'some']:
    path = worktree / ('packages/test/tests/built_ins/list/predicates/observations/' + method + '.jsonl')
    for line in path.read_text().splitlines():
        row = json.loads(line)
        assert row['id'] not in catalog
        catalog[row['id']] = row
assert len(catalog) == 173

for mode in ['Debug', 'ReleaseSafe']:
    for label in [mode, '相邻' + mode, '旧观察' + mode]:
        gate = read(label + '执行结果.json')
        assert gate['exit_code'] == 0 and gate['source_commit'] == manifest['source_commit'], label
        assert gate['inputs'] == manifest['paths'], label
        assert digest(doc / (label + '原始日志.txt')) == gate['log_sha256'], label

    record = read(mode + '产物清单.json')
    assert record['source_commit'] == manifest['source_commit'] and record['inputs'] == manifest['paths']
    assert record['actual_checks'] == 346 and len(record['executions']) == 4
    assert {row['kind'] for row in record['executions']} == {'every-source', 'every-library', 'some-source', 'some-library'}
    for execution in record['executions']:
        assert execution['status'] == execution['compile_status'] == execution['metadata']['status'] == 0
        assert '--test-no-exec' not in execution['metadata']['argv']
        assert (execution['metadata']['native_identity'] is not None) == execution['kind'].endswith('-library')
        method = execution['kind'].split('-')[0]
        expected = [id for id in catalog if id.startswith('built_ins/list/predicates/observations/' + method + '/')]
        assert execution['test_names'] == expected
        assert digest(Path(execution['argv'][0])) == execution['binary_sha256']
        assert digest(doc / execution['log']) == execution['log_sha256']
        assert digest(doc / execution['compile_log']) == execution['compile_log_sha256']
        names = re.findall(r'\d+/\d+ (.+?)\.\.\.OK', (doc / execution['log']).read_text())
        assert [name.removeprefix('cases.test.') for name in names] == expected
        for file in execution['files']:
            assert digest(doc / file['saved_path']) == file['sha256']
            assert digest(Path(file['actual_path'])) == file['sha256']

    old = read('旧观察' + mode + '重放清单.json')
    assert old['actual_checks'] == 145 and old['inputs'] == manifest['paths']
    assert old['source_commit'] == manifest['source_commit']
    for execution in old['executions']:
        assert execution['status'] == 0
        assert digest(Path(execution['argv'][0])) == execution['binary_sha256']
        assert digest(doc / execution['log']) == execution['log_sha256']

samples = read('上游输入清单.json')
original = read('上游执行结果.json')
assert len(samples) == 13 and len(original['executions']) == 26 and original['actual_assertions'] == 54
indexed = {}
for line in (root / 'packages/test/upstream/index/built-ins.jsonl').read_text().splitlines():
    row = json.loads(line)
    indexed[row['path']] = row['sha256']
for sample in samples:
    assert indexed[sample['path']] == sample['sha256']
    assert digest(doc / '上游原文' / (sample['path'] + '.txt')) == sample['sha256']
    executions = [row for row in original['executions'] if row['path'] == sample['path']]
    assert len(executions) == 2 and {row['strict'] for row in executions} == {True, False}
    assert all(row['status'] == 0 and row['sha256'] == sample['sha256'] for row in executions)

mappings = read('逐项断言映射.json')
assert len(mappings) == 13 and sum(len(row['assertions']) for row in mappings) == 27
for row in mappings:
    expected = catalog[row['case']]['expected']
    for assertion in row['assertions']:
        value = expected[assertion['field']]
        if assertion['field'] == 'input':
            index = int(assertion['original']['message'][4:-1])
            value = value[index]
        assert value == assertion['preserved_value'] == assertion['original']['expected'] == assertion['original']['actual']

for row in read('负向观察结果.json'):
    assert row['compile_status'] == 0 and row['status'] != 0
    assert row['observed_calls'] == row['expected_calls'] + 1
    assert digest(doc / row['mutated_program']) == row['mutated_program_sha256']
    assert digest(doc / row['log']) == row['log_sha256']
    assert digest(Path(row['argv'][0])) == row['binary_sha256']

audit = read('矩阵审计.json')
assert audit['catalog_cases'] == 83490 and audit['unreviewed'] == 50760
assert audit['reviewed'] == {'adapted': 771, 'excluded': 1963, 'equivalent': 103}

for check in read('辅助核验结果.json'):
    assert check['exit_code'] == 0
    assert digest(doc / check['log']) == check['log_sha256']

if '--staged' in sys.argv:
    staged = {p for p in subprocess.check_output(['git', 'diff', '--cached', '--name-only', '-z'], cwd=root).decode().split('\0') if p}
    expected = {row['path'] for row in manifest['paths']} | {str(path.relative_to(root)) for path in doc.rglob('*') if path.is_file()}
    assert staged == expected, (staged - expected, expected - staged)

print('Verified: 17 inputs, 173 cases, 346 checks per mode, 27 mapped assertions, 54 original assertions, preserved foreign changes')
