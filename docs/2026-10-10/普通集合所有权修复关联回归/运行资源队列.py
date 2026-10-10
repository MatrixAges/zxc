from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time


run = Path('/Users/xiewendao/.codex/conformance/owned-loop-regression-fc88b9ef4/r1')
loader = Path('/Users/xiewendao/.codex/conformance/compiled-loader-695c654ce/r1')
wait_pid = 80063
wait_identity = '/project-diagnostic-resource-e4d21707d/r1/queue.py'
assert not (run / 'queue.start.json').exists()
start = {
    'started_at': datetime.now(timezone.utc).isoformat(),
    'pid': os.getpid(),
    'wait_pid': wait_pid,
    'wait_identity': wait_identity,
    'runner_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
    'phases': [],
}
(run / 'queue.start.json').write_text(json.dumps(start, indent=2) + '\n')

while True:
    process = subprocess.run(['ps', '-p', str(wait_pid), '-o', 'command='], capture_output=True, text=True)

    if process.returncode != 0 or wait_identity not in process.stdout:
        break

    time.sleep(5)

(run / 'queue.ready.json').write_text(json.dumps({**start, 'ready_at': datetime.now(timezone.utc).isoformat()}, indent=2) + '\n')
debug = json.loads((loader / 'debug.terminal.json').read_text())
assert debug['terminal_exit_code'] == 0 and debug['changed_inputs'] == []
assert not (loader / 'safe.start.json').exists()
phases = [
    ('compiled-loader-safe', [sys.executable, str(run / 'loader-runner.py'), str(loader), 'safe']),
    ('owned-loop-debug', [sys.executable, str(run / 'runner.py'), str(run), 'debug']),
    ('owned-loop-safe', [sys.executable, str(run / 'runner.py'), str(run), 'safe']),
]
results = []

for name, argv in phases:
    if name == 'owned-loop-safe' and results[-1]['exit_code'] != 0:
        break

    began = datetime.now(timezone.utc).isoformat()
    exit_code = subprocess.run(argv).returncode
    results.append({'phase': name, 'argv': argv, 'started_at': began,
                    'finished_at': datetime.now(timezone.utc).isoformat(), 'exit_code': exit_code})
    (run / 'queue.progress.json').write_text(json.dumps(results, indent=2) + '\n')

terminal = {**start, 'finished_at': datetime.now(timezone.utc).isoformat(), 'phases': results}
(run / 'queue.terminal.json').write_text(json.dumps(terminal, indent=2) + '\n')
print(json.dumps(terminal, indent=2), flush=True)
sys.exit(0 if len(results) == 3 and all(result['exit_code'] == 0 for result in results) else 1)
