from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time


run = Path.home() / '.codex/conformance/loop-column-entry-range-fc88b9ef4/r1'
wait_pid = 96002
wait_identity = '/artifact-resource-wiring-695c654ce/r1/queue.py'
assert not (run / 'queue.start.json').exists()
start = {
    'started_at': datetime.now(timezone.utc).isoformat(),
    'pid': os.getpid(),
    'wait_pid': wait_pid,
    'wait_identity': wait_identity,
    'runner_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
}
(run / 'queue.start.json').write_text(json.dumps(start, indent=2) + '\n')

while True:
    process = subprocess.run(['ps', '-p', str(wait_pid), '-o', 'command='], capture_output=True, text=True)

    if process.returncode != 0 or wait_identity not in process.stdout:
        break

    time.sleep(5)

(run / 'queue.ready.json').write_text(json.dumps({**start, 'ready_at': datetime.now(timezone.utc).isoformat()}, indent=2) + '\n')
results = []

for mode in ('debug', 'safe'):
    began = datetime.now(timezone.utc).isoformat()
    argv = [sys.executable, str(run / 'runner.py'), str(run), mode]
    exit_code = subprocess.run(argv).returncode
    results.append({'mode': mode, 'argv': argv, 'started_at': began,
                    'finished_at': datetime.now(timezone.utc).isoformat(), 'exit_code': exit_code})
    (run / 'queue.progress.json').write_text(json.dumps(results, indent=2) + '\n')

    if exit_code != 0:
        break

terminal = {**start, 'finished_at': datetime.now(timezone.utc).isoformat(), 'phases': results}
(run / 'queue.terminal.json').write_text(json.dumps(terminal, indent=2) + '\n')
print(json.dumps(terminal, indent=2), flush=True)
sys.exit(0 if len(results) == 2 and all(result['exit_code'] == 0 for result in results) else 1)
