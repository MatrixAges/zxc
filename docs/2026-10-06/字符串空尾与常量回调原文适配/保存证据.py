import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
digest = lambda data: hashlib.sha256(data).hexdigest()
execution = json.loads((directory / '实际执行.json').read_text())
originals = json.loads((directory / '原文结果.json').read_text())
assert originals['unchanged_original_executions'] == 48 and originals['adapted_core_observations'] == 4
assert originals['script_sha256'] == digest((directory / '原文验证.mjs').read_bytes())
assert execution['compiler_sha256'] == digest(Path(execution['compiler']).read_bytes())
assert len(execution['commands']) == 18 and len(execution['reports']) == 6
assert all(row['status'] == 0 and row['signal'] is None and row['error'] is None for row in execution['commands'])
for name, sha in execution['source_fingerprints'].items():
    path = directory / name if name == '执行草稿.mjs' else root / name if name.startswith('packages/') else draft / 'packages/test/tests' / name
    assert digest(path.read_bytes()) == sha, name

memory = 0
artifacts = 0
nested = 0
for row in execution['reports']:
    path = directory / Path(row['raw_report']).name
    assert digest(path.read_bytes()) == row['sha256']
    report = json.loads(path.read_text())
    assert len(report['observations']) == 3 and all(item['executed'] and item['passed'] and item['response']['status'] == 0 for item in report['observations'])
    assert all(item['status'] == 0 and item['signal'] is None and item['error'] is None for item in report['commands'])
    memory += sum(item['target'] == 'wasm32-freestanding' for item in report['observations'])
    artifacts += len(report['artifacts'])
    nested += len(report['commands'])

assert memory == 6 and artifacts == 18 and nested == 30
assert sum(row['native_named_cases'] for row in execution['reports']) == 40
sources = json.loads((directory / '同步来源.json').read_text())['sources']
assert len(sources) == 8
for name, sha in sources.items():
    assert (root / name).read_bytes() == (draft / name).read_bytes()
    assert digest((root / name).read_bytes()) == sha

reviews = [row for path in (draft / 'packages/test/upstream/reviews').rglob('*.jsonl') for row in map(json.loads, path.read_text().splitlines())]
assert len(reviews) == 24
assert sum(row['status'] == 'adapted' for row in reviews) == 3
assert sum(row['status'] == 'excluded' for row in reviews) == 21
for entry in json.loads((directory / '原文metadata.json').read_text()):
    path = directory / '原文' / Path(entry['path']).parent.name / (Path(entry['path']).stem + '.txt')
    assert digest(path.read_bytes()) == entry['sha256']

for name in ['language/expressions/addition/explicit_strings', 'built_ins/list/map_true/i64', 'built_ins/list/filter_true/i64']:
    source = 'packages/test/tests/' + name + '.zx'
    assert (root / source).read_bytes() == (draft / source).read_bytes() == subprocess.check_output(['git', 'show', 'b7f882cc:' + source], cwd=root)

generated = json.loads((directory / '生成核对.json').read_text())
assert generated['generated_files_checked'] == 127 and generated['all_other_generated_files_byte_equal']
proof = {
    'production_commit': execution['production_commit'],
    'formal_sources': sources,
    'draft_generator_sources': {str(path.relative_to(draft)): digest(path.read_bytes()) for path in (draft / 'packages/test/src').rglob('*.ts')},
    'unchanged_zx_applications': 3,
    'new_unique_catalog_ids': 3,
    'complete_upstream_reviews': 24,
    'complete_adapted_files': 3,
    'excluded_files': 21,
    'unchanged_original_executions': 48,
    'native_named_executions': 40,
    'application_observations': 18,
    'wasm_memory_invocations_included_in_observations': memory,
    'artifact_fingerprints': artifacts,
    'top_level_commands': 18,
    'nested_commands': nested,
    'formal_gate_status': {'addition_generator_check': 0, 'collection_generator_check': 0, 'typecheck': 0, 'matrix_audit': 0},
    'raw_logs': {path.name: digest(path.read_bytes()) for path in directory.glob('*日志.txt')},
}
(directory / '正式来源与证据.json').write_text(json.dumps(proof, ensure_ascii=False, indent=4) + '\n')
print('Verified eight formal files, three unchanged programs, 48 originals, 40 native executions and 18 application observations')
