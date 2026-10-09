import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]
decoded = {}


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


for row in json.loads((doc / '归档清单.json').read_text()):
    saved = (doc / row['saved']).read_bytes()
    raw = gzip.decompress(saved) if row['encoding'] == 'gzip' else saved
    assert len(saved) == row['saved_bytes'] and len(raw) == row['raw_bytes']
    assert hashlib.sha256(saved).hexdigest() == row['saved_sha256']
    assert hashlib.sha256(raw).hexdigest() == row['raw_sha256']
    assert digest(row['source']) == row['raw_sha256']
    decoded[row['saved'].removesuffix('.gz')] = raw

manifest = json.loads(decoded['r1/起点.json.txt'])
assert manifest['source_commit'] == '460caf3776b07a47c80561966c19b3bdd679faf1'
cwd = Path(manifest['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=cwd, text=True).strip() == manifest['source_commit']
identities = {str(cwd / name): value for name, value in manifest['sources'].items()}
identities.update({tool['path']: tool['sha256'] for tool in manifest['tools'].values()})

for group in ('node_dependencies', 'zig_library'):
    identities.update(manifest[group])

for path, identity in identities.items():
    assert digest(path) == identity, path

name = 'packages/test/tests/collections/aggregate_loop/shape.zig'
assert set(manifest['overlays']) == {name}
assert digest(root / name) == manifest['overlays'][name]['sha256']
assert (root / name).read_bytes() == decoded['正式形态检查.zig.txt']

for mode in ('debug', 'safe'):
    terminal = json.loads(decoded['r1/' + mode + '.terminal.json.txt'])
    assert terminal['terminal_exit_code'] == 0 and not terminal['changed_inputs']
    assert terminal['runner_sha256'] == digest(doc / '运行聚合门禁.py')
    assert hashlib.sha256(decoded['r1/' + mode + '.log.txt']).hexdigest() == terminal['log_sha256']
    assert re.findall(r'(\d+)/(\d+) tests passed', '\n'.join(terminal['build_summaries'])) == [('102', '102')]

binaries = json.loads((doc / '运行二进制.json').read_text())
fixtures = {'stack', 'call', 'bounds', 'nested', 'two_lanes', 'escaping', 'old_list', 'consumer'}
expected = {'aggregate-loop-' + fixture + '-' + route for fixture in fixtures for route in ('source', 'library')}
assert len(binaries) == 32

for mode in ('debug', 'safe'):
    rows = [row for row in binaries if row['mode'] == mode]
    assert len(rows) == 16 and {Path(row['path']).name for row in rows} == expected

for row in binaries:
    assert row['round'] == 'r1' and digest(row['path']) == row['sha256']
    assert Path(row['path']).stat().st_size == row['bytes']

generated = json.loads((doc / '生成器身份.json').read_text())
assert len(generated) == 91

for item in generated.values():
    assert len(item['origins']) == 2
    assert all(digest(path) == item['sha256'] for path in item['origins'])

result = json.loads((doc / '执行结果.json').read_text())
assert result['named_test_executions'] == 204 and result['run_nodes'] == 32
assert result['generated_compiler_modules'] == 91
print('PASS: 204 executions, 32 run nodes, 91 generated modules and immutable inputs')
