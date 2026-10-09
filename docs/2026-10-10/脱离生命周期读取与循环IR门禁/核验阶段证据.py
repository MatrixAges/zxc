import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
archives = json.loads((doc / '归档清单.json').read_text())
decoded = {}


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


for row in archives:
    saved = (doc / row['saved']).read_bytes()
    raw = gzip.decompress(saved) if row['encoding'] == 'gzip' else saved
    assert len(saved) == row['saved_bytes'] and len(raw) == row['raw_bytes']
    assert hashlib.sha256(saved).hexdigest() == row['saved_sha256']
    assert hashlib.sha256(raw).hexdigest() == row['raw_sha256']
    assert digest(row['source']) == row['raw_sha256']
    decoded[row['saved'].removesuffix('.gz')] = raw

first = json.loads(decoded['r1/起点.json.txt'])
formal = json.loads(decoded['r2/起点.json.txt'])
name = 'packages/test/tests/collections/detached_reader/shape.zig'
assert first['source_commit'] == formal['source_commit'] == 'fe7bfd6b7c6908cba9905e5d3f2472b589e887ab'
assert set(first['sources']) == set(formal['sources'])
assert [key for key in first['sources'] if first['sources'][key] != formal['sources'][key]] == [name]
assert set(first['overlays']) == set(formal['overlays']) == {name}
assert digest(root / name) == formal['sources'][name]
assert digest(doc / '首轮草稿/shape.zig.txt') == first['sources'][name]

identities = {}

for manifest in (first, formal):
    cwd = Path(manifest['cwd'])
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=cwd, text=True).strip() == manifest['source_commit']
    identities.update({str(cwd / path): identity for path, identity in manifest['sources'].items()})
    identities.update({tool['path']: tool['sha256'] for tool in manifest['tools'].values()})

    for group in ('node_dependencies', 'zig_library'):
        assert first[group] == formal[group]
        identities.update(manifest[group])

for path, identity in identities.items():
    assert digest(path) == identity, path

for round_name, modes in (('r1', ('debug',)), ('r2', ('debug', 'safe'))):
    for mode in modes:
        terminal = json.loads(decoded[round_name + '/' + mode + '.terminal.json.txt'])
        assert terminal['terminal_exit_code'] == (1 if round_name == 'r1' else 0)
        assert not terminal['changed_inputs']
        assert terminal['runner_sha256'] == digest(doc / '运行读取门禁.py')
        assert hashlib.sha256(decoded[round_name + '/' + mode + '.log.txt']).hexdigest() == terminal['log_sha256']

        if round_name == 'r1':
            assert terminal['build_summaries'] == ['Build Summary: 42/93 steps succeeded (10 failed)']
            assert decoded['r1/debug.log.txt'].count(b'error: InvalidCollectionIterations\n') == 10
        else:
            assert re.findall(r'(\d+)/(\d+) tests passed', '\n'.join(terminal['build_summaries'])) == [('156', '156')]

binaries = json.loads((doc / '运行二进制.json').read_text())
assert len(binaries) == 40
fixtures = {'object', 'tuple', 'optional', 'projection', 'nested', 'concat', 'reference', 'reverse', 'prefix', 'offset'}
expected = {'detached-reader-' + fixture + '-' + route for fixture in fixtures for route in ('source', 'library')}

for mode in ('debug', 'safe'):
    rows = [row for row in binaries if row['mode'] == mode]
    assert len(rows) == 20 and {Path(row['path']).name for row in rows} == expected

for row in binaries:
    assert row['round'] == 'r2' and digest(row['path']) == row['sha256']
    assert Path(row['path']).stat().st_size == row['bytes']

generated = json.loads((doc / '生成器身份.json').read_text())
assert len(generated) == 91

for item in generated.values():
    assert len(item['origins']) == 3
    assert all(digest(path) == item['sha256'] for path in item['origins'])

result = json.loads((doc / '执行结果.json').read_text())
assert result['named_test_executions'] == 312 and result['run_nodes'] == 40
assert result['generated_compiler_modules'] == 91
print('PASS: failed draft preserved; 312 executions, 40 nodes, 91 generated modules and immutable inputs')
