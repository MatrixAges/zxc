from pathlib import Path
import datetime
import json
import subprocess
import sys
import time

run = Path(__file__).resolve().parent
label = sys.argv[1]
command = ['/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/zig', 'build', 'test-nested-buffer', '-Doptimize=' + label, '--cache-dir', str(Path('/Users/xiewendao/.codex/conformance/nested-buffer-f23a658e2/r1') / ('cache-' + label)), '-j1', '--verbose', '--summary', 'all']
cwd = '/Users/xiewendao/.codex/worktrees/nested-buffer-conformance/zxc/packages/test'
state = {'status': 'running', 'command': command, 'cwd': cwd, 'started': datetime.datetime.now(datetime.timezone.utc).isoformat(), 'log': str(run / (label + '.txt')), 'exit_code': None}
started = time.monotonic()
with open(state['log'], 'wb') as output:
    process = subprocess.Popen(command, cwd=cwd, stdout=output, stderr=subprocess.STDOUT)
    state['pid'] = process.pid
    while process.poll() is None:
        state['elapsed_seconds'] = time.monotonic() - started
        (run / (label + '-state.json')).write_text(json.dumps(state, indent=2) + '\n')
        time.sleep(5)
    state.update(status='terminal', exit_code=process.returncode, finished=datetime.datetime.now(datetime.timezone.utc).isoformat(), elapsed_seconds=time.monotonic() - started)
    (run / (label + '-state.json')).write_text(json.dumps(state, indent=2) + '\n')
print(json.dumps(state))
sys.exit(process.returncode)
