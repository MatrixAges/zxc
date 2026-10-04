from pathlib import Path
import hashlib
import json
import re

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
load = lambda path: [json.loads(line) for line in path.read_text().splitlines()]
reviews = load(repo / 'packages/test/upstream/reviews/language/expressions/addition_conversion.jsonl')
front = load(repo / 'packages/test/tests/language/types/addition_conversion/cases.jsonl')
assert len(reviews) == 8 and len(front) == 36
count = 0
nan_count = 0
for review in reviews:
    path = upstream / review['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest() == review['sha256']
    original = path.read_text()
    expressions = re.findall(r'if\s*\((.*?)\s*!==', original, re.S)
    assert len(expressions) == len(re.findall(r'//CHECK#', original))
    rows = [row for row in front if row['id'] in review['cases']]
    assert len(expressions) == len(rows)
    for expression, row in zip(expressions, rows):
        if expression.startswith('isNaN('):
            expression = expression[6:-1]
            nan_count += 1
        assert 'return ' + expression + ';' in row['source']
        count += 1

runtime = load(repo / 'packages/test/tests/language/expressions/addition/source/values.jsonl')[0]
assert runtime['input'] == {'left': 1, 'right': 1}
assert runtime['expected']['value'] == dict(literal=2, left=2, right=2, both=2, fields=2)
assert count == 36 and nan_count == 11
print('PASS: 8 hashes, 36 original expressions including 11 NaN checks, existing numeric result 2')
