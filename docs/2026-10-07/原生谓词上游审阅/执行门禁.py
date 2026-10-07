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
mode = sys.argv[1]
target = sys.argv[2] if len(sys.argv) > 2 else 'test-predicate-reviews'
assert mode in ['Debug', 'ReleaseSafe']
assert target in ['test-predicate-reviews', 'test-list-predicates', 'test-every-observers']
label = ('相邻' if target == 'test-list-predicates' else '旧观察' if target == 'test-every-observers' else '') + mode
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root).decode().strip() == manifest['source_commit']

for row in manifest['paths']:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256'], row['path']

argv = ['zig', 'build', target, '-Doptimize=' + mode, '-j2', '--summary', 'all', '--verbose',
        '--cache-dir', '/tmp/zxc-predicate-reviews-' + mode.lower() + '-' + manifest['source_commit'][:8]]
record = {'argv': argv, 'cwd': str(root / 'packages/test'), 'source_commit': manifest['source_commit'],
          'inputs': manifest['paths'], 'started_at': datetime.datetime.now(datetime.timezone.utc).isoformat()}
log = doc / (label + '原始日志.txt')
with log.open('wb') as output:
    result = subprocess.run(argv, cwd=root / 'packages/test', stdout=output, stderr=subprocess.STDOUT)
record['exit_code'] = result.returncode
record['completed_at'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
record['log_sha256'] = hashlib.sha256(log.read_bytes()).hexdigest()
(doc / (label + '执行结果.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(label + ': ' + str(result.returncode), flush=True)
for line in log.read_text().splitlines():
    if line.startswith('Build Summary:') or 'error:' in line:
        print(line[:350], flush=True)
sys.exit(result.returncode)
