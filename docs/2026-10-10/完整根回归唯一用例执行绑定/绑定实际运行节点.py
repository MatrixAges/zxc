# coding: utf-8
import collections
import gzip
import hashlib
import json
from pathlib import Path
import re
import shlex


document = Path(__file__).resolve().parent
root = document.parents[2]
run = Path.home() / '.codex/conformance/indexed-root-bbd92b5c5/r1'
manifest = json.loads((run / '起点.json').read_text())
frozen = Path(manifest['cwd'])
terminal = json.loads((run / 'debug.terminal.json').read_text())
assert terminal['terminal_exit_code'] == 1
assert not any(terminal[key] for key in ('changed_sources', 'changed_tools', 'changed_dependencies'))
log = (run / 'debug.log.txt').read_bytes()
assert hashlib.sha256(log).hexdigest() == terminal['log_sha256']
lines = log.decode().splitlines()
summary_index = next(index for index, line in enumerate(lines) if line.startswith('Build Summary:'))
suites = json.loads((frozen / 'packages/test/suites.json').read_text())['runtime']
assert len({item['name'] for item in suites}) == len(suites)
delegated_kinds = {'application_json', 'immutable_list', 'rx_parallel_floating', 'rx_floating',
                   'floating_reduce', 'predicate_trace', 'reduce_trace', 'filter_trace',
                   'map_trace', 'predicate_arguments'}
selected = [item for item in suites if item['kind'] not in delegated_kinds]
assert len(selected) == 526 and len(suites) - len(selected) == 52
compiles = collections.defaultdict(list)
runs = collections.defaultdict(list)
outputs = collections.defaultdict(list)
successes = collections.defaultdict(list)
records = {}
source_identities = {}


def digest(path):
    value = hashlib.sha256()

    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            value.update(block)

    return value.hexdigest()


def save(path, category):
    raw = path.read_bytes()
    identity = hashlib.sha256(raw).hexdigest()
    key = category + '/' + identity + '.gz'

    if key not in records:
        target = document / key
        target.parent.mkdir(parents=True, exist_ok=True)
        encoded = gzip.compress(raw, mtime=0)
        target.write_bytes(encoded)
        records[key] = {'saved': key, 'raw_sha256': identity, 'raw_bytes': len(raw),
                        'saved_sha256': hashlib.sha256(encoded).hexdigest(), 'saved_bytes': len(encoded)}

    return {'source': str(path), 'sha256': identity, 'saved': key}


def source(name):
    path = frozen / name
    expected = manifest['sources'][name]
    assert digest(path) == expected, name
    source_identities[name] = expected
    return path


def single(items, context):
    assert len(items) == 1, (context, len(items))
    return items[0]


for index, line in enumerate(lines[:summary_index], 1):
    if not line.startswith('info(verbose): '):
        continue

    argv = shlex.split(line[len('info(verbose): '):])

    if not argv:
        continue

    entry = {'line': index, 'argv': argv}
    runs[Path(argv[0]).name].append(entry)

    if len(argv) > 1 and argv[1] == 'test' and '--name' in argv:
        compiles[argv[argv.index('--name') + 1]].append(entry)

    if Path(argv[0]).name == 'node' or Path(argv[0]).name == 'zxc':
        outputs[argv[-1]].append(entry)

for index, line in enumerate(lines[summary_index + 1:], summary_index + 2):
    match = re.search(r'run test (\S+) (\d+) pass \((\d+) total\) (.+)', line)

    if match:
        successes[match[1]].append({'line': index, 'text': line, 'passed': int(match[2]),
                                   'total': int(match[3]), 'timing': match[4]})

for name in ('packages/test/suites.json', 'packages/test/build/runtime.zig',
             'packages/test/src/emit_control_tests.ts', 'packages/test/src/emit_floating_tests.ts',
             'packages/test/src/shared/json.ts', 'packages/test/src/shared/zig_literal.ts',
             'packages/test/src/zig_string.ts'):
    save(source(name), '固定接线源码')

bindings = []
all_ids = []

