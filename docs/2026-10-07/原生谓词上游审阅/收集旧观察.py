# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
mode = sys.argv[1]
assert mode in ['Debug', 'ReleaseSafe']
gate = json.loads((doc / ('旧观察' + mode + '执行结果.json')).read_text())
assert gate['exit_code'] == 0 and gate['source_commit'] == manifest['source_commit']
assert gate['inputs'] == manifest['paths']
cache = Path('/tmp/zxc-predicate-reviews-' + mode.lower() + '-' + manifest['source_commit'][:8])
executions = []

for name, count in [('value', 62), ('index', 61), ('all', 14), ('rows', 8)]:
    binaries = list(cache.glob('o/*/every-observers-' + name))
    assert len(binaries) == 1, (name, binaries)
    binary = binaries[0]
    result = subprocess.run([str(binary)], cwd=Path(manifest['worktree']) / 'packages/test', capture_output=True)
    output = result.stdout + result.stderr
    names = re.findall(r'\d+/\d+ (.+?)\.\.\.OK', output.decode())
    assert result.returncode == 0 and len(names) == count
    log = doc / ('旧观察' + mode + name + '重放.txt')
    log.write_bytes(output)
    executions.append({'argv': [str(binary)], 'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
                       'status': result.returncode, 'test_names': names, 'log': log.name,
                       'log_sha256': hashlib.sha256(output).hexdigest()})

record = {'source_commit': manifest['source_commit'], 'inputs': manifest['paths'], 'mode': mode,
          'executions': executions, 'actual_checks': sum(len(row['test_names']) for row in executions)}
assert record['actual_checks'] == 145
(doc / ('旧观察' + mode + '重放清单.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(mode + ': 145 previous observer cases replayed')
