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

for name in ('归档清单.json', '原文归档清单.json'):
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

assert count == 67
identity = json.loads((document / '正式源码身份.json').read_text())
manifest = json.loads(read('r1/起点.json.gz'))
assert identity['compiler_source_commit'] == '695c654ce3350eaa7f561d661135a2682fcb6ea8'
assert len(identity['formal']) == 8 and len(manifest['inputs']) == 14

for name, expected in identity['formal'].items():
    assert digest((root / name).read_bytes()) == expected, name
    assert digest(read('正式源码/' + name + '.gz')) == expected

    if name.endswith('.zx'):
        assert len((root / name).read_text().splitlines()) <= 120

for name in manifest['delivery_paths']:
    assert identity['formal'][name] == manifest['inputs'][name]

for name, expected in manifest['inputs'].items():
    assert digest(read('r1/inputs/' + name + '.gz')) == expected

cli = manifest['tools']['cli']
assert digest(Path(cli['path']).read_bytes()) == cli['sha256']
assert cli['sha256'] == 'b944df937c62b5d1dbb57278f73bfdc82dffc642dd3d166975b4d1b8f51303f4'
origin = json.loads(read('编译器来源/compiler-origin-debug.terminal.json.gz'))
assert origin['terminal_exit_code'] == 0 and origin['changed_inputs'] == []

terminal = json.loads(read('r1/terminal.json.gz'))
assert terminal['gate_passed'] and terminal['changed_inputs'] == [] and terminal['failure'] is None
assert len(terminal['stages']) == 9
assert all(stage['terminal_exit_code'] == 0 for stage in terminal['stages'])
executions = []

for stage in terminal['stages']:
    assert digest(read('r1/' + stage['name'] + '.stdout.txt.gz')) == stage['stdout_sha256']
    assert digest(read('r1/' + stage['name'] + '.stderr.txt.gz')) == stage['stderr_sha256']

    if 'actual_names' in stage:
        assert stage['actual_names'] == stage['expected_names']
        assert digest(Path(stage['binary']).read_bytes()) == stage['binary_sha256']
        executions.extend(stage['actual_names'])

assert len(executions) == 6 and len(set(executions)) == 3
assert len(terminal['generated_sources']) == 4

for name, expected in terminal['generated_sources'].items():
    assert digest(read('r1/' + name + '.gz')) == expected


candidates = json.loads((document / '候选原文身份.json').read_text())
reviews = [json.loads(line) for line in (root / 'packages/test/upstream/reviews/language/types/boolean_null.jsonl').read_text().splitlines()]
assert len(candidates) == len(reviews) == 2

for candidate, review in zip(candidates, reviews):
    assert review['path'] == candidate['path'] and review['sha256'] == candidate['sha256']
    assert digest(read('原文/' + Path(candidate['path']).name + '.gz')) == candidate['sha256']
    assert review['status'] == 'adapted'

boolean_cases = [json.loads(line) for line in (root / 'packages/test/tests/language/types/boolean/negation.jsonl').read_text().splitlines()]
null_cases = [json.loads(line) for line in (root / 'packages/test/tests/language/types/null/binding.jsonl').read_text().splitlines()]
assert len(boolean_cases) == 2 and len(null_cases) == 1
original_case = boolean_cases[0]
assert reviews[0]['cases'] == [original_case['id']]
assert len(reviews[0]['assertions']) == 4
assert {item['observation_field'] for item in reviews[0]['assertions']} == {
    'value.strict_false', 'value.abstract_false', 'value.strict_true', 'value.abstract_true',
}

for item in reviews[0]['assertions']:
    field = item['observation_field'].split('.')[1]
    assert item['case'] == original_case['id'] and item['field'] == 'value'
    assert item['expected'] == original_case['expected']['value']
    assert item['observation_expected'] is True and item['expected'][field] is True

assert [item['input'] for item in boolean_cases] == [False, True]
assert [item['expected']['value']['negated_input'] for item in boolean_cases] == [True, False]
assert reviews[1]['cases'] == [null_cases[0]['id']] and reviews[1]['assertions'] == []
assert null_cases[0]['expected'] == {'value': None}
original = json.loads(read('原文执行/stdout.json.gz'))
assert original['unique_originals'] == 2 and original['original_assertions_per_mode'] == 4
assert len(original['executions']) == 4 and all(item['result'] == 'passed' for item in original['executions'])
assert json.loads(read('原文执行/terminal.json.gz'))['terminal_exit_code'] == 0

for item in original['harness']:
    assert digest(read('Harness/' + Path(item['path']).name + '.gz')) == item['sha256']

audit = json.loads(read('发布目录审计/audit.stdout.json.gz'))
receipt = json.loads(read('发布目录审计/audit.terminal.json.gz'))
assert receipt['terminal_exit_code'] == 0 and receipt['changed_inputs'] == []
assert audit['reviewed'] == {'adapted': 860, 'excluded': 2089, 'equivalent': 103}
assert audit['unreviewed'] == 50545 and audit['catalog_cases'] == 140785
assert audit['catalog_by_runner']['runtime'] == 96728 and audit['linked_cases'] == 6990
assert digest(read('发布目录审计/audit.stdout.json.gz')) == receipt['stdout_sha256']
assert digest(read('发布目录审计/audit.stderr.txt.gz')) == receipt['stderr_sha256']
print('PASS: four bool assertions, null normal completion, three cases, six executions and 67 immutable archives')
