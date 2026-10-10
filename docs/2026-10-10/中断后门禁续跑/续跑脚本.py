from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

directory = Path(__file__).resolve().parent
base = Path.home() / '.codex/conformance'
repo = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
combined = base / 'project-diagnostic-resource-e4d21707d/r2'
loader = base / 'compiled-loader-695c654ce/r1'
owned = base / 'owned-loop-regression-fc88b9ef4/r1'
artifact = base / 'artifact-resource-wiring-695c654ce/r1'
columns = base / 'loop-column-entry-range-fc88b9ef4/r1'
phases = [
    ('combined-safe-r2', repo / 'docs/2026-10-10/项目诊断与异步边界定位门禁/运行组合门禁.py', combined, 'safe', None),
    ('loader-safe', owned / 'loader-runner.py', loader, 'safe', None),
    ('owned-debug', owned / 'runner.py', owned, 'debug', None),
    ('owned-safe', owned / 'runner.py', owned, 'safe', 'owned-debug'),
    ('artifact-debug', artifact / 'runner.py', artifact, 'debug', None),
    ('artifact-safe', artifact / 'runner.py', artifact, 'safe', 'artifact-debug'),
    ('columns-debug', columns / 'runner.py', columns, 'debug', None),
    ('columns-safe', columns / 'runner.py', columns, 'safe', 'columns-debug'),
]
assert json.loads((loader / 'debug.terminal.json').read_text())['terminal_exit_code'] == 0
assert not (directory / 'start.json').exists()
start = {'pid': os.getpid(), 'started_at': datetime.now(timezone.utc).isoformat(),
         'runner_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         'phases': [{'name': name, 'runner': str(runner), 'runner_sha256': hashlib.sha256(runner.read_bytes()).hexdigest(),
                     'run': str(run), 'mode': mode, 'depends_on': dependency}
                    for name, runner, run, mode, dependency in phases]}
(directory / 'start.json').write_text(json.dumps(start, ensure_ascii=False, indent=4) + '\n')
results = []
finished = {}

for name, runner, run, mode, dependency in phases:
    if dependency is not None and finished[dependency] != 0:
        results.append({'name': name, 'status': 'skipped_after_debug_failure', 'depends_on': dependency})
        continue

    assert not (run / (mode + '.start.json')).exists(), name
    began = datetime.now(timezone.utc).isoformat()
    argv = [sys.executable, str(runner), str(run), mode]

    with (directory / (name + '.log.txt')).open('xb') as log:
        process = subprocess.Popen(argv, stdout=log, stderr=subprocess.STDOUT)
        (directory / 'current.json').write_text(json.dumps({'name': name, 'pid': process.pid, 'argv': argv, 'started_at': began}, indent=4) + '\n')
        exit_code = process.wait()

    finished[name] = exit_code
    terminal_path = run / (mode + '.terminal.json')
    terminal = json.loads(terminal_path.read_text()) if terminal_path.exists() else None
    results.append({'name': name, 'argv': argv, 'started_at': began,
                    'finished_at': datetime.now(timezone.utc).isoformat(), 'runner_exit_code': exit_code,
                    'gate_terminal_available': terminal is not None,
                    'gate_terminal_exit_code': None if terminal is None else terminal['terminal_exit_code']})
    (directory / 'progress.json').write_text(json.dumps(results, indent=4) + '\n')

(directory / 'terminal.json').write_text(json.dumps({**start, 'finished_at': datetime.now(timezone.utc).isoformat(), 'results': results}, ensure_ascii=False, indent=4) + '\n')
sys.exit(0 if all(item.get('runner_exit_code') == 0 for item in results) else 1)
