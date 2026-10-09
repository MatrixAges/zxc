from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


directory = Path(sys.argv[1]).resolve()
mode = sys.argv[2]
assert mode in ('debug', 'safe')
manifest = json.loads((directory / '起点.json').read_text())
cwd = Path(manifest['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=cwd, text=True).strip() == manifest['source_commit']
identities = {str(cwd / name): identity for name, identity in manifest['sources'].items()}
identities.update({tool['path']: tool['sha256'] for tool in manifest['tools'].values()})

for group in ('node_dependencies', 'zig_library'):
    identities.update(manifest[group])

for path, identity in identities.items():
    assert digest(path) == identity, path

local_cache = directory / ('local-' + mode)
global_cache = directory / ('global-' + mode)
assert not local_cache.exists()
assert set(path.name for path in global_cache.iterdir()) <= {'p'}
assert not (directory / (mode + '.start.json')).exists()

for dependency in manifest['zig_dependencies'].values():
    assert digest(global_cache / 'p' / Path(dependency['path']).name) == dependency['sha256']

zig = manifest['tools']['zig']['path']
argv = [zig, 'build', 'test-aggregate-loop', '-Doptimize=' + mode,
        '-Dzig-archive=' + manifest['tools']['archive']['path'],
        '--cache-dir', str(local_cache), '-j2', '--verbose', '--summary', 'all']
environment = {**os.environ, 'ZXC_TEST_SOLVER': manifest['tools']['solver']['path'],
               'ZIG_GLOBAL_CACHE_DIR': str(global_cache),
               'PATH': str(Path(zig).parent) + ':/usr/local/bin:' + os.environ['PATH']}
record = {'argv': argv, 'cwd': manifest['build_cwd'], 'mode': mode,
          'runner_sha256': digest(__file__), 'started_at': datetime.now(timezone.utc).isoformat(),
          'environment': {key: environment[key] for key in ('PATH', 'ZXC_TEST_SOLVER', 'ZIG_GLOBAL_CACHE_DIR')}}
log_path = directory / (mode + '.log.txt')

with log_path.open('xb') as log:
    process = subprocess.Popen(argv, cwd=manifest['build_cwd'], env=environment, stdout=log, stderr=subprocess.STDOUT)
    (directory / (mode + '.start.json')).write_text(json.dumps({**record, 'pid': process.pid, 'runner_pid': os.getpid()}, indent=2) + '\n')
    exit_code = process.wait()

changed = [path for path, identity in identities.items() if digest(path) != identity]
terminal = {**record, 'pid': process.pid, 'terminal_exit_code': exit_code,
            'finished_at': datetime.now(timezone.utc).isoformat(), 'changed_inputs': changed,
            'log_sha256': digest(log_path),
            'build_summaries': re.findall(r'Build Summary:[^\n]*', log_path.read_text(errors='replace'))}
(directory / (mode + '.terminal.json')).write_text(json.dumps(terminal, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(terminal, ensure_ascii=False, indent=2), flush=True)
sys.exit(exit_code if not changed else 2)
