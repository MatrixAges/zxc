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
gate = json.loads((doc / (mode + '执行结果.json')).read_text())
assert gate['exit_code'] == 0 and gate['source_commit'] == manifest['source_commit']
assert gate['inputs'] == manifest['paths']


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def test_names(output):
    return [name.removeprefix('cases.test.') for name in re.findall(r'\d+/\d+ (.+?)\.\.\.OK', output)]


def save(path, directory, name=None):
    target = directory / ((name or path.name) + '.txt')
    target.write_bytes(path.read_bytes())
    return {'actual_path': str(path), 'saved_path': str(target.relative_to(doc)), 'sha256': digest(target)}


for row in manifest['paths']:
    assert digest(root / row['path']) == row['sha256'], row['path']

executions = []
for line in (doc / (mode + '原始日志.txt')).read_text().splitlines():
    if not line.startswith('info(verbose): node ./tests/collections/predicates/run_test.ts '):
        continue

    argv = shlex.split(line.removeprefix('info(verbose): '))
    folder = Path(argv[3])
    method = argv[-1]
    catalog = root / ('packages/test/tests/built_ins/list/predicates/observations/' + method + '.jsonl')
    expected = [json.loads(row)['id'] for row in catalog.read_text().splitlines()]
    metadata = json.loads((folder / 'execution.json').read_text())
    assert metadata['status'] == 0 and metadata['signal'] is None
    assert test_names((folder / 'execution.log').read_text()) == expected
    assert (metadata['native_identity'] is not None) == folder.name.endswith('-library')

    saved = doc / '生成产物' / manifest['source_commit'][:8] / mode / folder.name
    saved.mkdir(parents=True, exist_ok=True)
    files = [save(path, saved) for path in sorted(folder.iterdir()) if path.suffix in ['.zig', '.json', '.log']]
    files.append(save(Path(metadata['source']), saved, 'generated_cases.zig'))

    binary = folder / 'replay-predicate-tests'
    compile_argv = [argv[2], *metadata['argv'], '--test-no-exec', '-femit-bin=' + str(binary)]
    compiled = subprocess.run(compile_argv, cwd=folder, capture_output=True)
    compile_log = doc / (mode + folder.name + '重放构建.txt')
    compile_log.write_bytes(compiled.stdout + compiled.stderr)
    assert compiled.returncode == 0, compile_log
    result = subprocess.run([str(binary)], cwd=folder, capture_output=True)
    output = result.stdout + result.stderr
    replay_log = doc / (mode + folder.name + '二进制重放.txt')
    replay_log.write_bytes(output)
    assert result.returncode == 0 and test_names(output.decode()) == expected, replay_log

    executions.append({'kind': folder.name, 'node_argv': argv, 'metadata': metadata, 'files': files,
                       'test_names': expected, 'compile_argv': compile_argv, 'compile_status': compiled.returncode,
                       'compile_log': compile_log.name, 'compile_log_sha256': digest(compile_log),
                       'argv': [str(binary)], 'binary_sha256': digest(binary), 'status': result.returncode,
                       'log': replay_log.name, 'log_sha256': digest(replay_log)})

assert len(executions) == 4
assert {row['kind'] for row in executions} == {'every-source', 'every-library', 'some-source', 'some-library'}
record = {'mode': mode, 'source_commit': manifest['source_commit'], 'inputs': manifest['paths'],
          'executions': executions, 'actual_checks': sum(len(row['test_names']) for row in executions)}
assert record['actual_checks'] == 346
(doc / (mode + '产物清单.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(mode + ': 346 actual checks; emitted files and all four binary replays verified')
