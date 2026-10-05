import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
source = ROOT / 'packages/test/src/data/for_each.jsonl'
records = json.loads((DIRECTORY / '原文清单.json').read_text())
existing = [json.loads(line) for line in source.read_text().splitlines()]
by_path = {row['path']: row for row in existing}
added = 0

for record in records:
    row = {key: record[key] for key in ['path', 'sha256', 'status', 'reason', 'contract', 'cases', 'assertions']}
    if row['path'] in by_path:
        assert by_path[row['path']] == row, row['path']
        continue
    existing.append(row)
    by_path[row['path']] = row
    added += 1

source.write_text(''.join(json.dumps(row, ensure_ascii=True, separators=(',', ':')) + '\n' for row in existing))
print(json.dumps({'added': added, 'total': len(existing)}))
