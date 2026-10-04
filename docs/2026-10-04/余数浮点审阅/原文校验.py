from pathlib import Path
import hashlib
import json
import math
import re
import struct

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
path = 'test/language/expressions/modulus/S11.5.3_A4_T7.js'
source = (upstream / path).read_text()
reviews = [json.loads(line) for line in (repo / 'packages/test/upstream/reviews/language/expressions/modulus.jsonl').read_text().splitlines()]
review = next(row for row in reviews if row['path'] == path)
assert review['sha256'] == hashlib.sha256((upstream / path).read_bytes()).hexdigest()
assert 'return Math.floor(x);' in source and 'return Math.ceil(x);' in source

rows = {row['id']: row for row in (json.loads(line) for line in (repo / 'packages/test/tests/language/expressions/modulus/f64.jsonl').read_text().splitlines())}
checks = re.findall(r'//CHECK#(\d+)\s+x = (-?1\.3);\s+y = (-?1\.1);\s+if \(x % y !== (.*?)\) \{', source)
assert len(checks) == 8
assert [int(check[0]) for check in checks] == list(range(1, 9))
seen = set()

for number, left_text, right_text, expression in checks:
    left, right = float(left_text), float(right_text)
    if int(number) <= 4:
        expected = float(expression)
    else:
        assert expression == 'x - truncate(x / y) * y'
        quotient = left / right
        truncated = math.floor(quotient) if quotient > 0 else math.ceil(quotient)
        expected = left - truncated * right

    left_name = 'negative' if left < 0 else 'positive'
    right_name = 'negative' if right < 0 else 'positive'
    case_id = 'language/expressions/modulus/f64/' + left_name + '_one_point_three/' + right_name + '_one_point_one'
    row = rows[case_id]
    assert case_id in review['cases']
    assert row['left'] == struct.pack('>d', left).hex()
    assert row['right'] == struct.pack('>d', right).hex()
    assert row['expected'] == struct.pack('>d', expected).hex()
    seen.add(case_id)

assert seen == set(review['cases']) and len(seen) == 4
print('PASS: source hash, all 8 original checks, 4 exact input/output bit-pattern cases')
