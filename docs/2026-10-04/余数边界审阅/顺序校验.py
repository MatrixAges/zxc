from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1])
reviews = list(map(json.loads, Path('packages/test/upstream/reviews/language/expressions/modulus_order.jsonl').read_text().splitlines()))
for row in reviews:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256']

rows = list(map(json.loads, Path('packages/test/tests/runtime/evaluation_order/modulus.jsonl').read_text().splitlines()))
seen = set()
for row in rows:
    value = row['input']
    key = tuple(value[name] for name in ['binding', 'reverse', 'fail_left', 'fail_right'])
    assert key not in seen
    seen.add(key)
    events = [('L', value['fail_left'], 'LeftFailure'), ('R', value['fail_right'], 'RightFailure')]
    if value['reverse']:
        events.reverse()
    expected = {'trace': ''}
    for name, fail, error in events:
        expected['trace'] += name
        if fail:
            expected['error'] = error
            break
    else:
        expected['value'] = 3 % 2 if value['reverse'] else 2 % 3
    assert row['expected'] == expected

assert len(seen) == 16
frontend = list(map(json.loads, Path('packages/test/tests/language/types/modulus_assignment/cases.jsonl').read_text().splitlines()))
expected = ['(x = 1) % x', 'x % (x = 2)', 'x % (x = 1)', '(y = 1) % y']
assert len(frontend) == 4
for row, expression in zip(frontend, expected):
    assert f'return {expression};' in row['source']
    start, end = row['span']
    assert row['source'].encode()[start:end] == b'='
print('4 upstream hashes, 16 unique trace combinations and 4 assignment expressions verified')

assert "const x: f64 = 1;" in frontend[1]["source"]
