# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import shlex
import shutil
import subprocess
import sys

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
root = Path(manifest['worktree'])
mode = sys.argv[1]
record = json.loads((doc / (mode + '执行结果.json')).read_text())
assert record['exit_code'] == 0 and record['inputs'] == manifest['paths']
assert record['source_commit'] == manifest['source_commit']
commands = [shlex.split(line.removeprefix('info(verbose): '))
            for line in (doc / (mode + '原始日志.txt')).read_text().splitlines()
            if line.startswith('info(verbose): ')]
compilers = [args for args in commands if '--name' in args
             and args[args.index('--name') + 1] == 'array-callbacks-reduce-observers']
runners = [args for args in commands if Path(args[0]).name == 'array-callbacks-reduce-observers']
assert len(compilers) == len(runners) == 1
compiler = compilers[0]
assert compiler[1] == 'test'
modules = {arg[2:].split('=', 1)[0]: arg.split('=', 1)[1] for arg in compiler if arg.startswith('-M')}
target = doc / '生成产物' / manifest['source_commit'][:8] / mode
target.mkdir(parents=True, exist_ok=True)
files = []

for name in ['root', 'program', 'support']:
    source = Path(modules[name])
    if not source.is_absolute():
        source = root / 'packages/test' / source

    saved = target / (name + '.zig.txt')
    shutil.copyfile(source, saved)
    files.append({'actual_path': str(source), 'saved_path': str(saved.relative_to(doc)),
                  'sha256': hashlib.sha256(source.read_bytes()).hexdigest()})

catalog = root / 'packages/test/tests/built_ins/list/callbacks/reduce/observers/cases.jsonl'
ids = [json.loads(line)['id'] for line in catalog.read_text().splitlines()]
assert len(ids) == len(set(ids)) == 63
replay_argv = [runners[0][0]]
result = subprocess.run(replay_argv, cwd=root / 'packages/test', stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT, timeout=180)
(target / '执行输出.txt').write_bytes(result.stdout)
actual = re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$', result.stdout.decode(), re.M)
assert result.returncode == 0 and actual == ids, (result.returncode, len(actual))
evidence = {'mode': mode, 'source_commit': manifest['source_commit'], 'compiler_argv': compiler,
            'build_runner_argv': runners[0], 'replay_argv': replay_argv, 'test_count': len(actual),
            'test_names': actual, 'exit_code': result.returncode, 'files': files,
            'binary_sha256': hashlib.sha256(Path(replay_argv[0]).read_bytes()).hexdigest(),
            'output_path': str((target / '执行输出.txt').relative_to(doc)),
            'output_sha256': hashlib.sha256(result.stdout).hexdigest()}
(doc / (mode + '产物清单.json')).write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print(mode + ': verified all 63 named checks by executing the actual generated binary')

if mode == 'Debug':
    source = Path(modules['program']).read_text()
    marker = 'const operand_10 = (value_2).value;'
    assert source.count(marker) == 1
    fault = source.replace(marker, 'const operand_10 = (in).seed;')
    saved = target / '累加值故障控制.zig.txt'
    saved.write_text(fault)
    fault_path = Path('/tmp/zxc-reduce-observer-stale-previous.zig')
    fault_path.write_text(fault)
    argv = [('-Mprogram=' + str(fault_path)) if arg.startswith('-Mprogram=') else arg
            for arg in compiler if arg != '--listen=-']
    result = subprocess.run(argv, cwd=root / 'packages/test', stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, timeout=180)
    log = target / '累加值故障控制输出.txt'
    log.write_bytes(result.stdout)
    blocks = re.split(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.', result.stdout.decode(), flags=re.M)
    assert (len(blocks) - 1) // 2 == len(ids)
    failures = [blocks[index] for index in range(1, len(blocks), 2)
                if re.search(r'^FAIL \(TestExpectedEqual\)$', blocks[index + 1], re.M)]
    assert result.returncode != 0 and any(name.endswith('/original_chain') for name in failures)
    assert 'TestExpectedEqual' in result.stdout.decode()
    evidence = {'argv': argv, 'exit_code': result.returncode, 'failed_names': failures,
                'fault': 'Every previous observation reads seed instead of the actual accumulator.',
                'fault_source': str(saved.relative_to(doc)), 'fault_sha256': hashlib.sha256(saved.read_bytes()).hexdigest(),
                'output_path': str(log.relative_to(doc)), 'output_sha256': hashlib.sha256(result.stdout).hexdigest()}
    (doc / '反向检查.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
    print('Negative control: stale previous value causes ' + str(len(failures)) + ' assertion failures')
