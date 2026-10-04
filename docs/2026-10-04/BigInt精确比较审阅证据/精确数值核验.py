import ast
import hashlib
import json
import operator
import re
from collections import Counter
from fractions import Fraction
from pathlib import Path

folder = Path(__file__).resolve().parent
reference = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
evidence = json.loads((folder / '原文证据.json').read_text())
maximum = (2**53 - 1) * 2**971
minimum = Fraction(1, 2**1074)


def value(text):
    if text.endswith('n'):
        return int(text[:-1], 0)
    if text.startswith("'"):
        content = ast.literal_eval(text).strip()
        if not content:
            return 0
        if re.fullmatch(r'[+-]?[0-9]+', content):
            return int(content, 10)
        if re.fullmatch(r'0(?:x[0-9a-fA-F]+|o[0-7]+|b[01]+)', content):
            return int(content, 0)
        return None
    if text.lstrip('-') == 'Number.MAX_VALUE':
        return -maximum if text.startswith('-') else maximum
    if text.lstrip('-') == 'Number.MIN_VALUE':
        return -minimum if text.startswith('-') else minimum
    return Fraction.from_float(float(text))


counts = Counter()
unique = set()
near_maximum = set()
assertions = 0
pattern = re.compile(r"assert.sameValue\(\s*(.*?),\s*(true|false),\s*'(.*?)'\s*\);", re.S)

for item in evidence:
    raw = (reference / item['path']).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == item['sha256']
    body = raw.decode().split('---*/', 1)[1]
    original = pattern.findall(body)
    assert len(original) == len(item['values'])
    assert not re.sub(r'//[^\n]*', '', pattern.sub('', body)).strip()

    for (expression, expected, message), row in zip(original, item['values']):
        assert expression.strip() == row['expression'] and (expected == 'true') == row['expected']
        left, comparison, right = re.split(r' (<=|>=|<|>) ', row['expression'])
        x, y = value(left), value(right)
        compare = {'<': operator.lt, '>': operator.gt, '<=': operator.le, '>=': operator.ge}[comparison]
        actual = x is not None and y is not None and compare(x, y)
        assert actual == row['expected'], row
        assertions += 1
        unique.add(row['expression'])
        counts[Path(item['path']).name] += 1

        for operand in [left, right]:
            if operand.endswith('n'):
                integer = value(operand)
                if integer.bit_length() == 1024:
                    near_maximum.add(integer - maximum)

assert assertions == 438 and len(unique) == 430
assert near_maximum == {-1, 1}
assert counts == {'bigint-and-bigint.js': 132, 'bigint-and-string.js': 114, 'bigint-and-incomparable-string.js': 80, 'bigint-and-number.js': 80, 'bigint-and-number-extremes.js': 32}
print('PASS: 438 original assertions, 430 unique expressions, exact integers/Fraction results; 1024-bit extremes are Number.MAX_VALUE minus/plus one')
