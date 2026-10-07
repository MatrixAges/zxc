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
compilers = {args[args.index('--name') + 1]: args for args in commands
             if '--name' in args and args[args.index('--name') + 1].startswith('every-observers-')}
runners = {Path(args[0]).name: args for args in commands if Path(args[0]).name.startswith('every-observers-')}
assert len(compilers) == len(runners) == 4
output = []

for name, compiler in sorted(compilers.items()):
    assert compiler[1] == 'test'
    kind = name.removeprefix('every-observers-')
    modules = {arg[2:].split('=', 1)[0]: arg.split('=', 1)[1] for arg in compiler if arg.startswith('-M')}
    target = doc / '生成产物' / manifest['source_commit'][:8] / mode / kind
    target.mkdir(parents=True, exist_ok=True)
    files = []

    for module, path in modules.items():
        source = Path(path)
        if not source.is_absolute():
            source = root / 'packages/test' / source

        saved = target / (module + '.zig.txt')
        shutil.copyfile(source, saved)
        files.append({'module': module, 'actual_path': str(source), 'saved_path': str(saved.relative_to(doc)),
                      'sha256': hashlib.sha256(source.read_bytes()).hexdigest()})

    catalog = root / ('packages/test/tests/built_ins/list/callbacks/every/' + kind + '/cases.jsonl')
    ids = [json.loads(line)['id'] for line in catalog.read_text().splitlines()]
    replay_argv = [runners[name][0]]
    result = subprocess.run(replay_argv, cwd=root / 'packages/test', stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, timeout=180)
    log = target / '执行输出.txt'
    log.write_bytes(result.stdout)
    names = re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$', result.stdout.decode(), re.M)
    assert result.returncode == 0 and names == ids, (name, result.returncode, len(names))
    output.append({'kind': kind, 'test_count': len(names), 'test_names': names,
                   'compiler_argv': compiler, 'build_runner_argv': runners[name], 'replay_argv': replay_argv,
                   'exit_code': result.returncode, 'files': files,
                   'binary_sha256': hashlib.sha256(Path(replay_argv[0]).read_bytes()).hexdigest(),
                   'output_path': str(log.relative_to(doc)), 'output_sha256': hashlib.sha256(result.stdout).hexdigest()})

assert sum(item['test_count'] for item in output) == 145
(doc / (mode + '产物清单.json')).write_text(json.dumps(output, ensure_ascii=False, indent=2) + '\n')
print(mode + ': archived four generated programs and replayed all 145 named checks')
