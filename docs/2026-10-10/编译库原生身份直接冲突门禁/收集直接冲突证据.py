from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path


document = Path(__file__).resolve().parent
base = Path('/Users/xiewendao/.codex/conformance/compiled-native-conflict-695c654ce')
assert not (document / '归档清单.json').exists()
records = []
results = []


def digest(path):
    result = hashlib.sha256()

    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


def save(source, relative):
    raw = source.read_bytes()
    data = gzip.compress(raw, mtime=0)
    destination = document / (relative + '.gz')
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(data)
    records.append({
        'source': str(source),
        'saved': str(destination.relative_to(document)),
        'encoding': 'gzip',
        'raw_bytes': len(raw),
        'raw_sha256': hashlib.sha256(raw).hexdigest(),
        'saved_bytes': len(data),
        'saved_sha256': hashlib.sha256(data).hexdigest(),
    })


for round_name, modes in (('r1', ('debug',)), ('r2', ('debug', 'safe'))):
    run = base / round_name
    manifest = json.loads((run / '起点.json').read_text())
    save(run / '起点.json', round_name + '/起点.json')
    save(run / 'runner.py', round_name + '/运行门禁.py')

    for mode in modes:
        terminal = json.loads((run / (mode + '.terminal.json')).read_text())
        assert terminal['gate_passed']
        assert terminal['terminal_exit_code'] == 0
        assert terminal['changed_inputs'] == []
        assert terminal['actual_names'] == terminal['expected_names']
        assert len(terminal['actual_names']) == 4
        assert digest(run / 'runner.py') == terminal['runner_sha256']
        assert digest(run / (mode + '.log.txt')) == terminal['log_sha256']
        assert digest(Path(terminal['binary'])) == terminal['binary_sha256']

        for suffix in ('start.json', 'terminal.json', 'log.txt'):
            save(run / (mode + '.' + suffix), round_name + '/' + mode + '.' + suffix)

        results.append({
            'round': round_name,
            'mode': mode,
            'final_evidence': round_name == 'r2',
            'named_executions': len(terminal['actual_names']),
            'route_observations': len(terminal['actual_names']) * 2,
            'binary': terminal['binary'],
            'binary_sha256': terminal['binary_sha256'],
            'started_at': terminal['started_at'],
            'finished_at': terminal['finished_at'],
        })

final = json.loads((base / 'r2/起点.json').read_text())
assert len(final['generated_sources']) == 93

for index, (name, expected) in enumerate(sorted(final['module_inputs'].items())):
    source = Path(name)
    assert digest(source) == expected
    save(source, '显式编译模块/' + str(index) + '-' + source.name)

for name, expected in final['overlays'].items():
    source = Path(final['cwd']) / name
    assert digest(source) == expected
    save(source, '正式源码/' + name)

(document / '归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
(document / '执行结果.json').write_text(json.dumps({
    'archived_at': datetime.now(timezone.utc).isoformat(),
    'source_commit': final['source_commit'],
    'unique_named_tests': 4,
    'final_named_executions': 8,
    'final_route_observations': 16,
    'preflight_named_executions': 4,
    'reused_generated_compiler_files': len(final['generated_sources']),
    'explicit_module_inputs': len(final['module_inputs']),
    'results': results,
    'boundary': 'Focused registered test root on frozen 695c source, not a cold canonical build or full loader suite. No OOM rollback claim.',
}, ensure_ascii=False, indent=4) + '\n')
print('Archived four direct native conflict tests in both final modes and the retained preflight.')
