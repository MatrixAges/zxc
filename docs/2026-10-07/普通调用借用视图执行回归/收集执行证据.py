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
             if '--name' in args and args[args.index('--name') + 1].startswith('detached-reader-')}
runners = {Path(args[0]).name: args for args in commands if Path(args[0]).name.startswith('detached-reader-')}
assert len(compilers) == len(runners) == 20
output = []

for name, compiler in sorted(compilers.items()):
    assert compiler[1] == 'test'
    kind, route = name.removeprefix('detached-reader-').rsplit('-', 1)
    assert route in ['source', 'library']
    modules = {arg[2:].split('=', 1)[0]: arg.split('=', 1)[1] for arg in compiler if arg.startswith('-M')}
    target = doc / '生成产物' / manifest['source_commit'][:8] / mode / (kind + '-' + route)
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

    root_source = Path(next(item['actual_path'] for item in files if item['module'] == 'root'))
    expected = re.findall(r'^test "([^"\n]+)"', root_source.read_text(), re.M)
    assert len(expected) == (7 if kind in ['prefix', 'offset'] else 8)
    replay_argv = [runners[name][0]]
    result = subprocess.run(replay_argv, cwd=root / 'packages/test', stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, timeout=180)
    log = target / '执行输出.txt'
    log.write_bytes(result.stdout)
    names = re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$', result.stdout.decode(), re.M)
    assert result.returncode == 0 and names == expected, (name, result.returncode, len(names))
    output.append({'kind': kind, 'route': route, 'test_count': len(names), 'test_names': names,
                   'compiler_argv': compiler, 'build_runner_argv': runners[name], 'replay_argv': replay_argv,
                   'exit_code': result.returncode, 'files': files,
                   'binary_sha256': hashlib.sha256(Path(replay_argv[0]).read_bytes()).hexdigest(),
                   'output_path': str(log.relative_to(doc)), 'output_sha256': hashlib.sha256(result.stdout).hexdigest()})

assert sum(item['test_count'] for item in output) == 156
assert sum(item['test_count'] for item in output if item['kind'] in ['prefix', 'offset']) == 28
(doc / (mode + '产物清单.json')).write_text(json.dumps(output, ensure_ascii=False, indent=2) + '\n')
print(mode + ': archived and replayed 20 routes, 156 named Zig tests including all 28 new view tests')
