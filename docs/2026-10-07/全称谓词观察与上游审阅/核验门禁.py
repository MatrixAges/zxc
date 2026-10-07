# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
root = doc.parents[2]
manifest = json.loads((doc / '输入清单.json').read_text())
worktree = Path(manifest['worktree'])
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=worktree).decode().strip() == manifest['source_commit']
assert len(manifest['paths']) == 13

for row in manifest['paths']:
    for base in [root, worktree, doc / '草稿']:
        assert sha(base / row['path']) == row['sha256'], str(base / row['path'])

for row in json.loads((doc / '原有修改清单.json').read_text()):
    assert sha(root / row['path']) == row['sha256'], row['path']

inventory = json.loads((doc / '原文核对.json').read_text())
originals = json.loads((doc / '原文结果.json').read_text())
assert originals['files'] == 5 and originals['executions'] == 10
assert originals['revision'] == inventory['revision'] and all(row['passed'] for row in originals['results'])

for row in inventory['files']:
    assert sha(Path(inventory['source_root']) / row['path']) == row['sha256']
    assert sha(doc / '上游原文' / (Path(row['path']).name + '.txt')) == row['sha256']

counts = {'value': 62, 'index': 61, 'all': 14, 'rows': 8}
maps = []

for mode in ['Debug', 'ReleaseSafe']:
    record = json.loads((doc / (mode + '执行结果.json')).read_text())
    assert record['exit_code'] == 0 and record['source_commit'] == manifest['source_commit']
    assert record['inputs'] == manifest['paths']
    assert sha(doc / (mode + '原始日志.txt')) == record['log_sha256']
    assert re.search(r'Build Summary: \d+/\d+ steps succeeded; 145/145 tests passed', (doc / (mode + '原始日志.txt')).read_text())
    evidence = json.loads((doc / (mode + '产物清单.json')).read_text())
    assert {item['kind'] for item in evidence} == set(counts)
    assert len(evidence) == 4 and sum(item['test_count'] for item in evidence) == 145
    mapping = {}

    for item in evidence:
        catalog = worktree / ('packages/test/tests/built_ins/list/callbacks/every/' + item['kind'] + '/cases.jsonl')
        ids = [json.loads(line)['id'] for line in catalog.read_text().splitlines()]
        assert item['exit_code'] == 0 and item['test_count'] == len(ids) == counts[item['kind']]
        assert item['test_names'] == ids
        assert sha(Path(item['replay_argv'][0])) == item['binary_sha256']
        assert sha(doc / item['output_path']) == item['output_sha256']
        names = re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$', (doc / item['output_path']).read_text(), re.M)
        assert names == ids

        for file in item['files']:
            assert sha(Path(file['actual_path'])) == sha(doc / file['saved_path']) == file['sha256']
            mapping[(item['kind'], file['module'])] = file['sha256']

    maps.append(mapping)

assert maps[0] == maps[1]
control = json.loads((doc / '反向检查.json').read_text())
assert control['exit_code'] != 0
assert {name.rsplit('/', 1)[1] for name in control['failed_names']} == {'stopped_before_empty', 'stopped_after_true'}
assert sha(doc / control['fault_source']) == control['fault_sha256']
assert sha(doc / control['output_path']) == control['output_sha256']
review = root / 'packages/test/upstream/reviews/built_ins/array/every_observers.jsonl'
assert len(review.read_text().splitlines()) == 5
assert all(len(path.read_text().splitlines()) < 1000 for path in doc.rglob('*.md'))
print('Verified: 145 named checks per mode, five full upstream observation mappings, ten original runs, exact source/artifact SHAs, and unchanged foreign edits')
