from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


run = Path(sys.argv[1]).resolve()
manifest = json.loads((run / '起点.json').read_text())
root = run / 'inputs'
package = root / 'packages/test'
identities = {str(root / name): value for name, value in manifest['inputs'].items()}
identities.update({tool['path']: tool['sha256'] for tool in manifest['tools'].values()})
identities.update(manifest['zig_library'])
identities.update({str(run / name): value for name, value in manifest['compiler_evidence'].items()})
identities[manifest['compiler_origin_binary']] = manifest['compiler_origin_binary_sha256']


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


assert not (run / 'start.json').exists()

for path, expected in identities.items():
    assert digest(path) == expected, path

start = {'started_at': datetime.now(timezone.utc).isoformat(), 'pid': os.getpid(),
         'runner_sha256': digest(__file__), 'scope': manifest['scope']}
(run / 'start.json').write_text(json.dumps(start, indent=2) + '\n')
stages = []
passed = True


def execute(name, argv):
    record = {'name': name, 'argv': argv, 'cwd': str(package),
              'started_at': datetime.now(timezone.utc).isoformat()}
    stdout = run / (name + '.stdout.txt')
    stderr = run / (name + '.stderr.txt')

    with stdout.open('xb') as out, stderr.open('xb') as err:
        process = subprocess.Popen(argv, cwd=package, stdout=out, stderr=err)
        exit_code = process.wait()

    record.update({'pid': process.pid, 'terminal_exit_code': exit_code,
                   'finished_at': datetime.now(timezone.utc).isoformat(),
                   'stdout_sha256': digest(stdout), 'stderr_sha256': digest(stderr)})
    stages.append(record)
    (run / 'progress.json').write_text(json.dumps(stages, indent=2) + '\n')

    if exit_code != 0:
        raise RuntimeError(name + ' exited ' + str(exit_code))

    return stdout.read_text(errors='replace') + stderr.read_text(errors='replace')


try:
    node = manifest['tools']['node']['path']
    cli = manifest['tools']['cli']['path']
    zig = manifest['tools']['zig']['path']
    execute('generator-check', [node, str(package / manifest['generator']), '--check'])

    for fixture in manifest['programs']:
        assertion = fixture['name']
        source = package / fixture['source']
        catalog = source.with_suffix('.jsonl')
        destination = run / 'generated' / assertion
        destination.mkdir(parents=True)
        program = destination / 'program.zig'
        tests = destination / 'cases.zig'
        execute(assertion + '-generate', [cli, str(source), '--out', str(program)])
        execute(assertion + '-emit', [node, str(package / 'src/emit_control_tests.ts'), str(catalog), str(tests)])
        expected = [json.loads(line)['id'] for line in catalog.read_text().splitlines()]

        for mode in ('debug', 'safe'):
            name = assertion + '-' + mode
            binary = destination / name
            argv = [zig, 'test', '-O' + mode, '--dep', 'support', '--dep', 'program', '-Mroot=' + str(tests),
                    '-O' + mode, '-Msupport=' + str(package / 'tests/support/control.zig'), '-O' + mode]

            if '@import("zxc_abi")' in program.read_text():
                argv.extend(['--dep', 'zxc_abi'])

            argv.append('-Mprogram=' + str(program))

            if '@import("zxc_abi")' in program.read_text():
                argv.extend(['-O' + mode, '-Mzxc_abi=' + str(program) + '.abi.zig'])

            argv.extend(['--cache-dir', str(run / ('local-' + name)), '--global-cache-dir', str(run / ('global-' + name)),
                         '--zig-lib-dir', str(Path(zig).parent / 'lib'), '-femit-bin=' + str(binary)])
            output = execute(name, argv)
            actual = re.findall(r'\d+/\d+ .*?\.test\.(.+?)\.\.\.', output)
            stages[-1].update({'expected_names': expected, 'actual_names': actual, 'binary': str(binary),
                               'binary_sha256': digest(binary)})
            assert actual == expected and 'All ' + str(len(expected)) + ' tests passed.' in output, name
except Exception as error:
    passed = False
    failure = str(error)
else:
    failure = None

changed = [path for path, expected in identities.items() if digest(path) != expected]
generated = {str(path.relative_to(run)): digest(path) for path in (run / 'generated').rglob('*.zig')}
terminal = {**start, 'finished_at': datetime.now(timezone.utc).isoformat(), 'stages': stages,
            'changed_inputs': changed, 'generated_sources': generated, 'failure': failure,
            'gate_passed': passed and not changed}
(run / 'terminal.json').write_text(json.dumps(terminal, indent=2) + '\n')
print(json.dumps({key: terminal[key] for key in ('finished_at', 'gate_passed', 'failure', 'changed_inputs')}, indent=2), flush=True)
sys.exit(0 if terminal['gate_passed'] else 1)
