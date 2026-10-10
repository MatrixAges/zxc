# coding: utf-8
import gzip
import hashlib
import json
from pathlib import Path


document = Path(__file__).resolve().parent
root = document.parents[2]


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def read(name):
    return gzip.decompress((document / name).read_bytes())


count = 0

for name in ('归档清单.json', '原文归档清单.json', '精确模型归档清单.json'):
    records = json.loads((document / name).read_text())
    assert len({record['saved'] for record in records}) == len(records)

    for record in records:
        encoded = (document / record['saved']).read_bytes()
        raw = gzip.decompress(encoded)
        assert digest(encoded) == record['saved_sha256'], record['saved']
        assert digest(raw) == record['raw_sha256'], record['saved']
        assert len(raw) == record['raw_bytes'], record['saved']

        if 'saved_bytes' in record:
            assert len(encoded) == record['saved_bytes']

        count += 1

assert count == 144
identity = json.loads((document / '正式源码身份.json').read_text())
manifest = json.loads(read('r3/起点.json.gz'))
assert identity['compiler_source_commit'] == '695c654ce3350eaa7f561d661135a2682fcb6ea8'
assert len(identity['formal']) == 11 and len(manifest['inputs']) == 21

for name, expected in identity['formal'].items():
    assert digest((root / name).read_bytes()) == expected, name
    assert digest(read('正式源码/' + name + '.gz')) == expected

    if name.endswith('.zx'):
        assert len((root / name).read_text().splitlines()) <= 120

for name in manifest['delivery_paths']:
    assert identity['formal'][name] == manifest['inputs'][name]

for name, expected in manifest['inputs'].items():
    assert digest(read('r3/inputs/' + name + '.gz')) == expected

cli = manifest['tools']['cli']
assert digest(Path(cli['path']).read_bytes()) == cli['sha256']
assert cli['sha256'] == 'b944df937c62b5d1dbb57278f73bfdc82dffc642dd3d166975b4d1b8f51303f4'
origin = json.loads(read('编译器来源/compiler-origin-debug.terminal.json.gz'))
assert origin['terminal_exit_code'] == 0 and origin['changed_inputs'] == []

terminal = json.loads(read('r3/terminal.json.gz'))
assert terminal['gate_passed'] and terminal['changed_inputs'] == [] and terminal['failure'] is None
assert len(terminal['stages']) == 9
assert all(stage['terminal_exit_code'] == 0 for stage in terminal['stages'])
executions = []

for stage in terminal['stages']:
    assert digest(read('r3/' + stage['name'] + '.stdout.txt.gz')) == stage['stdout_sha256']
    assert digest(read('r3/' + stage['name'] + '.stderr.txt.gz')) == stage['stderr_sha256']

    if 'actual_names' in stage:
        assert stage['actual_names'] == stage['expected_names']
        assert digest(Path(stage['binary']).read_bytes()) == stage['binary_sha256']
        executions.extend(stage['actual_names'])

assert len(executions) == 6 and len(set(executions)) == 3
assert len(terminal['generated_sources']) == 4

for name, expected in terminal['generated_sources'].items():
    assert digest(read('r3/' + name + '.gz')) == expected

r1 = json.loads(read('r1/terminal.json.gz'))
r2 = json.loads(read('r2/terminal.json.gz'))
assert not r1['gate_passed'] and 'Permission denied' in r1['failure']
assert not r2['gate_passed'] and r2['stages'][-1]['terminal_exit_code'] == 1
assert not any('actual_names' in stage for phase in (r1, r2) for stage in phase['stages'])

samples = [json.loads(line) for line in (root / 'packages/test/src/data/rounding_steps.jsonl').read_text().splitlines()]
reviews = [json.loads(line) for line in (root / 'packages/test/upstream/reviews/language/types/number/rounding_steps.jsonl').read_text().splitlines()]
originals = [sample for sample in samples if 'path' in sample]
assert len(samples) == 3 and len(originals) == len(reviews) == 2

for sample, review in zip(originals, reviews):
    assert review['path'] == sample['path'] and review['sha256'] == sample['sha256']
    assert digest(read('原文/' + Path(sample['path']).name + '.gz')) == sample['sha256']
    assert review['status'] == 'adapted' and review['cases'] == [sample['id']]
    assert review['assertions'] == [{'case': sample['id'], 'field': 'value', 'expected': True}]

original = json.loads(read('原文执行/stdout.json.gz'))
assert original['unique_originals'] == original['original_assertions_per_mode'] == 2
assert len(original['executions']) == 4 and all(item['result'] == 'passed' for item in original['executions'])
assert json.loads(read('原文执行/terminal.json.gz'))['terminal_exit_code'] == 0
audit = json.loads(read('发布目录审计/audit.stdout.json.gz'))
receipt = json.loads(read('发布目录审计/audit.terminal.json.gz'))
assert receipt['terminal_exit_code'] == 0 and receipt['changed_inputs'] == []
assert audit['reviewed'] == {'adapted': 858, 'excluded': 2089, 'equivalent': 103}
assert audit['unreviewed'] == 50547 and audit['catalog_cases'] == 140782
assert audit['catalog_by_runner']['runtime'] == 96725 and audit['linked_cases'] == 6988
print('PASS: two originals, separate assertions, three cases, six final executions and 144 immutable archives')
