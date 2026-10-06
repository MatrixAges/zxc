import hashlib
import json
from pathlib import Path


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
directory = Path(__file__).resolve().parent
relative = Path('packages/test/tests/built_ins/json/output/object.jsonl')
original = (root / relative).read_bytes()
rows = [json.loads(line) for line in original.decode().splitlines()]
assert len(rows) == 6
assert all('/large_prefix_' not in row['id'] for row in rows)
prefix = 'p' * 8192
additions = [
    {
        'id': 'built_ins/json/output/object/large_prefix_late_overflow',
        'json_text': '{"prefix":' + json.dumps(prefix) + ',"value":{"first":1,"rest":[2,-1e400]}}',
        'expected': {'error': 'NonFiniteJsonNumber'},
    },
    {
        'id': 'built_ins/json/output/object/large_prefix_finite_after_error',
        'json_text': json.dumps({'prefix': prefix, 'value': {'first': 1, 'rest': [2, 3]}}, separators=(',', ':')),
        'expected': {'value': {'prefix': prefix, 'value': {'first': 1, 'rest': [2, 3]}}},
    },
]
draft = directory / '草稿' / relative
draft.parent.mkdir(parents=True, exist_ok=True)
draft.write_bytes(original + ''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in additions).encode())
(directory / '草稿清单.json').write_text(json.dumps({
    'formal_path': str(relative),
    'original_rows': 6,
    'original_sha256': hashlib.sha256(original).hexdigest(),
    'new_rows': 2,
    'prefix_bytes': len(prefix.encode()),
    'draft_sha256': hashlib.sha256(draft.read_bytes()).hexdigest(),
    'new_ids': [row['id'] for row in additions],
}, ensure_ascii=False, indent=2) + '\n')
print('2 large-prefix cases drafted; original six JSONL rows remain byte-identical')
