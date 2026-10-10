from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import re
import shlex
import sys


document = Path(__file__).resolve().parent
run = Path('/Users/xiewendao/.codex/conformance/compiled-loader-695c654ce/r1')
mode = sys.argv[1]
assert mode in ('debug', 'safe')
manifest_path = document / (mode + '归档清单.json')
assert not manifest_path.exists()
terminal = json.loads((run / (mode + '.terminal.json')).read_text())
assert terminal['terminal_exit_code'] == 0
assert terminal['changed_inputs'] == []
log_path = run / (mode + '.log.txt')
records = []
binaries = []
compiler_outputs = []
consumers = []
node_commands = []


def digest(path):
    result = hashlib.sha256()

    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


def save(source, relative):
    raw = source.read_bytes()
    data = gzip.compress(raw, mtime=0)
    destination = document / mode / (relative + '.gz')
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(data)
    records.append({
        'source': str(source),
        'saved': str(destination.relative_to(document)),
        'encoding': 'gzip',
        'raw_sha256': hashlib.sha256(raw).hexdigest(),
        'raw_bytes': len(raw),
        'saved_sha256': hashlib.sha256(data).hexdigest(),
        'saved_bytes': len(data),
    })


assert digest(log_path) == terminal['log_sha256']
summary = re.findall(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', log_path.read_text())
assert len(summary) == 1
steps, expected_steps, tests, expected_tests = map(int, summary[0])
assert steps == expected_steps
assert tests == expected_tests == 266
runtime_counts = re.findall(r'run test(?: [\w-]+)? (\d+) pass \((\d+) total\)', log_path.read_text())
assert len(runtime_counts) == 35
assert all(actual == expected for actual, expected in runtime_counts)
assert sum(int(actual) for actual, _ in runtime_counts) == tests

for name in ('起点.json', mode + '.start.json', mode + '.terminal.json', mode + '.log.txt'):
    save(run / name, '执行/' + name)

for line in log_path.read_text().splitlines():
    if not line.startswith('info(verbose): '):
        continue

    argv = shlex.split(line[len('info(verbose): '):])
    command = Path(argv[0])

    if command.name == 'generate-parser':
        compiler_outputs.extend(Path(path) for path in argv[2:-2])
    elif command.name == 'generate-lexer':
        compiler_outputs.append(Path(argv[2]))
    elif command.name == 'compile-detached-reader':
        consumers.append({'fixture': argv[1], 'paths': argv[2:]})
    elif command.name == 'node':
        node_commands.append(argv)

    if any(arg.startswith('--seed=') for arg in argv):
        binaries.append({
            'argv': argv,
            'path': str(command),
            'bytes': command.stat().st_size,
            'sha256': digest(command),
        })

assert len(binaries) == len(runtime_counts)
assert len(node_commands) == 4
assert len(consumers) == 10
assert len(compiler_outputs) == len(set(path.name for path in compiler_outputs))
assert {'compiled_library.zig', 'compiled_library_abi.zig', 'lexer.zig'} <= set(path.name for path in compiler_outputs)

for path in compiler_outputs:
    save(path, '生成编译器/' + path.name)

for consumer in consumers:
    assert len(consumer['paths']) == 4

    for name in consumer['paths']:
        path = Path(name)
        save(path, '消费者产物/' + consumer['fixture'] + '/' + path.name)

result = {
    'archived_at': datetime.now(timezone.utc).isoformat(),
    'mode': mode,
    'source_commit': json.loads((run / '起点.json').read_text())['source_commit'],
    'terminal_exit_code': terminal['terminal_exit_code'],
    'build_steps': steps,
    'runtime_nodes': len(binaries),
    'named_test_executions': tests,
    'node_routes': len(node_commands),
    'node_tap_counts_retained': False,
    'generated_compiler_files': len(compiler_outputs),
    'consumer_files': sum(len(consumer['paths']) for consumer in consumers),
    'binaries_preserved_externally': binaries,
    'node_commands': node_commands,
    'boundary': 'One mode only. Node success is proved by the canonical build, not retained TAP counts. Temporary CLI consumer binaries were removed by their existing runners.',
}
manifest_path.write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
(document / (mode + '阶段结果.json')).write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
print('Archived', mode, len(binaries), 'runtime nodes,', tests, 'named executions and', len(compiler_outputs), 'compiler files.')
