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

for name in ('归档清单.json', '原文归档清单.json', 'R1审计归档清单.json'):
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

assert count == 165
identity = json.loads((document / '正式源码身份.json').read_text())
manifest = json.loads(read('r2/起点.json.gz'))
assert identity['compiler_source_commit'] == '695c654ce3350eaa7f561d661135a2682fcb6ea8'
assert len(identity['formal']) == 8 and len(manifest['inputs']) == 24

for name, expected in identity['formal'].items():
    assert digest((root / name).read_bytes()) == expected, name
    assert digest(read('正式源码/' + name + '.gz')) == expected

    if name.endswith('.zx'):
        assert len((root / name).read_text().splitlines()) <= 120

for name in manifest['delivery_paths']:
    assert identity['formal'][name] == manifest['inputs'][name]

for name, expected in manifest['inputs'].items():
    assert digest(read('r2/inputs/' + name + '.gz')) == expected

cli = manifest['tools']['cli']
assert digest(Path(cli['path']).read_bytes()) == cli['sha256']
assert cli['sha256'] == 'b944df937c62b5d1dbb57278f73bfdc82dffc642dd3d166975b4d1b8f51303f4'
origin = json.loads(read('编译器来源/compiler-origin-debug.terminal.json.gz'))
assert origin['terminal_exit_code'] == 0 and origin['changed_inputs'] == []

terminal = json.loads(read('r2/terminal.json.gz'))
assert terminal['gate_passed'] and terminal['changed_inputs'] == [] and terminal['failure'] is None
assert len(terminal['stages']) == 14
assert all(stage['terminal_exit_code'] == 0 for stage in terminal['stages'])
executions = []

for stage in terminal['stages']:
    assert digest(read('r2/' + stage['name'] + '.stdout.txt.gz')) == stage['stdout_sha256']
    assert digest(read('r2/' + stage['name'] + '.stderr.txt.gz')) == stage['stderr_sha256']

    if 'actual_names' in stage:
        assert stage['actual_names'] == stage['expected_names']
        assert digest(Path(stage['binary']).read_bytes()) == stage['binary_sha256']
        executions.extend(stage['actual_names'])

assert len(executions) == 2468 and len(set(executions)) == 1234
assert len(terminal['generated_sources']) == 6

for name, expected in terminal['generated_sources'].items():
    assert digest(read('r2/' + name + '.gz')) == expected



r1 = json.loads(read('r1/terminal.json.gz'))
r1_manifest = json.loads(read('r1/起点.json.gz'))
assert r1['gate_passed'] and r1['changed_inputs'] == [] and r1['failure'] is None
assert len(r1['stages']) == 14 and all(stage['terminal_exit_code'] == 0 for stage in r1['stages'])
assert sum(len(stage.get('actual_names', [])) for stage in r1['stages']) == 2468
assert r1['generated_sources'] == terminal['generated_sources']
assert [name for name, sha in manifest['inputs'].items() if r1_manifest['inputs'][name] != sha] == ['packages/test/build/runtime.zig']

for stage in r1['stages']:
    assert digest(read('r1/' + stage['name'] + '.stdout.txt.gz')) == stage['stdout_sha256']
    assert digest(read('r1/' + stage['name'] + '.stderr.txt.gz')) == stage['stderr_sha256']

candidates = json.loads((document / '候选原文身份.json').read_text())
reviews = [json.loads(line) for line in (root / 'packages/test/upstream/reviews/language/types/number/special_values.jsonl').read_text().splitlines()]
assert len(candidates) == len(reviews) == 6
assert [len(row['assertions']) for row in reviews] == [1, 1, 5, 1, 2, 1]
assert [row['status'] for row in reviews] == ['equivalent', 'adapted', 'equivalent', 'equivalent', 'equivalent', 'adapted']
cases = {}

for fixture in manifest['programs']:
    path = root / 'packages/test' / fixture['source']
    rows = [json.loads(line) for line in path.with_suffix('.jsonl').read_text().splitlines()]

    for row in rows:
        assert row['id'] not in cases
        cases[row['id']] = row

assert len(cases) == 1234

for candidate, review in zip(candidates, reviews):
    assert review['path'] == candidate['path'] and review['sha256'] == candidate['sha256']
    assert digest(read('原文/' + Path(candidate['path']).name + '.gz')) == candidate['sha256']
    assert len(review['assertions']) == candidate['original_assertions']

    for assertion in review['assertions']:
        assert assertion['case'] in review['cases']
        assert cases[assertion['case']]['expected'][assertion['field']] == assertion['expected']
        assert assertion['original_expression']

zero = [row for name, row in cases.items() if name.startswith('language/types/number/signed_zero/division/')]
assert len(zero) == 2 and [row['expected']['value'] for row in zero] == [True, False]
negated = [row for name, row in cases.items() if '/negated/' in name]
assert len(negated) == 2
assert negated[1]['left'] == 'fff0000000000000' and negated[1]['right'] == '7ff0000000000000'
assert reviews[2]['assertions'][0]['case'] == reviews[2]['assertions'][2]['case']
assert reviews[2]['assertions'][0]['original_expression'] != reviews[2]['assertions'][2]['original_expression']
original = json.loads(read('原文执行/stdout.json.gz'))
receipt = json.loads(read('原文执行/terminal.json.gz'))
assert original['unique_originals'] == 6 and original['original_assertions_per_mode'] == 11
assert len(original['executions']) == 12 and all(item['result'] == 'passed' for item in original['executions'])
assert receipt['terminal_exit_code'] == 0
assert receipt['runner_sha256'] == digest(read('原文执行/run-originals.mjs.gz'))
assert receipt['candidate_sha256'] == digest((document / '候选原文身份.json').read_bytes())
assert receipt['stdout_sha256'] == digest(read('原文执行/stdout.json.gz'))
assert receipt['stderr_sha256'] == digest(read('原文执行/stderr.txt.gz'))

for item in original['harness']:
    assert digest(read('Harness/' + Path(item['path']).name + '.gz')) == item['sha256']

audit = json.loads(read('发布目录审计/audit.stdout.json.gz'))
receipt = json.loads(read('发布目录审计/audit.terminal.json.gz'))
assert receipt['terminal_exit_code'] == 0 and receipt['changed_inputs'] == []
assert audit['reviewed'] == {'adapted': 862, 'excluded': 2089, 'equivalent': 107}
assert audit['unreviewed'] == 50539 and audit['catalog_cases'] == 140788
assert audit['catalog_by_runner']['runtime'] == 96731 and audit['linked_cases'] == 6992
assert digest(read('发布目录审计/audit.stdout.json.gz')) == receipt['stdout_sha256']
assert digest(read('发布目录审计/audit.stderr.txt.gz')) == receipt['stderr_sha256']
assert digest(read('发布目录审计/audit-runner.py.gz')) == receipt['runner_sha256']
print('PASS: six originals, eleven assertions, 1234 cases, 2468 final executions and 165 immutable archives')
