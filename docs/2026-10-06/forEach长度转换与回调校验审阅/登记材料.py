import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
source = ROOT / 'packages/test/src/data/for_each.jsonl'
records = json.loads((DIRECTORY / '原文清单.json').read_text())
text = source.read_text()
existing = [json.loads(line) for line in text.splitlines()]
by_path = {row['path']: row for row in existing}
appended = []

for record in records:
    row = {key: record[key] for key in ['path', 'sha256', 'status', 'reason', 'contract', 'cases', 'assertions']}
    if row['path'] in by_path:
        assert by_path[row['path']] == row, row['path']
        continue
    appended.append(json.dumps(row, ensure_ascii=True, separators=(',', ':')) + '\n')
    by_path[row['path']] = row

if appended:
    assert not text or text.endswith('\n')
    source.write_text(text + ''.join(appended))

print(json.dumps({'added': len(appended), 'total': len(by_path)}))
