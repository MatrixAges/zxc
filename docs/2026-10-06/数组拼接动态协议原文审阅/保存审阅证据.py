import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
metadata = json.loads((directory / '原文metadata.json').read_text())
reference = json.loads((directory / '原文结果.json').read_text())
assert len(metadata) == reference['unchanged_original_files'] == 69
assert reference['unchanged_original_executions'] == 137
assert reference['unchanged_passed_executions'] == 135
assert reference['unchanged_failed_executions'] == 2 and reference['zxc_passes'] == 0
assert reference['script_sha256'] == hashlib.sha256((directory / '原文验证.mjs').read_bytes()).hexdigest()
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
indexed = {row['path']: row for row in metadata}
actual = {row['path']: row for row in reference['results']}
assert set(actual) == set(indexed)
for path, entry in indexed.items():
    saved = directory / '原文' / (Path(path).stem + '.txt')
    assert saved.read_bytes() == (upstream / path).read_bytes()
    assert hashlib.sha256(saved.read_bytes()).hexdigest() == entry['sha256'] == actual[path]['sha256']
    modes = actual[path]['modes']
    assert [row['strict'] for row in modes] == ([False] if 'noStrict' in entry.get('flags', []) else [False, True])
    for row in modes:
        failed = path.endswith('/arg-length-near-integer-limit.js')
        assert row['unchanged_passed'] is not failed
        assert (row['failure'] is not None) == failed
        if failed:
            assert 'no exception was thrown' in row['failure']['message']

for name, digest in reference['harnesses'].items():
    assert hashlib.sha256((upstream / 'harness' / name).read_bytes()).hexdigest() == digest

node = json.loads((directory / '独立Node复核.json').read_text())
assert node['script_sha256'] == hashlib.sha256((directory / '独立Node复核.mjs').read_bytes()).hexdigest()
assert len(node['results']) == 2
original = directory / '原文/arg-length-near-integer-limit.txt'
for row in node['results']:
    assert row['terminal_exit_code'] == 1
    assert row['argv'][1:] == ['--input-type=commonjs']
    data = Path(row['standard_input_file']).read_bytes()
    assert data.endswith(original.read_bytes())
    assert hashlib.sha256(data).hexdigest() == row['assembled_script_sha256']
    assert hashlib.sha256(original.read_bytes()).hexdigest() == row['unchanged_original_sha256']
    log = Path(row['raw_log'])
    assert hashlib.sha256(log.read_bytes()).hexdigest() == row['raw_log_sha256']
    assert 'no exception was thrown' in log.read_text()

name = 'packages/test/upstream/reviews/built_ins/array/concat_dynamic_protocols.jsonl'
formal = root / name
draft = directory / '草稿' / name
assert formal.read_bytes() == draft.read_bytes()
rows = [json.loads(line) for line in formal.read_text().splitlines()]
assert len(rows) == 68
assert len({row['path'] for row in rows}) == 68
assert all(row['status'] == 'excluded' and not row['cases'] for row in rows)
assert {row['path'] for row in rows} == set(indexed) - {'test/built-ins/Array/prototype/concat/S15.4.4.4_A1_T1.js'}
assert all(row['sha256'] == indexed[row['path']]['sha256'] for row in rows)
old = root / 'packages/test/upstream/reviews/built_ins/array/dense_values.jsonl'
assert old.read_bytes() == subprocess.check_output(['git', 'show', '670c271c:packages/test/upstream/reviews/built_ins/array/dense_values.jsonl'], cwd=root)
before = json.loads((directory / '审阅前矩阵审计日志.txt').read_text())
after = json.loads((directory / '审阅后矩阵审计日志.txt').read_text())
assert after['reviewed']['excluded'] == before['reviewed']['excluded'] + 68
assert after['unreviewed'] == before['unreviewed'] - 68
assert after['reviewed']['adapted'] == before['reviewed']['adapted']
assert after['reviewed']['equivalent'] == before['reviewed']['equivalent']
for key in ['catalog_cases', 'catalog_by_runner', 'linked_cases', 'upstream_files', 'metadata_files']:
    assert after[key] == before[key]

sources = ['packages/compiler/src/zx/analysis/list_operations.zig', 'docs/zx_design_doc.md']
proof = {
    'upstream_commit': '7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd',
    'source_baseline_commit': '670c271c',
    'contract_sources': {path: hashlib.sha256((root / path).read_bytes()).hexdigest() for path in sources},
    'formal_review': name,
    'formal_sha256': hashlib.sha256(formal.read_bytes()).hexdigest(),
    'new_reviewed_files': 68,
    'new_adapted_files': 0,
    'new_catalog_ids': 0,
    'reference_terminal_exit_code': 1,
    'reference_executions': 137,
    'reference_passed': 135,
    'reference_failed': 2,
    'direct_node_failed_executions': 2,
    'zxc_passes_claimed': 0,
    'original_result_sha256': hashlib.sha256((directory / '原文结果.json').read_bytes()).hexdigest(),
    'original_raw_log_sha256': hashlib.sha256((directory / '原文执行日志.txt').read_bytes()).hexdigest(),
    'matrix_audit_terminal_exit_code': 0,
    'matrix_after': after,
    'scope': 'All 69 originals retained; exactly 68 previously unreviewed full-file contracts excluded. One noStrict file, real distinct Realm contexts, and two host failures retained. No dynamic runtime or claimed partial-value adaptation.',
}
output = directory / '最终来源与证据.json'
output.write_text(json.dumps(proof, ensure_ascii=False, indent=4) + '\n')
subprocess.run(['pnpm', 'exec', 'prettier', '--write', str(output)], cwd=root, check=True, stdout=subprocess.DEVNULL)
print('Verified 69 full originals, 68 new reviews, 135/137 reference passes and two independently reproduced host failures')
