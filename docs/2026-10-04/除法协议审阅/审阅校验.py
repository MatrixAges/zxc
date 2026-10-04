from pathlib import Path
import hashlib
import json
import re
import sys

root = Path(sys.argv[1])
index = {r['path']: r['sha256'] for r in map(json.loads, Path('packages/test/upstream/index/language.jsonl').read_text().splitlines())}
files = ['S11.5.2_A2.2_T1.js', 'S11.5.2_A2.3_T1.js', 'bigint-and-number.js', 'bigint-arithmetic.js', 'bigint-complex-infinity.js', 'bigint-errors.js', 'bigint-toprimitive.js', 'bigint-wrapped-values.js', 'order-of-evaluation.js']

for name in files:
    path = 'test/language/expressions/division/' + name
    data = (root / path).read_bytes()
    assert hashlib.sha256(data).hexdigest() == index[path]
    text = data.decode()
    print(name, 'CHECK', len(re.findall(r'//CHECK#\d+', text)), 'sameValue', text.count('assert.sameValue('), 'throws', text.count('assert.throws('))

source = (root / 'test/language/expressions/division/bigint-arithmetic.js').read_text()
pattern = r"assert\.sameValue\(\s*(-?0x[0-9A-F]+)n / (-?0x[0-9A-F]+)n,\s*(-?0x[0-9A-F]+)n,\s*'[^']*'\s*\);"
rows = re.findall(pattern, source)
assert len(rows) == source.count('assert.sameValue(')
remainder = re.sub(pattern, '', source)
remainder = re.sub(r'/\*.*?\*/|//[^\n]*', '', remainder, flags=re.S)
assert not remainder.strip()
pairs = set()
rounding_differences = 0

for left, right, expected in rows:
    a, b, value = int(left, 16), int(right, 16), int(expected, 16)
    assert b != 0
    magnitude = abs(a) // abs(b)
    quotient = -magnitude if (a < 0) != (b < 0) else magnitude
    assert quotient == value
    rounding_differences += (a // b != quotient)
    assert (a, b) not in pairs
    pairs.add((a, b))

lefts = {a for a, _ in pairs}
rights = {b for _, b in pairs}
assert len(lefts) == 16 and len(rights) == 16
assert pairs == {(a, b) for a in lefts for b in rights}
assert rights == lefts and 0 not in lefts
assert rounding_differences > 0
print('complete arithmetic count', len(rows), 'floor-versus-truncate differences', rounding_differences)
print('result range', min(int(r[2], 16) for r in rows), max(int(r[2], 16) for r in rows))

zero = (root / 'test/language/expressions/division/bigint-complex-infinity.js').read_text()
assert zero.count('assert.throws(RangeError') == 4
assert re.findall(r'^  (\d+)n / 0n;', zero, re.M) == ['1', '10', '0', '1000000000000000000']
print('4 divide-by-zero RangeError source assertions verified; not a ZX execution result')
