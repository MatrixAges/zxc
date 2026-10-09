import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from datetime import datetime, timezone


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')


directory = Path(sys.argv[1]).resolve()
mode = sys.argv[2]
assert mode in ('debug', 'safe')
manifest = json.loads((directory / '起点.json').read_text())
cwd = Path(manifest['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=cwd, text=True).strip() == manifest['source_commit']

for relative, expected in manifest['sources'].items():
    assert digest(cwd / relative) == expected, relative

for tool in manifest['tools'].values():
    assert digest(tool['path']) == tool['sha256'], tool['path']

for group in ('node_dependencies', 'zig_library'):
    for path, expected in manifest[group].items():
        assert digest(path) == expected, path

local_cache = directory / ('local-' + mode)
global_cache = directory / ('global-' + mode)
assert not local_cache.exists()
assert global_cache.is_dir()
assert set(path.name for path in global_cache.iterdir()) <= {'p'}
assert not (directory / (mode + '.start.json')).exists()

for dependency in manifest['zig_dependencies'].values():
    assert digest(global_cache / 'p' / Path(dependency['path']).name) == dependency['sha256']

zig = manifest['tools']['zig']['path']
argv = [zig, 'build', 'test', '-Doptimize=' + mode,
        '-Dzig-archive=' + manifest['tools']['archive']['path'],
        '--cache-dir', str(local_cache), '-j2', '--verbose', '--summary', 'all']
environment = {**os.environ, 'ZXC_TEST_SOLVER': manifest['tools']['solver']['path'],
               'ZIG_GLOBAL_CACHE_DIR': str(global_cache),
               'PATH': str(Path(zig).parent) + ':/usr/local/bin:' + os.environ['PATH']}
record = {'argv': argv, 'cwd': str(cwd), 'mode': mode,
          'runner_sha256': digest(__file__),
          'started_at': datetime.now(timezone.utc).isoformat(),
          'environment': {key: environment[key] for key in ('PATH', 'ZXC_TEST_SOLVER', 'ZIG_GLOBAL_CACHE_DIR')}}
log_path = directory / (mode + '.log.txt')

with log_path.open('xb') as log:
    process = subprocess.Popen(argv, cwd=cwd, env=environment, stdout=log, stderr=subprocess.STDOUT)
    save(directory / (mode + '.start.json'), {**record, 'pid': process.pid, 'runner_pid': os.getpid()})
    exit_code = process.wait()

log_text = log_path.read_text(errors='replace')
changed = [relative for relative, expected in manifest['sources'].items() if digest(cwd / relative) != expected]
changed_tools = [tool['path'] for tool in manifest['tools'].values() if digest(tool['path']) != tool['sha256']]
changed_dependencies = [path for group in ('node_dependencies', 'zig_library')
                        for path, expected in manifest[group].items() if digest(path) != expected]
terminal = {**record, 'pid': process.pid, 'terminal_exit_code': exit_code,
            'finished_at': datetime.now(timezone.utc).isoformat(),
            'log_sha256': digest(log_path), 'changed_sources': changed,
            'changed_tools': changed_tools, 'changed_dependencies': changed_dependencies,
            'build_summaries': re.findall(r'Build Summary:[^\n]*', log_text)}
save(directory / (mode + '.terminal.json'), terminal)
print(json.dumps(terminal, ensure_ascii=False, indent=2), flush=True)
sys.exit(exit_code if not (changed or changed_tools or changed_dependencies) else 2)
