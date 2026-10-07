# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import shlex
import subprocess
import sys

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
root = Path(manifest['worktree'])
mode = sys.argv[1]
assert mode in ['Debug', 'ReleaseSafe']

for label in [mode, '值' + mode]:
    gate = json.loads((doc / (label + '执行结果.json')).read_text())
    assert gate['exit_code'] == 0 and gate['source_commit'] == manifest['source_commit'], 'Wait for the current native and value gates to complete first'
    assert gate['inputs'] == manifest['paths']

for row in manifest['paths']:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256'], row['path']


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def commands(label):
    text = (doc / (label + '原始日志.txt')).read_text()
    return [shlex.split(line.removeprefix('info(verbose): ')) for line in text.splitlines() if line.startswith('info(verbose): ')]


def replay(binary, destination, expected):
    result = subprocess.run([str(binary)], cwd=root / 'packages/test', capture_output=True)
    output = result.stdout + result.stderr
    destination.write_bytes(output)
    names = re.findall(r'\d+/\d+ (.+?)\.\.\.OK', output.decode())
    assert result.returncode == 0 and len(names) == expected, (binary, result.returncode, len(names))
    return {'argv': [str(binary)], 'binary_sha256': digest(binary), 'status': result.returncode,
            'log': str(destination.relative_to(doc)), 'log_sha256': digest(destination), 'test_names': names}


def save(path, folder):
    target = folder / (path.name + '.txt')
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(path.read_bytes())
    return {'actual_path': str(path), 'saved_path': str(target.relative_to(doc)), 'sha256': digest(target)}


native = []
analysis = None
for argv in commands(mode):
    if Path(argv[0]).name == 'list-predicates-analysis':
        analysis = replay(Path(argv[0]), doc / (mode + '分析重放.txt'), 6)
    if argv[:2] != ['node', './tests/collections/predicates/run_test.ts']:
        continue

    folder = Path(argv[3])
    metadata = json.loads((folder / 'execution.json').read_text())
    assert metadata['status'] == 0 and metadata['signal'] is None
    names = re.findall(r'\d+/\d+ (.+?)\.\.\.OK', (folder / 'execution.log').read_text())
    assert len(names) == 9 and len(set(names)) == 9
    assert (metadata['native_identity'] is not None) == folder.name.endswith('-library')
    saved = doc / '生成产物' / manifest['source_commit'][:8] / mode / folder.name
    files = [save(path, saved) for path in sorted(folder.iterdir()) if path.suffix in ['.zig', '.json', '.log']]
    native.append({'kind': folder.name, 'node_argv': argv, 'metadata': metadata, 'test_names': names, 'files': files})

assert analysis is not None and len(native) == 4
assert {row['kind'] for row in native} == {'every-source', 'some-source', 'every-library', 'some-library'}
record = {'mode': mode, 'source_commit': manifest['source_commit'], 'inputs': manifest['paths'], 'analysis': analysis,
          'native': native, 'actual_checks': 6 + sum(len(row['test_names']) for row in native)}
(doc / (mode + '原生产物清单.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')

values = []
value_commands = commands('值' + mode)
for argv in value_commands:
    if not Path(argv[0]).name.startswith('list-predicate-'):
        continue
    name = Path(argv[0]).name
    expected = 8 if name.endswith('-bounds') or name.endswith('-nested') else 12
    folder = doc / '生成产物' / manifest['source_commit'][:8] / mode / name
    folder.mkdir(parents=True, exist_ok=True)
    record = replay(Path(argv[0]), folder / '执行重放.txt', expected)
    compiled = [command for command in value_commands if command[1:2] == ['test'] and '--name' in command and command[command.index('--name') + 1] == name]
    assert len(compiled) == 1, name
    program = Path(next(arg.removeprefix('-Mprogram=') for arg in compiled[0] if arg.startswith('-Mprogram=')))
    record['files'] = [save(path, folder) for path in sorted(program.parent.iterdir()) if path.suffix in ['.zig', '.json']]
    values.append(record)

assert len(values) == 11 and sum(len(row['test_names']) for row in values) == 120
record = {'mode': mode, 'source_commit': manifest['source_commit'], 'inputs': manifest['paths'], 'executions': values, 'actual_checks': 120}
(doc / ('值' + mode + '产物清单.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(mode + ': 42 native/analysis checks, 120 direct value checks')
