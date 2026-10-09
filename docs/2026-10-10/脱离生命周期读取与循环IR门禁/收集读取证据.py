from datetime import datetime, timezone
import gzip
import hashlib
import json
from pathlib import Path
import re
import shlex


doc = Path(__file__).resolve().parent
base = Path('/Users/xiewendao/.codex/conformance/detached-reader-fe7bfd6b7')
assert not (doc / '归档清单.json').exists()
records = []
binaries = []
generated = {}
test_counts = {}


def digest(path):
    result = hashlib.sha256()

    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


def save(source, relative, compress=False):
    raw = source.read_bytes()
    encoded = compress or len(raw) > 1024 * 1024
    saved = relative + ('.gz' if encoded else '')
    destination = doc / saved
    destination.parent.mkdir(parents=True, exist_ok=True)
    data = gzip.compress(raw, mtime=0) if encoded else raw
    destination.write_bytes(data)
    records.append({'source': str(source), 'saved': saved, 'encoding': 'gzip' if encoded else 'identity',
                    'raw_sha256': hashlib.sha256(raw).hexdigest(), 'raw_bytes': len(raw),
                    'saved_sha256': hashlib.sha256(data).hexdigest(), 'saved_bytes': len(data)})


for round_name, modes in (('r1', ('debug',)), ('r2', ('debug', 'safe'))):
    run = base / round_name
    save(run / '起点.json', round_name + '/起点.json.txt')

    for mode in modes:
        terminal = json.loads((run / (mode + '.terminal.json')).read_text())
        assert terminal['terminal_exit_code'] == (1 if round_name == 'r1' else 0)
        assert not terminal['changed_inputs']

        if round_name == 'r2':
            counts = re.findall(r'(\d+)/(\d+) tests passed', '\n'.join(terminal['build_summaries']))
            assert counts == [('156', '156')], counts
            test_counts[mode] = int(counts[0][0])

        for suffix in ('start.json', 'terminal.json', 'log.txt'):
            name = mode + '.' + suffix
            save(run / name, round_name + '/' + name + ('' if name.endswith('.txt') else '.txt'), compress=suffix == 'log.txt')

        compiler_outputs = []
        tests = []

        for line in (run / (mode + '.log.txt')).read_text(errors='replace').splitlines():
            if not line.startswith('info(verbose): '):
                continue

            argv = shlex.split(line[len('info(verbose): '):])
            command = Path(argv[0])

            if command.name == 'generate-parser':
                compiler_outputs.extend(Path(path) for path in argv[2:-2])
            elif command.name == 'generate-lexer':
                compiler_outputs.append(Path(argv[2]))
            elif command.name.startswith('detached-reader-') and any(arg.startswith('--seed=') for arg in argv):
                tests.append(argv)
                binaries.append({'round': round_name, 'mode': mode, 'argv': argv,
                                 'path': str(command), 'bytes': command.stat().st_size, 'sha256': digest(command)})
            elif command.name == 'compile-detached-reader':
                for path in argv[2:]:
                    save(Path(path), round_name + '/' + mode + '/夹具产物/' + argv[1] + '/' + Path(path).name + '.txt', compress=True)

        assert len(compiler_outputs) == 91
        assert len(tests) == (0 if round_name == 'r1' else 20)

        for path in compiler_outputs:
            identity = digest(path)

            if path.name not in generated:
                save(path, '生成编译器/' + path.name + '.txt', compress=True)
                generated[path.name] = {'sha256': identity, 'origins': []}

            assert generated[path.name]['sha256'] == identity, path
            generated[path.name]['origins'].append(str(path))

for name in ('catalog-audit.stdout.json', 'catalog-audit.stderr.txt', 'catalog-audit.terminal.json'):
    save(base / 'r2' / name, '目录审计/' + name + ('' if name.endswith('.txt') else '.txt'))

manifest = json.loads((base / 'r2/起点.json').read_text())
save(Path(manifest['cwd']) / 'packages/test/tests/collections/detached_reader/shape.zig', '正式形态检查.zig.txt')
(doc / '归档清单.json').write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
(doc / '生成器身份.json').write_text(json.dumps(generated, ensure_ascii=False, indent=4) + '\n')
(doc / '运行二进制.json').write_text(json.dumps(binaries, ensure_ascii=False, indent=4) + '\n')
(doc / '执行结果.json').write_text(json.dumps({'archived_at': datetime.now(timezone.utc).isoformat(),
    'formal_source_commit': manifest['source_commit'], 'first_round_exit_code': 1, 'first_round_behavior_tests': 0,
    'formal_exit_codes': {'debug': 0, 'safe': 0}, 'run_nodes': len(binaries), 'named_test_executions': sum(test_counts.values()),
    'named_test_executions_by_mode': test_counts,
    'generated_compiler_modules': len(generated), 'generated_outputs_identical_across_runs': True}, ensure_ascii=False, indent=4) + '\n')
print('Archived immutable failed draft and complete Debug/ReleaseSafe execution evidence.')