for suite in selected:
    name = suite['name']
    compilation = single(compiles[name], (name, 'compilation'))
    execution = single(runs[name], (name, 'execution'))
    success = single(successes[name], (name, 'success'))
    assert 'cached' not in success['timing'] and 'MaxRSS:' in success['timing'], name
    assert 'reused' not in success['timing'], name
    assert any(arg == '-Odebug' for arg in compilation['argv']), name
    assert '--listen=-' in execution['argv']
    module_paths = {}

    for arg in compilation['argv']:
        if arg.startswith('-M'):
            module_name, path = arg[2:].split('=', 1)
            path = Path(path)
            module_paths[module_name] = path if path.is_absolute() else frozen / path

    cases_path = module_paths['root']
    program_path = module_paths['program']
    emitter = single(outputs[str(cases_path)], (name, 'emitter'))
    generator = single(outputs[str(program_path)], (name, 'generator'))
    catalog_name = 'packages/test/tests/' + suite['path'] + '.jsonl'
    zx_name = 'packages/test/tests/' + suite['path'] + '.zx'
    catalog_path = source(catalog_name)
    zx_path = source(zx_name)
    assert emitter['argv'][-2] == './' + catalog_name, name
    assert generator['argv'][1] == './' + zx_name, name
    assert generator['argv'][-2] == '--out', name
    rows = [json.loads(line) for line in catalog_path.read_text().splitlines()]
    identifiers = [item['id'] for item in rows]
    actual_ids = [json.loads(match[1]) for match in re.finditer(r'^test ("(?:[^"\\]|\\.)*") \{', cases_path.read_text(), re.M)]
    assert actual_ids == identifiers and identifiers, name
    assert len(set(identifiers)) == len(identifiers), name
    assert success['passed'] == success['total'] == len(identifiers), name
    assert compilation['line'] < execution['line'] < success['line'], name
    assert emitter['line'] < compilation['line'] and generator['line'] < compilation['line'], name
    all_ids.extend(identifiers)
    module_records = {}

    for module_name, path in module_paths.items():
        if module_name == 'root':
            module_records[module_name] = save(path, '生成测试根')
        elif path.is_relative_to(frozen):
            relative = str(path.relative_to(frozen))
            module_records[module_name] = save(source(relative), '固定执行源码')
        else:
            assert path.is_relative_to(run / 'local-debug'), str(path)
            module_records[module_name] = save(path, '生成程序模块')

    for relative in suite.get('sources', []):
        source('packages/test/tests/' + relative)

    bindings.append({'suite': suite, 'case_count': len(identifiers),
                     'ordered_ids_sha256': hashlib.sha256(('\n'.join(identifiers) + '\n').encode()).hexdigest(),
                     'catalog': save(catalog_path, '固定用例目录'), 'zx_source_sha256': source_identities[zx_name],
                     'emitter': emitter, 'generator': generator, 'compilation': compilation,
                     'execution': execution, 'success': success, 'modules': module_records,
                     'binary_sha256': digest(Path(execution['argv'][0])),
                     'cli_sha256': digest(Path(generator['argv'][0]))})

assert len(all_ids) == len(set(all_ids)) == 84786
assert len({item['modules']['root']['source'] for item in bindings}) == 526
assert len({item['modules']['root']['sha256'] for item in bindings}) == 526
assert len({item['execution']['argv'][0] for item in bindings}) == 526
assert len({item['binary_sha256'] for item in bindings}) == 526
result = {'source_commit': manifest['source_commit'], 'root_terminal_exit_code': terminal['terminal_exit_code'],
          'root_log_sha256': terminal['log_sha256'], 'selected_suites': len(selected),
          'delegated_suites_outside_binding': len(suites) - len(selected),
          'case_executions': len(all_ids), 'distinct_case_ids': len(set(all_ids)),
          'binding_errors': 0, 'source_identities': source_identities, 'bindings': bindings,
          'count_boundary': 'Distinct repository case IDs executed in frozen Debug; not unique Test262 originals or distinct semantics.'}
(document / '执行链路.json').write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
(document / '归档清单.json').write_text(json.dumps(list(records.values()), ensure_ascii=False, indent=4) + '\n')
print(json.dumps({'selected_suites': len(selected), 'distinct_case_ids': len(set(all_ids)),
                  'source_files': len(source_identities), 'archives': len(records)}, indent=2))
