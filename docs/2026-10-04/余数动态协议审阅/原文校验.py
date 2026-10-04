from pathlib import Path
import hashlib
import json
import re
import subprocess

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
reviews = [json.loads(line) for line in (repo / 'packages/test/upstream/reviews/language/expressions/modulus_protocols.jsonl').read_text().splitlines()]
assert len(reviews) == 9
sources = {}

for row in reviews:
    path = upstream / row['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest() == row['sha256']
    assert row['status'] == 'excluded' and row['cases'] == []
    sources[path.name] = path.read_text()

source = sources['bigint-arithmetic.js']
items = re.findall(r'assert\.sameValue\(\s*(-?0x[0-9A-F]+)n\s*%\s*(-?0x[0-9A-F]+)n,\s*(-?0x[0-9A-F]+)n,', source)
ast = json.loads(subprocess.check_output(['ast-grep', 'run', '--lang', 'javascript', '--pattern', 'assert.sameValue($$$ARGS)', str(upstream / 'test/language/expressions/modulus/bigint-arithmetic.js'), '--json=compact']))
assert len(items) == len(ast) == source.count('assert.sameValue(') == 256
rows = [tuple(int(value, 0) for value in item) for item in items]
values = {left for left, _, _ in rows}
assert len(values) == 16 and values == {right for _, right, _ in rows}
assert {(left, right) for left, right, _ in rows} == {(left, right) for left in values for right in values}
different = 0

for left, right, expected in rows:
    quotient = abs(left) // abs(right)
    if (left < 0) != (right < 0):
        quotient = -quotient
    assert left - quotient * right == expected
    assert abs(expected) < abs(right)
    assert expected == 0 or (expected < 0) == (left < 0)
    different += left % right != expected

assert different == 90
assert min(values) < -(2 ** 63)
counts = {'bigint-and-number.js': (0, 20), 'bigint-errors.js': (0, 10), 'bigint-wrapped-values.js': (8, 0), 'bigint-toprimitive.js': (20, 24), 'bigint-modulo-zero.js': (0, 4), 'order-of-evaluation.js': (6, 6)}
for name, (same, throws) in counts.items():
    assert sources[name].count('assert.sameValue(') == same
    assert sources[name].count('assert.throws(') == throws

assert re.findall(r'assert.sameValue\(trace, "(\d+)"', sources['order-of-evaluation.js']) == ['1', '12', '123', '1234', '123', '1234']
assert re.findall(r'//CHECK#(\d+)', sources['S11.5.3_A2.2_T1.js']) == list('12345678')
print('PASS: 9 hashes, 256 AST assertions, full 16x16 product, independent remainder arithmetic, 90 sign differences, protocol assertion counts and traces')
