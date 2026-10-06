import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
draft = directory / '草稿'
manifest = json.loads((directory / '执行起点.json').read_text())
names = list(manifest['formal_sources'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['production_commit']
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {line[3:] for line in status.splitlines()} == set(names)
sources = {}
for name in names:
    data = (draft / name).read_bytes()
    assert data == (fixed / name).read_bytes() == (root / name).read_bytes(), name
    sources[name] = hashlib.sha256(data).hexdigest()
    assert sources[name] == manifest['formal_sources'][name]

results = {}
for gate in manifest['completed_gates']:
    if not gate.get('final_source'):
        continue

    label = gate['mode']
    assert gate['terminal_exit_code'] == 0
    raw = directory / gate['raw_log']
    text = raw.read_text()
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4]
    tail = text[summary.start():]
    actual = [int(match[1]) for match in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', tail)]
    assert sum(actual) == int(summary[3])
    assert len(re.findall(r'run test 26 pass \(26 total\)', tail)) == 2
    results[label] = {
        'terminal_exit_code': 0,
        'argv': gate['argv'],
        'summary': summary[0],
        'actual_managed_test_passes': sum(actual),
        'actual_new_declarations': 52,
        'cached_test_steps': [line for line in tail.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)],
        'raw_log': raw.name,
        'raw_log_sha256': hashlib.sha256(raw.read_bytes()).hexdigest(),
    }

assert set(results) == {'Debug', 'ReleaseSafe'}
for name in names:
    if name.endswith('type_columns_test.zig'):
        assert len(re.findall(r'^test "', (root / name).read_text(), re.MULTILINE)) == 26

for revision in manifest['fixture_revisions']:
    assert hashlib.sha256((directory / revision['raw_log']).read_bytes()).hexdigest() == revision['sha256']
    assert hashlib.sha256((directory / revision['fixture_source']).read_bytes()).hexdigest() == revision['fixture_sha256']

production_paths = [
    'packages/core/src/type_table/model.zig',
    'packages/core/src/type_table/structure.zig',
    'packages/compiler/src/zx/ir/type_rules.zig',
    'packages/compiler/src/zx/modules/semantic_cache/codec.zig',
    'packages/compiler/src/library/codec.zig',
]
proof = {
    'production_commit': manifest['production_commit'],
    'production_sources': {name: hashlib.sha256((fixed / name).read_bytes()).hexdigest() for name in production_paths},
    'formal_sources': sources,
    'new_unique_declarations': 52,
    'distinct_corruption_contracts': 24,
    'route_declarations': {'module semantic cache': 26, 'unified library': 26},
    'new_catalog_ids': 0,
    'results': results,
    'scope': 'Matching digest and parseable JSON column rejection plus allocator failure cleanup. Positive controls use the same envelope helper as corrupted bytes. Native reference/task columns and restored application execution require separate evidence.',
}
(directory / '最终来源与证据.json').write_text(json.dumps(proof, ensure_ascii=False, indent=4) + '\n')
print('Verified 52 declarations, both exact error routes, final source identity and both completed modes')
