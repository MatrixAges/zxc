import gzip
import hashlib
import json
from pathlib import Path
import re


document = Path(__file__).resolve().parent
root = document.parents[2]
decoded = {}
compilers = {}


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


for name in ('r1-debug归档清单.json', 'r2-debug归档清单.json', 'r2-safe归档清单.json',
             '原文归档清单.json', '发布审计归档清单.json', '预验证归档清单.json'):
    for record in json.loads((document / name).read_text()):
        data = (document / record['saved']).read_bytes()
        raw = gzip.decompress(data)
        assert digest(data) == record['saved_sha256']
        assert digest(raw) == record['raw_sha256'] and len(raw) == record['raw_bytes']
        assert Path(record['source']).read_bytes() == raw
        decoded[record['saved'][:-3]] = raw

identity = json.loads((document / '正式源码身份.json').read_text())
assert len(identity['overlay']) == 20

for name, expected in identity['overlay'].items():
    assert digest((root / name).read_bytes()) == expected

    if name.endswith('.zx'):
        assert len((root / name).read_text().splitlines()) <= 120

for label in ('r1-debug', 'r2-debug', 'r2-safe'):
    result = json.loads((document / (label + '阶段结果.json')).read_text())
    assert result['terminal_exit_code'] == 0
    assert result['runtime_records'] == 8 and result['named_executions'] == 12
    assert result['final_pointer_and_length_checks'] == label.startswith('r2-')
    terminal = json.loads(decoded[label + '/执行/' + result['mode'] + '.terminal.json'])
    assert terminal['terminal_exit_code'] == 0 and terminal['changed_inputs'] == []
    assert digest(decoded[label + '/执行/' + result['mode'] + '.log.txt']) == terminal['log_sha256']
    compiler = {}

    for record in json.loads((document / (label + '归档清单.json')).read_text()):
        if '/生成编译器/' in record['saved']:
            compiler[Path(record['source']).name] = record['raw_sha256']

    assert len(compiler) == 93
    compilers[label] = compiler

    for execution in result['executions']:
        prefix = label + '/运行路线/' + execution['route'] + '/'
        assert execution['status'] == 0 and execution['signal'] is None and execution['error'] is None
        names = re.findall(r'^test "([^"\n]+)"', decoded[prefix + 'cases.zig'].decode(), re.MULTILINE)
        assert execution['names'] == names
        assert digest(Path(execution['binary']).read_bytes()) == execution['binary_sha256']
        assert ('All ' + str(len(names)) + ' tests passed.').encode() in decoded[prefix + 'runtime/execution.log']

assert compilers['r1-debug'] == compilers['r2-debug'] == compilers['r2-safe']
candidates = json.loads((document / '候选原文身份.json').read_text())
paths = {row['path']: row['sha256'] for row in candidates}
assert len(paths) == 4 and sum(row['original_assertions'] for row in candidates) == 7
reviews = [json.loads(line) for line in (root / 'packages/test/upstream/reviews/built_ins/array/predicate_order.jsonl').read_text().splitlines()]
assert len(reviews) == 4 and {row['path']: row['sha256'] for row in reviews} == paths
assert all(row['status'] == 'adapted' and len(row['cases']) == 1 for row in reviews)
assert sum(len(row['assertions']) for row in reviews) == 7
rows = {}

for method in ('every', 'some'):
    for rule in ('cursor', 'visited'):
        source = root / ('packages/test/tests/built_ins/list/predicates/order/' + method + '/' + rule + '.jsonl')

        for line in source.read_text().splitlines():
            row = json.loads(line)
            assert row['id'] not in rows
            rows[row['id']] = row

assert len(rows) == 6

for candidate in candidates:
    assert digest(decoded['上游原文/' + candidate['path']]) == candidate['sha256']
    review = next(row for row in reviews if row['path'] == candidate['path'])
    assert len(review['assertions']) == candidate['original_assertions']

    for assertion in review['assertions']:
        assert rows[assertion['case']]['expected'][assertion['field']] == assertion['expected']

original = json.loads((document / '原文执行/originals.stdout.json.txt').read_text())
terminal = json.loads((document / '原文执行/originals.terminal.json.txt').read_text())
assert terminal['terminal_exit_code'] == 0
assert digest((document / '原文执行/originals.stdout.json.txt').read_bytes()) == terminal['stdout_sha256']
assert digest((document / '原文执行/run-originals.mjs.txt').read_bytes()) == terminal['runner_sha256']
assert len(original['executions']) == 8 and original['original_assertions_per_mode'] == 7
assert {(row['path'], row['mode']) for row in original['executions']} == {(path, mode) for path in paths for mode in ('sloppy', 'strict')}
assert all(row['result'] == 'passed' and row['sha256'] == paths[row['path']] for row in original['executions'])

audit = json.loads(decoded['发布目录审计/catalog-audit.stdout.json'])
terminal = json.loads(decoded['发布目录审计/catalog-audit.terminal.json'])
assert terminal['exit_code'] == 0 and terminal['changed_inputs'] == []
assert digest(decoded['发布目录审计/catalog-audit.stdout.json']) == terminal['stdout_sha256']
assert audit['reviewed'] == {'adapted': 856, 'excluded': 2089, 'equivalent': 103}
assert audit['upstream_files'] == 53597 and audit['unreviewed'] == 50549
assert audit['catalog_cases'] == 140779

print('PASS: four originals, seven assertions, six cases, 24 final executions and complete immutable evidence')
