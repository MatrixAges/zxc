from pathlib import Path
import hashlib
import json
import re

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
load = lambda path: [json.loads(line) for line in path.read_text().splitlines()]
reviews = load(repo / 'packages/test/upstream/reviews/language/expressions/addition_boundaries.jsonl')
assert len(reviews) == 5
for row in reviews:
    assert hashlib.sha256((upstream / row['path']).read_bytes()).hexdigest() == row['sha256']

original = (upstream / 'test/language/expressions/addition/S11.6.1_A1.js').read_text()
expressions = [json.loads('"' + value + '"') for value in re.findall(r'if \(eval\("(.*?)"\) !== 2\)', original)]
assert len(expressions) == 10
front = load(repo / 'packages/test/tests/language/types/addition_whitespace/cases.jsonl')
assert len(front) == 60
number_both = [row for row in front if row['id'].endswith('/both/number')]
assert len(number_both) == 10
for expression, row in zip(expressions, number_both):
    assert 'return ' + expression + ';' in row['source']

runtime = load(repo / 'packages/test/tests/language/expressions/addition/whitespace.jsonl')
assert len(runtime) == 54
for row in runtime:
    assert row['expected']['value'] == row['input']['value'] + 1

assignments = load(repo / 'packages/test/tests/language/types/addition_assignment/cases.jsonl')
for row in assignments:
    start, end = row['span']
    assert row['source'][start:end] == '='
assert 'const x: f64 = 0;' in assignments[0]['source']
assert 'const x: f64 = 0;' in assignments[1]['source']
assert '(x = 1) + x' in assignments[0]['source']
assert 'x + (x = 1)' in assignments[1]['source']

traces = load(repo / 'packages/test/tests/runtime/evaluation_order/addition.jsonl')
assert len(traces) == 16
for row in traces:
    inputs = row['input']
    order = ['R', 'L'] if inputs['reverse'] else ['L', 'R']
    events = ''
    expected = {'value': 5}
    for side in order:
        events += side
        if inputs['fail_left' if side == 'L' else 'fail_right']:
            expected = {'error': 'LeftFailure' if side == 'L' else 'RightFailure'}
            break
    expected['trace'] = events
    assert row['expected'] == expected

print('PASS: 5 hashes, 10 original whitespace sequences, 54 numeric rows, 4 assignment spans and 16 independent event traces')
