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
assert len(manifest['paths']) == 10

for row in manifest['paths']:
    for base in [root, worktree, doc / '草稿']:
        assert sha(base / row['path']) == row['sha256'], str(base / row['path'])

for row in json.loads((doc / '原有修改清单.json').read_text()):
    assert sha(root / row['path']) == row['sha256'], row['path']

kinds = ['object', 'tuple', 'optional', 'projection', 'nested', 'concat', 'reference', 'reverse', 'prefix', 'offset']
maps = []

for mode in ['Debug', 'ReleaseSafe']:
    for prefix, count in [('', 156), ('独立', 28)]:
        label = prefix + mode
        record = json.loads((doc / (label + '执行结果.json')).read_text())
        assert record['exit_code'] == 0 and record['source_commit'] == manifest['source_commit']
        assert record['inputs'] == manifest['paths']
        assert sha(doc / (label + '原始日志.txt')) == record['log_sha256']
        log = (doc / (label + '原始日志.txt')).read_text()
        assert re.search(r'Build Summary: \d+/\d+ steps succeeded; ' + str(count) + '/' + str(count) + ' tests passed', log)

    evidence = json.loads((doc / (mode + '产物清单.json')).read_text())
    assert {(item['kind'], item['route']) for item in evidence} == {(kind, route) for kind in kinds for route in ['source', 'library']}
    assert len(evidence) == 20 and sum(item['test_count'] for item in evidence) == 156
    assert sum(item['test_count'] for item in evidence if item['kind'] in ['prefix', 'offset']) == 28
    mapping = {}

    for item in evidence:
        assert item['exit_code'] == 0 and item['test_count'] == len(item['test_names'])
        assert sha(Path(item['replay_argv'][0])) == item['binary_sha256']
        assert sha(doc / item['output_path']) == item['output_sha256']
        names = re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$', (doc / item['output_path']).read_text(), re.M)
        assert names == item['test_names']

        for file in item['files']:
            assert sha(Path(file['actual_path'])) == sha(doc / file['saved_path']) == file['sha256']
            mapping[(item['kind'], item['route'], file['module'])] = file['sha256']

    for kind in kinds:
        assert mapping[(kind, 'source', 'program')] != mapping[(kind, 'library', 'program')]

    maps.append(mapping)

assert maps[0] == maps[1]
compile_source = (worktree / 'packages/test/tests/collections/detached_reader/compile.zig').read_text()
assert '.compiled_libraries =' in compile_source and '.entry = "consumer.zx"' in compile_source
assert '@memset(bytes, 0);' in compile_source and 'try emit(init, consumer.value.ir, args[4..6]);' in compile_source
assert all(len(path.read_text().splitlines()) < 1000 for path in doc.rglob('*.md'))
print('Verified: 20 routes and 156 actual named checks per mode; all 28 new view checks; real compiled-library consumers; exact input and artifact SHAs; unchanged foreign edits')
