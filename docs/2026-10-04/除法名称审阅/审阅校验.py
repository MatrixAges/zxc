from pathlib import Path
import hashlib
import json
import sys

root = Path(sys.argv[1])
reviews = list(map(json.loads, Path('packages/test/upstream/reviews/language/expressions/division_names.jsonl').read_text().splitlines()))
assert len(reviews) == 6
for row in reviews:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256']

base = Path('packages/test/tests/language/expressions/division')
values = list(map(json.loads, (base / 'source/values.jsonl').read_text().splitlines()))
assert [row['input'] for row in values] == [-2, 1, 2, 3]
for row in values:
    value = row['input']
    assert row['expected']['value'] == {'literal': 1, 'left': value, 'right': 1 / value, 'both': 1, 'fields': 1}

front = list(map(json.loads, (base / 'names/cases.jsonl').read_text().splitlines()))
assert len(front) == 4
for row in front:
    if row['diagnostic'] is None:
        assert 'const missing = in;' in row['source']
    else:
        start, end = row['span']
        assert row['source'].encode()[start:end] == b'missing'
        assert row['diagnostic'] == 'name'

assert '18\n\n/\n\n2\n\n/\n\n9;' in (base / 'source/lines.zx').read_text()
assert 'return instance/of/g;' in (base / 'source/identifiers.zx').read_text()
assert json.loads((base / 'source/lines.jsonl').read_text())['expected']['value'] == 18 / 2 / 9
assert json.loads((base / 'source/identifiers.jsonl').read_text())['expected']['value'] == 60 / 6 / 2
print('6 hashes, 4 object expectations, 4 name cases and 2 lexical source shapes verified')
