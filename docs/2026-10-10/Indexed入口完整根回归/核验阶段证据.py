import gzip
import hashlib
import json
from pathlib import Path
import subprocess


doc = Path(__file__).resolve().parent
root = doc.parents[2]


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


records = json.loads((doc / '归档清单.json').read_text())

for record in records:
    saved = (doc / record['saved']).read_bytes()
    assert len(saved) == record['saved_bytes']
    assert hashlib.sha256(saved).hexdigest() == record['saved_sha256']
    raw = gzip.decompress(saved) if record['encoding'] == 'gzip' else saved
    assert len(raw) == record['raw_bytes']
    assert hashlib.sha256(raw).hexdigest() == record['raw_sha256']

    for origin in record['origins']:
        if record['prefix_snapshot']:
            with Path(origin).open('rb') as stream:
                assert stream.read(len(raw)) == raw, origin
        else:
            assert digest(origin) == record['raw_sha256'], origin

original = json.loads((doc / '根回归阶段证据/起点.json.txt').read_text())
corrected = json.loads((doc / '冷构建证据/起点.json.txt').read_text())
terminal = json.loads((doc / '冷构建证据/终态.json.txt').read_text())
state = json.loads((doc / '阶段状态.json').read_text())
name = 'packages/test/tests/build_modes/build_test.ts'
assert original['source_commit'] == corrected['source_commit']
assert [key for key in original['sources'] if original['sources'][key] != corrected['sources'][key]] == [name]
assert set(corrected['overlays']) == {name}
assert digest(root / name) == corrected['sources'][name]
assert terminal['terminal_exit_code'] == 0
assert not any(terminal[key] for key in ('changed_sources', 'changed_tools', 'changed_dependencies'))
assert digest(doc / '运行构建模式.py') == terminal['runner_sha256']
assert digest(doc / '冷构建证据/执行日志.txt') == terminal['log_sha256']
assert state['corrected_gate_duration_seconds'] > 180
assert state['root_debug_terminal_at_snapshot'] is False
assert state['generated_compiler_modules'] == 87
assert len([row for row in records if row['saved'].startswith('生成编译器/')]) == 87

checked = {}

for manifest in (original, corrected):
    cwd = Path(manifest['cwd'])
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=cwd, text=True).strip() == manifest['source_commit']

    for relative, expected in manifest['sources'].items():
        checked[str(cwd / relative)] = expected

    for tool in manifest['tools'].values():
        checked[tool['path']] = tool['sha256']

    for group in ('node_dependencies', 'zig_library'):
        assert original[group] == corrected[group]
        checked.update(manifest[group])

for path, expected in checked.items():
    assert digest(path) == expected, path

print('PASS: cold build-mode execution, immutable inputs, 87 generated modules and labeled root snapshot')
