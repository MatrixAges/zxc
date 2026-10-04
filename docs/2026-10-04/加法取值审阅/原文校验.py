from pathlib import Path
import hashlib
import json

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
base = repo / 'packages/test/tests/language/expressions/addition'
reviews = repo / 'packages/test/upstream/reviews/language/expressions/addition_names.jsonl'

for line in reviews.read_text().splitlines():
    row = json.loads(line)
    assert hashlib.sha256((upstream / row['path']).read_bytes()).hexdigest() == row['sha256']

original = (upstream / 'test/language/expressions/addition/S11.6.1_A2.1_T1.js').read_text()
for expression in ['1 + 1', 'x + 1', '1 + y', 'x + y', 'objectx.prop + objecty.prop']:
    assert 'if (' + expression + ' !== 2)' in original

rows = [json.loads(line) for line in (base / 'source/values.jsonl').read_text().splitlines()]
expected = [(1, 1, 2, 2, 2), (5, 3, 6, 4, 8), (-5, 3, -4, 4, -2), (5, -3, 6, -2, 2)]
assert len(rows) == len(expected)
for row, (left, right, left_result, right_result, both) in zip(rows, expected):
    assert row['input'] == {'left': left, 'right': right}
    assert row['expected']['value'] == dict(literal=2, left=left_result, right=right_result, both=both, fields=both)

names = [json.loads(line) for line in (base / 'names/cases.jsonl').read_text().splitlines()]
assert len(names) == 4
for row in names:
    if row['diagnostic']:
        start, end = row['span']
        assert row['source'][start:end] == 'missing'
        assert 'const missing' not in row['source']
    else:
        assert 'const missing = in;' in row['source']

print('PASS: 3 hashes, 5 original assertions, 4 independent numeric rows, 4 name cases')
