from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


run = Path(sys.argv[1]).resolve()
mode = sys.argv[2]
assert mode in ('debug', 'safe')
manifest = json.loads((run / '起点.json').read_text())
root = Path(manifest['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip() == manifest['source_commit']
identities = {str(root / name): identity for name, identity in manifest['sources'].items()}
identities.update(manifest['generated_sources'])
identities.update(manifest['module_inputs'])
identities.update(manifest['zig_library'])
identities.update({tool['path']: tool['sha256'] for tool in manifest['tools'].values()})


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


for path, identity in identities.items():
    assert digest(path) == identity, path

original = manifest['canonical_compile_argv']
argv = []
index = 0

while index < len(original):
    argument = original[index]

    if argument == '--listen=-':
        index += 1
        continue

    if argument in ('--cache-dir', '--global-cache-dir', '--name'):
        replacement = {
            '--cache-dir': str(run / ('local-' + mode)),
            '--global-cache-dir': str(run / ('global-' + mode)),
            '--name': 'compiled-native-conflicts-' + mode,
        }[argument]
        argv.extend((argument, replacement))
        index += 2
        continue

    if argument == '-Mroot=tests/library/imports/native_test.zig':
        argument = '-Mroot=tests/library/imports/native_conflicts_test.zig'
    elif argument == '-Odebug':
        argument = '-O' + mode

    argv.append(argument)
    index += 1

binary = run / ('compiled-native-conflicts-' + mode)
argv.append('-femit-bin=' + str(binary))
assert not (run / (mode + '.start.json')).exists()
assert not (run / ('local-' + mode)).exists()
assert not (run / ('global-' + mode)).exists()
environment = {
    **os.environ,
    'ZXC_TEST_SOLVER': manifest['tools']['solver']['path'],
    'ZIG_GLOBAL_CACHE_DIR': str(run / ('global-' + mode)),
}
record = {
    'mode': mode,
    'argv': argv,
    'cwd': manifest['build_cwd'],
    'runner_sha256': digest(__file__),
    'started_at': datetime.now(timezone.utc).isoformat(),
    'source_commit': manifest['source_commit'],
    'solver': environment['ZXC_TEST_SOLVER'],
}
log_path = run / (mode + '.log.txt')

with log_path.open('xb') as log:
    process = subprocess.Popen(argv, cwd=manifest['build_cwd'], env=environment, stdout=log, stderr=subprocess.STDOUT)
    (run / (mode + '.start.json')).write_text(json.dumps({**record, 'pid': process.pid}, indent=2) + '\n')
    exit_code = process.wait()

source = root / 'packages/test/tests/library/imports/native_conflicts_test.zig'
expected = re.findall(r'^test "([^"\n]+)"', source.read_text(), re.MULTILINE)
output = log_path.read_text(errors='replace')
actual = re.findall(r'\d+/' + str(len(expected)) + r' .*?\.test\.(.+?)\.\.\.', output)
changed = [path for path, identity in identities.items() if digest(path) != identity]
passed = exit_code == 0 and actual == expected and 'All 4 tests passed.' in output and not changed
terminal = {
    **record,
    'pid': process.pid,
    'finished_at': datetime.now(timezone.utc).isoformat(),
    'terminal_exit_code': exit_code,
    'changed_inputs': changed,
    'expected_names': expected,
    'actual_names': actual,
    'binary': str(binary),
    'binary_sha256': digest(binary) if binary.exists() else None,
    'log_sha256': digest(log_path),
    'gate_passed': passed,
}
(run / (mode + '.terminal.json')).write_text(json.dumps(terminal, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({key: terminal[key] for key in ('mode', 'terminal_exit_code', 'changed_inputs', 'actual_names', 'gate_passed')}, indent=2), flush=True)
sys.exit(0 if passed else 1)
