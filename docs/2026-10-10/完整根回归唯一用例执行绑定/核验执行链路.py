# coding: utf-8
import gzip
import hashlib
import json
from collections import defaultdict
from pathlib import Path
import re
import shlex


document = Path(__file__).resolve().parent
evidence = json.loads((document / '执行链路.json').read_text())
records = json.loads((document / '归档清单.json').read_text())
original = document.parent / 'Indexed入口根回归Debug终态/原始终态'
manifest = json.loads(gzip.decompress((original / '起点.json.gz').read_bytes()))
terminal = json.loads(gzip.decompress((original / 'debug.terminal.json.gz').read_bytes()))
raw_log = gzip.decompress((original / 'debug.log.txt.gz').read_bytes())
lines = raw_log.decode().splitlines()
assert hashlib.sha256(raw_log).hexdigest() == evidence['root_log_sha256'] == terminal['log_sha256']
assert evidence['source_commit'] == manifest['source_commit'] == 'bbd92b5c536139a6a36ce3ad4e0062768bf1337f'
assert evidence['root_terminal_exit_code'] == terminal['terminal_exit_code'] == 1
assert evidence['selected_suites'] == len(evidence['bindings']) == 526
assert evidence['delegated_suites_outside_binding'] == 52 and evidence['binding_errors'] == 0
cached = {}
compiles = defaultdict(list)
runs = defaultdict(list)
final_nodes = defaultdict(list)
summary_index = next(index for index, line in enumerate(lines) if line.startswith('Build Summary:'))

for index, line in enumerate(lines[:summary_index], 1):
    if not line.startswith('info(verbose): '):
        continue

    argv = shlex.split(line[len('info(verbose): '):])

    if len(argv) > 1 and argv[1] == 'test' and '--name' in argv:
        compiles[argv[argv.index('--name') + 1]].append(index)
    elif argv and '/o/' in argv[0] and '--listen=-' in argv:
        runs[Path(argv[0]).name].append(index)

for index, line in enumerate(lines[summary_index + 1:], summary_index + 2):
    match = re.search(r'run test (\S+) (\d+) pass(?:, (\d+) fail)? \((\d+) total\)', line)

    if match:
        final_nodes[match[1]].append(index)


def digest(path):
    identity = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            identity.update(block)

    return identity.hexdigest()


def read(item):
    raw = cached[item['saved']]
    assert hashlib.sha256(raw).hexdigest() == item['sha256']

    return raw


for record in records:
    encoded = (document / record['saved']).read_bytes()
    raw = gzip.decompress(encoded)
    assert len(encoded) == record['saved_bytes'] and len(raw) == record['raw_bytes']
    assert hashlib.sha256(encoded).hexdigest() == record['saved_sha256']
    assert hashlib.sha256(raw).hexdigest() == record['raw_sha256']
    assert record['saved'] not in cached
    cached[record['saved']] = raw

archived_paths = {str(path.relative_to(document)) for directory in
                  ('固定接线源码', '固定执行源码', '固定用例目录', '生成测试根', '生成程序模块')
                  for path in (document / directory).glob('*.gz')}
assert archived_paths == set(cached)

for name, identity in evidence['source_identities'].items():
    assert identity == manifest['sources'][name]
    assert digest(Path(manifest['cwd']) / name) == identity, name

all_ids = []
binary_identities = {}
cli_identities = {}

