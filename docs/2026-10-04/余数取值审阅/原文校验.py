from pathlib import Path
import hashlib
import json

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
base = repo / 'packages/test/tests/language/expressions/modulus'
reviews = repo / 'packages/test/upstream/reviews/language/expressions/modulus_names.jsonl'

for line in reviews.read_text().splitlines():
    row = json.loads(line)
    assert hashlib.sha256((upstream / row['path']).read_bytes()).hexdigest() == row['sha256']

original = (upstream / 'test/language/expressions/modulus/S11.5.3_A2.1_T1.js').read_text()
for expression in ['1 % 2', 'x % 2', '1 % y', 'x % y', 'objectx.prop % objecty.prop']:
    assert 'if (' + expression + ' !== 1)' in original

rows = [json.loads(line) for line in (base / 'source/values.jsonl').read_text().splitlines()]
expected = [(1, 2, 1, 1), (5, 3, 1, 2), (-5, 3, -1, -2), (5, -3, 1, 2)]
assert len(rows) == len(expected)
for row, (left, right, left_result, both) in zip(rows, expected):
    assert row['input'] == {'left': left, 'right': right}
    assert row['expected']['value'] == dict(literal=1, left=left_result, right=1, both=both, fields=both)

sequence = '18\n\n%\n\n7\n\n%\n\n3'
assert sequence in (upstream / 'test/language/expressions/modulus/line-terminator.js').read_text()
assert sequence in (base / 'source/lines.zx').read_text()

names = [json.loads(line) for line in (base / 'names/cases.jsonl').read_text().splitlines()]
assert len(names) == 4
for row in names:
    if row['diagnostic']:
        start, end = row['span']
        assert row['source'][start:end] == 'missing'
        assert 'const missing' not in row['source']
    else:
        assert 'const missing = in;' in row['source']

print('PASS: 4 hashes, 5 original assertions, 4 independent numeric rows, exact line sequence, 4 name cases')
