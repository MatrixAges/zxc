import hashlib
import json
from pathlib import Path


directory = Path(__file__).resolve().parent
root = directory.parents[2]
rows = json.loads((directory / '逐项审阅草稿.json').read_text())
metadata = {row['path']: row for row in json.loads((directory / '原文metadata.json').read_text())}
reviewed = {row['path']: row for file in (root / 'packages/test/upstream/reviews').rglob('*.jsonl') for row in map(json.loads, file.read_text().splitlines())}
expected = set(metadata) - {'test/built-ins/Array/prototype/concat/S15.4.4.4_A1_T1.js'}
assert len(rows) == len(expected) == 68
assert {row['path'] for row in rows} == expected
formal = []
for row in sorted(rows, key=lambda item: item['path']):
    assert row['sha256'] == metadata[row['path']]['sha256']
    assert row['status'] == 'excluded' and row['cases'] == []
    assert row['reason'] and row['observations'] and row['contract']
    data = (directory / '原文' / (Path(row['path']).stem + '.txt')).read_bytes()
    assert hashlib.sha256(data).hexdigest() == row['sha256']
    value = {key: row[key] for key in ['path', 'sha256', 'status', 'reason', 'contract', 'cases']}
    value['reason'] = '；'.join(row['observations']) + '；ZX 边界：' + row['reason']
    if row['path'] in reviewed:
        assert reviewed[row['path']] == value
    formal.append(value)

name = 'packages/test/upstream/reviews/built_ins/array/concat_dynamic_protocols.jsonl'
draft = directory / '草稿' / name
draft.parent.mkdir(parents=True, exist_ok=True)
draft.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in formal))
target = root / name
assert not target.exists() or target.read_bytes() == draft.read_bytes()
target.write_bytes(draft.read_bytes())
lines = ['# 数组拼接逐项原文观察', '', '以下 68 项为本轮新增 excluded，完整 SHA 在逐项审阅草稿.json 与正式 JSONL 中。已有 A1_T1 保留原 excluded，不重复登记。', '', '| 原文 | 完整核心观察 | 静态 ZX 边界 |', '| --- | --- | --- |']
for row in sorted(rows, key=lambda item: item['path']):
    path = Path(row['path'])
    def cell(value):
        return value.replace('|', '\\|').replace('\n', ' ')
    lines.append('| [' + path.name + '](原文/' + path.stem + '.txt) | ' + cell('；'.join(row['observations'])) + ' | ' + cell(row['reason']) + ' |')
(directory / '逐项观察.md').write_text('\n'.join(lines) + '\n')
print('Verified and registered exactly 68 excluded full-file reviews; zero executable case mappings')