for binding in evidence['bindings']:
    name = binding['suite']['name']
    catalog = [json.loads(line) for line in read(binding['catalog']).decode().splitlines()]
    identifiers = [row['id'] for row in catalog]
    test_source = read(binding['modules']['root']).decode()
    actual_ids = [json.loads(match[1]) for match in re.finditer(r'^test ("(?:[^"\\]|\\.)*") \{', test_source, re.M)]
    assert identifiers == actual_ids and len(identifiers) == binding['case_count']
    assert hashlib.sha256(('\n'.join(identifiers) + '\n').encode()).hexdigest() == binding['ordered_ids_sha256']

    for key in ('emitter', 'generator', 'compilation', 'execution'):
        entry = binding[key]
        line = lines[entry['line'] - 1]
        assert line.startswith('info(verbose): ')
        assert shlex.split(line[len('info(verbose): '):]) == entry['argv']

    success = binding['success']
    assert lines[success['line'] - 1] == success['text']
    assert re.search(r'run test ' + re.escape(name) + r' ' + str(len(identifiers)) + r' pass \(' + str(len(identifiers)) + r' total\)', success['text'])
    assert 'cached' not in success['text'] and 'reused' not in success['text'] and 'MaxRSS:' in success['text']
    assert binding['compilation']['line'] < binding['execution']['line'] < success['line']
    assert compiles[name] == [binding['compilation']['line']]
    assert runs[name] == [binding['execution']['line']]
    assert final_nodes[name] == [success['line']]
    compile_args = binding['compilation']['argv']
    assert compile_args[compile_args.index('--name') + 1] == name
    assert compile_args[compile_args.index('--cache-dir') + 1] == str(Path(binding['modules']['root']['source']).parents[2])
    assert binding['execution']['argv'][0].endswith('/' + name)
    assert '--listen=-' in binding['execution']['argv']
    cache = str(Path(binding['modules']['root']['source']).parents[2])
    assert '--cache-dir=' + cache in binding['execution']['argv']
    assert Path(binding['execution']['argv'][0]).is_relative_to(Path(cache) / 'o')
    module_args = [arg[2:].split('=', 1) for arg in compile_args if arg.startswith('-M')]
    assert len(module_args) == len({key for key, path in module_args})
    assert set(binding['modules']) == {key for key, path in module_args}

    for key, path in module_args:
        path = Path(path)
        actual_path = path if path.is_absolute() else Path(manifest['cwd']) / path
        assert str(actual_path) == binding['modules'][key]['source']

    assert binding['emitter']['argv'][-1] == binding['modules']['root']['source']
    assert binding['generator']['argv'][-1] == binding['modules']['program']['source']
    assert binding['emitter']['line'] < binding['compilation']['line']
    assert binding['generator']['line'] < binding['compilation']['line']
    binary_identities[binding['execution']['argv'][0]] = binding['binary_sha256']
    cli_identities[binding['generator']['argv'][0]] = binding['cli_sha256']

    for module in binding['modules'].values():
        assert digest(module['source']) == module['sha256']
        read(module)

    all_ids.extend(identifiers)

assert len(all_ids) == len(set(all_ids)) == evidence['distinct_case_ids'] == evidence['case_executions'] == 84786
assert len({item['modules']['root']['source'] for item in evidence['bindings']}) == 526
assert len({item['modules']['root']['sha256'] for item in evidence['bindings']}) == 526
assert len(binary_identities) == len(set(binary_identities.values())) == 526

for path, expected in {**binary_identities, **cli_identities}.items():
    assert digest(path) == expected, path

receipt = json.loads((document / '生成断言复算终态.json').read_text())
assert receipt['source_commit'] == evidence['source_commit']
assert receipt['executed_emitters'] == len(receipt['records']) == 526
assert receipt['all_generated_sources_byte_equal'] is True
assert receipt['runner_sha256'] == digest(document / '复算生成断言.py')
assert receipt['node_sha256'] == manifest['tools']['node']['sha256']

for binding, reproduced in zip(evidence['bindings'], receipt['records']):
    assert reproduced['suite'] == binding['suite']['name']
    assert reproduced['terminal_exit_code'] == 0
    assert reproduced['generated_sha256'] == binding['modules']['root']['sha256']
    assert reproduced['argv'][1:-1] == binding['emitter']['argv'][1:-1]
    assert digest(reproduced['argv'][-1]) == reproduced['generated_sha256']

print('PASS: 526 actual successful Debug nodes, 84786 distinct repository case IDs and immutable archived execution inputs')
