from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import re
import shlex
import sys


document = Path(__file__).resolve().parent
round_name, mode = sys.argv[1:]
assert (round_name, mode) in (('r1', 'debug'), ('r2', 'debug'), ('r2', 'safe'))
run = Path('/Users/xiewendao/.codex/conformance/predicate-order-07d050b18') / round_name
label = round_name + '-' + mode
manifest_path = document / (label + '归档清单.json')
assert not manifest_path.exists()
terminal = json.loads((run / (mode + '.terminal.json')).read_text())
assert terminal['terminal_exit_code'] == 0
assert terminal['changed_inputs'] == []
records = []
compiler_outputs = []
routes = []


def digest(path):
    result = hashlib.sha256()

    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


def save(source, relative):
    raw = source.read_bytes()
    data = gzip.compress(raw, mtime=0)
    destination = document / label / (relative + '.gz')
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


log = run / (mode + '.log.txt')
assert digest(log) == terminal['log_sha256']
assert terminal['build_summaries'] == ['Build Summary: 44/44 steps succeeded']

for name in ('起点.json', mode + '.start.json', mode + '.terminal.json', mode + '.log.txt'):
    save(run / name, '执行/' + name)

for line in log.read_text().splitlines():
    if not line.startswith('info(verbose): '):
        continue

    argv = shlex.split(line[len('info(verbose): '):])
    name = Path(argv[0]).name

    if name == 'generate-parser':
        compiler_outputs.extend(Path(path) for path in argv[2:-2])
    elif name == 'generate-lexer':
        compiler_outputs.append(Path(argv[2]))
    elif name == 'compile-predicate-order':
        assert argv[3] in ('source', 'library')
        routes.append(Path(argv[4]))

assert len(routes) == len(set(path.name for path in routes)) == 8
assert {path.name for path in routes} == {
    method + '_' + rule + '-' + route
    for method in ('every', 'some')
    for rule in ('cursor', 'visited')
    for route in ('source', 'library')
}
executions = []

for route in routes:
    path = route / 'runtime/cases/execution.json'
    execution = json.loads(path.read_text())
    assert execution['status'] == 0
    assert execution['signal'] is None and execution['error'] is None
    assert execution['optimize'] == mode
    source = Path(execution['source'])
    names = re.findall(r'^test "([^"\n]+)"', source.read_text(), re.MULTILINE)
    assert execution['names'] == names
    assert len(names) == (2 if '_cursor-' in route.name else 1)
    assert digest(Path(execution['binary'])) == execution['binary_sha256']
    assert 'All ' + str(len(names)) + ' tests passed.' in path.with_name('execution.log').read_text()
    save(source, '运行路线/' + route.name + '/cases.zig')

    for generated in sorted(route.iterdir()):
        if generated.is_file():
            save(generated, '运行路线/' + route.name + '/' + generated.name)

    for name in ('execution.json', 'execution.log', 'options.zig'):
        save(path.with_name(name), '运行路线/' + route.name + '/runtime/' + name)

    executions.append({'route': route.name, **execution})

assert sum(len(execution['names']) for execution in executions) == 12
assert len(compiler_outputs) == len(set(path.name for path in compiler_outputs))

for path in compiler_outputs:
    save(path, '生成编译器/' + path.name)

identity = json.loads((document / ('正式源码身份.json' if round_name == 'r2' else '初轮源码身份.json')).read_text())
inputs = json.loads((run / '起点.json').read_text())
assert inputs['source_commit'] == identity['source_commit']
source_root = Path(inputs['cwd'])

for name, expected in identity['overlay'].items():
    source = source_root / name
    assert digest(source) == expected, name
    save(source, '正式输入/' + name)

result = {
    'archived_at': datetime.now(timezone.utc).isoformat(),
    'round': round_name,
    'mode': mode,
    'source_commit': identity['source_commit'],
    'final_pointer_and_length_checks': round_name == 'r2',
    'terminal_exit_code': 0,
    'runtime_records': len(executions),
    'named_executions': sum(len(execution['names']) for execution in executions),
    'generated_compiler_files': len(compiler_outputs),
    'executions': executions,
    'boundary': 'One mode only. Four upstream originals and two supplemental controls; route and mode repetitions are not new unique cases.',
}
manifest_path.write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
(document / (label + '阶段结果.json')).write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
print('Archived', label, len(executions), 'runtime records and 12 named executions.')
