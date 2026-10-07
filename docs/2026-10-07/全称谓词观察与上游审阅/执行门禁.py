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
target = sys.argv[2] if len(sys.argv) > 2 else 'test-every-observers'
label = ('相邻' if target == 'test-array-callbacks' else '') + mode
assert mode in ['Debug', 'ReleaseSafe']
assert target in ['test-every-observers', 'test-array-callbacks']
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root).decode().strip() == manifest['source_commit']

for row in manifest['paths']:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256'], row['path']

argv = [
    'zig', 'build', target, '-Doptimize=' + mode,
    '-Dzig-archive=/tmp/zig-x86_64-macos-0.17.0.tar.xz', '-j2', '--summary', 'all', '--verbose',
    '--cache-dir', '/tmp/zxc-every-observer-' + mode.lower() + '-' + manifest['source_commit'][:8],
]
record = {
    'argv': argv, 'cwd': str(root / 'packages/test'), 'source_commit': manifest['source_commit'],
    'inputs': manifest['paths'], 'started_at': datetime.datetime.now(datetime.timezone.utc).isoformat(),
}

with (doc / (label + '原始日志.txt')).open('wb') as log:
    result = subprocess.run(argv, cwd=root / 'packages/test', stdout=log, stderr=subprocess.STDOUT)

record['completed_at'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
record['exit_code'] = result.returncode
record['log_sha256'] = hashlib.sha256((doc / (label + '原始日志.txt')).read_bytes()).hexdigest()
(doc / (label + '执行结果.json')).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'mode': mode, 'exit_code': result.returncode}), flush=True)

for line in (doc / (label + '原始日志.txt')).read_text().splitlines():
    if line.startswith('Build Summary:') or 'error:' in line:
        print(line[:400], flush=True)

sys.exit(result.returncode)
