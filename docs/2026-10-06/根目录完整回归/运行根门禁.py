import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys


directory = Path(__file__).resolve().parent
manifest = json.loads((directory / '复跑起点.json').read_text())
mode, gate, log_name = sys.argv[1:]
assert mode in ['debug', 'safe'] and gate in ['build', 'test', 'dist']
archive = manifest['archive']
assert hashlib.sha256(Path(archive['path']).read_bytes()).hexdigest() == archive['sha256']
argv = ['zig', 'build'] + ([] if gate == 'build' else [gate])
argv += ['-Doptimize=' + mode, '-Dzig-archive=' + archive['path'], '-j2', '--summary', 'all']
environment = {**os.environ, 'ZXC_TEST_SOLVER': manifest['solver']['path']}

with Path(log_name).open('wb') as log:
    result = subprocess.run(argv, cwd=manifest['cwd'], env=environment, stdout=log, stderr=subprocess.STDOUT)

terminal = {'argv': argv, 'terminal_exit_code': result.returncode}
Path(log_name + '.terminal.json').write_text(json.dumps(terminal, indent=2) + '\n')
print(json.dumps(terminal))
sys.exit(result.returncode)
