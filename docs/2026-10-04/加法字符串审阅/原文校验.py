from pathlib import Path
import hashlib
import json
import re

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
load = lambda path: [json.loads(line) for line in path.read_text().splitlines()]
reviews = load(repo / 'packages/test/upstream/reviews/language/expressions/addition_strings.jsonl')
front = load(repo / 'packages/test/tests/language/types/addition_strings/cases.jsonl')
assert len(reviews) == 6 and len(front) == 36
count = 0

for review in reviews:
    path = upstream / review['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest() == review['sha256']
    expressions = re.findall(r'if\s*\((.*?)\s*!==', path.read_text(), re.S)
    rows = [row for row in front if row['id'] in review['cases']]
    assert len(expressions) == len(rows)
    for expression, row in zip(expressions, rows):
        assert 'return ' + expression + ';' in row['source']
        count += 1

runtime = load(repo / 'packages/test/tests/language/expressions/addition/explicit_strings.jsonl')
expected = ['11', 'x1', '1x', '', 'tail', 'head', '中文', '🌱🍃', 'e\u0301']
assert len(runtime) == len(expected) == 9
for row, value in zip(runtime, expected):
    assert row['expected']['value'] == value
assert count == 36
print('PASS: 6 hashes, all 36 original expressions, 9 independent explicit-template expectations')
