# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
root = Path(manifest['worktree'])
mode = sys.argv[1]
assert mode in ['Debug', 'ReleaseSafe']
gate = json.loads((doc / ('编译器' + mode + '测试执行结果.json')).read_text())
assert gate['exit_code'] == 0 and gate['source_commit'] == manifest['source_commit'], 'Wait for the current compiler test gate to complete first'
assert gate['inputs'] == manifest['paths']

for row in manifest['paths']:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256'], row['path']

cache = Path('/tmp/zxc-predicate-compiler-' + mode.lower())
executions = []
for name, count in [('test', 39), ('zx-frontend-tests', 313), ('zx-integration-tests', 20)]:
    candidates = list(cache.glob('o/*/' + name))
    assert candidates, name
    binary = max(candidates, key=lambda path: path.stat().st_mtime_ns)
    result = subprocess.run([str(binary)], cwd=root / 'packages/compiler', capture_output=True)
    output = result.stdout + result.stderr
    names = re.findall(r'\d+/\d+ (.+?)\.\.\.OK', output.decode())
    assert result.returncode == 0 and len(names) == count, (name, result.returncode, len(names))
    log = doc / ('编译器' + mode + name + '重放.txt')
    log.write_bytes(output)
    executions.append({'argv': [str(binary)], 'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
                       'status': result.returncode, 'test_names': names, 'log': log.name,
                       'log_sha256': hashlib.sha256(output).hexdigest()})

record = {'mode': mode, 'source_commit': manifest['source_commit'], 'inputs': manifest['paths'],
          'executions': executions, 'actual_checks': sum(len(row['test_names']) for row in executions)}
(doc / ('编译器' + mode + '重放清单.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(mode + ': 372 compiler checks executed independently of build cache')
