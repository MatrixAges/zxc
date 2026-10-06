import hashlib
import json
from pathlib import Path


directory = Path(__file__).resolve().parent
root = directory.parents[2]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
metadata = {row['path']: row for row in map(json.loads, (root / 'packages/test/upstream/metadata/built-ins.jsonl').read_text().splitlines())}
paths = sorted(path for path in metadata if path.startswith('test/built-ins/Array/prototype/concat/'))
assert len(paths) == 69
reviewed = {row['path']: row for file in (root / 'packages/test/upstream/reviews').rglob('*.jsonl') for row in map(json.loads, file.read_text().splitlines())}
assert len(set(paths) & set(reviewed)) == 1
assert reviewed['test/built-ins/Array/prototype/concat/S15.4.4.4_A1_T1.js']['status'] == 'excluded'
entries = []
full = []
for path in paths:
    entry = metadata[path]
    data = (upstream / path).read_bytes()
    assert hashlib.sha256(data).hexdigest() == entry['sha256']
    target = directory / '原文' / (Path(path).stem + '.txt')
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)
    entries.append(entry)
    full.extend([f'===== {path} =====', f'SHA256 {entry["sha256"]}', data.decode(), ''])

(directory / '原文metadata.json').write_text(json.dumps(entries, ensure_ascii=False, indent=4) + '\n')
(directory / '完整原文.txt').write_text('\n'.join(full))
print('Saved all 69 originals; exactly 68 are currently unreviewed')
