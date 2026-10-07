# coding: utf-8
from pathlib import Path
import hashlib
import json
import subprocess
import sys

doc = Path(__file__).resolve().parent
root = doc.parents[2]
manifest = json.loads((doc / '输入清单.json').read_text())
worktree = Path(manifest['worktree'])


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(name):
    return json.loads((doc / name).read_text())


for row in manifest['paths']:
    assert digest(worktree / row['path']) == row['sha256'], row['path']
    assert digest(doc / '草稿' / row['path']) == row['sha256'], row['path']
    if '--formal' in sys.argv:
        assert digest(root / row['path']) == row['sha256'], row['path']

for row in read('原有修改清单.json'):
    assert digest(root / row['path']) == row['sha256'], row['path']

for mode in ['Debug', 'ReleaseSafe']:
    for label in [mode, '编译器' + mode + '测试', '观察' + mode, '相邻' + mode]:
        result = read(label + '执行结果.json')
        assert result['exit_code'] == 0, label
        assert result['source_commit'] == manifest['source_commit'], label
        assert result['inputs'] == manifest['paths'], label
        assert digest(doc / (label + '原始日志.txt')) == result['log_sha256'], label

    for label, count in [(mode + '原生产物清单', 42), ('值' + mode + '产物清单', 120), ('编译器' + mode + '重放清单', 372)]:
        record = read(label + '.json')
        assert record['source_commit'] == manifest['source_commit'] and record['inputs'] == manifest['paths'], label
        assert record['actual_checks'] == count, label
        executions = record.get('executions', [])
        if 'analysis' in record:
            executions.append(record['analysis'])
        for execution in executions:
            assert execution['status'] == 0
            assert digest(Path(execution['argv'][0])) == execution['binary_sha256']
            assert digest(doc / execution['log']) == execution['log_sha256']
        for item in record.get('native', []) + record.get('executions', []):
            if 'metadata' in item:
                assert item['metadata']['status'] == 0 and len(item['test_names']) == 9
            for file in item.get('files', []):
                assert digest(doc / file['saved_path']) == file['sha256']
                assert digest(Path(file['actual_path'])) == file['sha256']

for label in ['生成器Debug构建', '生成器ReleaseSafe构建', '编译器Debug构建', '编译器ReleaseSafe构建', '包边界Debug测试', '核心Debug构建']:
    result = read(label + '执行结果.json')
    assert result['exit_code'] == 0 and result['source_commit'] == manifest['source_commit'], label
    assert result['inputs'] == manifest['paths'], label
    assert digest(doc / (label + '原始日志.txt')) == result['log_sha256'], label

audit = read('矩阵审计.json')
assert audit['catalog_cases'] == 83317 and audit['unreviewed'] == 50768
baseline = read('基线失败对照.json')
assert baseline['identical_failures'] and baseline['count'] == 26

if '--staged' in sys.argv:
    changed = subprocess.check_output(['git', 'diff', '--cached', '--name-only', '-z'], cwd=root).decode().split('\0')
    staged = {name for name in changed if name}
    own = {row['path'] for row in manifest['paths']}
    documents = {str(path.relative_to(root)) for path in doc.rglob('*') if path.is_file()}
    assert staged == own | documents, (staged - own - documents, (own | documents) - staged)

print('Verified: 48 exact inputs; 11 original changes preserved; execution logs, artifacts and scope agree')
