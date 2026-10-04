from pathlib import Path
from collections import Counter
import hashlib
import json
import re
import subprocess

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
reviews = [json.loads(line) for line in (repo / 'packages/test/upstream/reviews/language/expressions/addition_protocols.jsonl').read_text().splitlines()]
assert len(reviews) == 17
sources = {}

for row in reviews:
    path = upstream / row['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest() == row['sha256']
    assert row['status'] == 'excluded' and row['cases'] == []
    sources[path.name] = path.read_text()

source = sources['bigint-arithmetic.js']
items = re.findall(r'assert\.sameValue\(\s*(-?0x[0-9A-F]+)n\s*\+\s*(-?0x[0-9A-F]+)n,\s*(-?0x[0-9A-F]+)n,', source)
ast = json.loads(subprocess.check_output(['ast-grep', 'run', '--lang', 'javascript', '--pattern', 'assert.sameValue($$$ARGS)', str(upstream / 'test/language/expressions/addition/bigint-arithmetic.js'), '--json=compact']))
assert len(items) == len(ast) == source.count('assert.sameValue(') == 306
rows = [tuple(int(value, 0) for value in item) for item in items]
values = {left for left, _, _ in rows}
pairs = Counter((left, right) for left, right, _ in rows)
assert len(values) == 17 and values == {right for _, right, _ in rows}
assert len(pairs) == 153 and set(pairs.values()) == {2}
assert set(pairs) == {(left, right) for left in values for right in values if left >= right}
assert all(left + right == expected for left, right, expected in rows)
assert sum(expected > 2 ** 64 - 1 for _, _, expected in rows) == 6
assert sum(not -(2 ** 63) <= expected < 2 ** 63 for _, _, expected in rows) == 116

counts = {
    'bigint-and-number.js': (0, 18), 'bigint-errors.js': (0, 10),
    'bigint-toprimitive.js': (20, 24), 'bigint-wrapped-values.js': (8, 0),
    'coerce-bigint-to-string.js': (10, 0), 'coerce-symbol-to-prim-err.js': (2, 2),
    'coerce-symbol-to-prim-invocation.js': (7, 0), 'coerce-symbol-to-prim-return-obj.js': (0, 4),
    'coerce-symbol-to-prim-return-prim.js': (8, 4), 'get-symbol-to-prim-err.js': (2, 2),
    'order-of-evaluation.js': (6, 6), 'symbol-to-string.js': (0, 1),
}
for name, (same, throws) in counts.items():
    assert sources[name].count('assert.sameValue(') == same
    assert sources[name].count('assert.throws(') == throws

assert re.findall(r'assert.sameValue\(trace, "(\d+)"', sources['order-of-evaluation.js']) == ['1', '12', '123', '1234', '1234', '1234']
for name, count in [('S11.6.1_A2.2_T1.js', 8), ('S11.6.1_A2.2_T2.js', 4), ('S11.6.1_A2.2_T3.js', 4), ('S11.6.1_A2.3_T1.js', 1)]:
    assert re.findall(r'//CHECK#(\d+)', sources[name]) == [str(index) for index in range(1, count + 1)]

strings = re.findall(r'assert.sameValue\((.*?), "(-?\d+)"\);', sources['coerce-bigint-to-string.js'])
assert len(strings) == 10
for expression, expected in strings:
    value = re.fullmatch(r'(-?\d+)n \+ ""', expression) or re.fullmatch(r'"" \+ (-?\d+)n', expression)
    assert value and str(int(value[1])) == expected

print('PASS: 17 hashes, 306 AST arithmetic assertions, 153 distinct pairs each duplicated, all independent sums, overflow ranges, protocol counts and order, 10 decimal strings')
