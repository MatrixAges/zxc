import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys


directory = Path(__file__).resolve().parent
path = directory / '执行起点.json'
manifest = json.loads(path.read_text())
mode, group, log_name = sys.argv[1:]
assert mode in ['debug', 'safe'] and group in ['neighbors', 'all']
fixed = Path(manifest['cwd']).parents[1]
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['production_commit']
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
patches = manifest.get('test_patches', {})
assert set(status.splitlines()) == {' M ' + name for name in patches}

for name, patch in patches.items():
    assert hashlib.sha256((fixed / name).read_bytes()).hexdigest() == patch['sha256']
archive = manifest['archive']
assert hashlib.sha256(Path(archive['path']).read_bytes()).hexdigest() == archive['sha256']
neighbors = ['test-rx-parallel-inference', 'test-rx-owned-runtime', 'test-object-append', 'test-iterate-buffer', 'test-module-generation']
steps = neighbors if group == 'neighbors' else ['test-owned-input', 'test-native-references', *neighbors]
argv = ['zig', 'build', *steps, '-Doptimize=' + mode, '-Dzig-archive=' + archive['path'], '-j2', '--summary', 'all']
key = mode + '_' + group
log = Path(log_name)
assert not log.exists()
if key in manifest:
    manifest.setdefault('previous_runs', []).append(manifest[key])

manifest[key] = {'argv': argv, 'log': str(log), 'terminal_exit_code': None}
path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')

with log.open('wb') as stream:
    result = subprocess.run(argv, cwd=manifest['cwd'], env=os.environ.copy(), stdout=stream, stderr=subprocess.STDOUT)

manifest = json.loads(path.read_text())
manifest[key]['terminal_exit_code'] = result.returncode
manifest[key]['log_sha256'] = hashlib.sha256(log.read_bytes()).hexdigest()
path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'argv': argv, 'terminal_exit_code': result.returncode}))
sys.exit(result.returncode)
