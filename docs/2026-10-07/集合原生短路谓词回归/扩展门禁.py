# coding: utf-8
from pathlib import Path
import datetime
import hashlib
import json
import subprocess
import sys

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
root = Path(manifest['worktree'])
component, mode, operation = sys.argv[1:4]
assert component in ['core', 'compiler', 'genz', 'test']
assert mode in ['Debug', 'ReleaseSafe']
assert operation in ['build', 'test']

for row in manifest['paths']:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256'], row['path']

names = {'core': '核心', 'compiler': '编译器', 'genz': '生成器', 'test': '包边界'}
label = names[component] + mode + ('构建' if operation == 'build' else '测试')
steps = [] if operation == 'build' else sys.argv[4:] or ['test']
argv = ['zig', 'build'] + steps + ['-Doptimize=' + mode, '-j2', '--summary', 'all', '--cache-dir', '/tmp/zxc-predicate-' + component + '-' + mode.lower()]
record = {'argv': argv, 'cwd': str(root / 'packages' / component), 'source_commit': manifest['source_commit'],
          'inputs': manifest['paths'], 'started_at': datetime.datetime.now(datetime.timezone.utc).isoformat()}
with (doc / (label + '原始日志.txt')).open('wb') as log:
    result = subprocess.run(argv, cwd=root / 'packages' / component, stdout=log, stderr=subprocess.STDOUT)
record['completed_at'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
record['exit_code'] = result.returncode
record['log_sha256'] = hashlib.sha256((doc / (label + '原始日志.txt')).read_bytes()).hexdigest()
(doc / (label + '执行结果.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(label + ': ' + str(result.returncode), flush=True)
for line in (doc / (label + '原始日志.txt')).read_text().splitlines():
    if line.startswith('Build Summary:') or 'error:' in line:
        print(line[:350], flush=True)
sys.exit(result.returncode)
