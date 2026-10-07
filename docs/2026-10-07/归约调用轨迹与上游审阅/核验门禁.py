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

for row in manifest['paths']:
    for base in [root, worktree, doc / '草稿']:
        assert sha(base / row['path']) == row['sha256'], str(base / row['path'])

for row in json.loads((doc / '原有修改清单.json').read_text()):
    assert sha(root / row['path']) == row['sha256'], row['path']

catalog = root / 'packages/test/tests/built_ins/list/callbacks/reduce/observers/cases.jsonl'
cases = [json.loads(line) for line in catalog.read_text().splitlines()]
ids = [row['id'] for row in cases]
assert len(ids) == len(set(ids)) == 63

for row in cases:
    visits = row['expected']['value']['visits']
    assert len(visits) == len(row['input']['items'])
    assert [visit['current'] for visit in visits] == row['input']['items']
    if visits:
        assert visits[0]['previous'] == row['input']['seed']
        assert [visit['previous'] for visit in visits[1:]] == row['input']['items'][:-1]
    assert row['expected']['value']['value'] == (row['input']['items'][-1] if visits else row['input']['seed'])

inventory = json.loads((doc / '原文核对.json').read_text())
originals = json.loads((doc / '原文结果.json').read_text())
assert originals['files'] == 3 and originals['executions'] == 6
assert originals['revision'] == inventory['revision']
assert all(row['passed'] for row in originals['results'])

for row in inventory['files']:
    assert sha(Path(inventory['source_root']) / row['path']) == row['sha256']
    assert sha(doc / '上游原文' / (Path(row['path']).name + '.txt')) == row['sha256']

maps = []
for mode in ['Debug', 'ReleaseSafe']:
    record = json.loads((doc / (mode + '执行结果.json')).read_text())
    assert record['exit_code'] == 0 and record['source_commit'] == manifest['source_commit']
    assert record['inputs'] == manifest['paths']
    assert sha(doc / (mode + '原始日志.txt')) == record['log_sha256']
    log = (doc / (mode + '原始日志.txt')).read_text()
    assert re.search(r'Build Summary: \d+/\d+ steps succeeded; 63/63 tests passed', log)
    evidence = json.loads((doc / (mode + '产物清单.json')).read_text())
    assert evidence['source_commit'] == manifest['source_commit'] and evidence['exit_code'] == 0
    assert evidence['test_count'] == 63 and evidence['test_names'] == ids
    assert sha(Path(evidence['replay_argv'][0])) == evidence['binary_sha256']
    assert sha(doc / evidence['output_path']) == evidence['output_sha256']
    named = re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$', (doc / evidence['output_path']).read_text(), re.M)
    assert named == ids
    mapping = {}

    for item in evidence['files']:
        assert sha(Path(item['actual_path'])) == sha(doc / item['saved_path']) == item['sha256']
        mapping[Path(item['saved_path']).name] = item['sha256']

    maps.append(mapping)

assert maps[0] == maps[1]
control = json.loads((doc / '反向检查.json').read_text())
assert control['exit_code'] != 0 and len(control['failed_names']) == 45
assert any(name.endswith('/original_chain') for name in control['failed_names'])
assert sha(doc / control['fault_source']) == control['fault_sha256']
assert sha(doc / control['output_path']) == control['output_sha256']

neighbor = json.loads((doc / '相邻Debug执行结果.json').read_text())
assert neighbor['exit_code'] == 0 and neighbor['source_commit'] == manifest['source_commit']
assert neighbor['inputs'] == manifest['paths']
assert sha(doc / '相邻Debug原始日志.txt') == neighbor['log_sha256']
assert all(len(path.read_text().splitlines()) < 1000 for path in doc.rglob('*.md'))
print('Verified: 63 named checks per mode, 3 complete upstream mappings, 45 meaningful negative failures, adjacent execution, and unchanged foreign edits')
