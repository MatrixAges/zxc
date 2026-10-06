import hashlib
import json
from pathlib import Path


directory = Path(__file__).resolve().parent
root = directory.parents[2]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
metadata = {row['path']: row for row in map(json.loads, (root / 'packages/test/upstream/metadata/built-ins.jsonl').read_text().splitlines())}
concat = 'test/built-ins/String/prototype/concat/'
paths = sorted(path for path in metadata if path.startswith(concat))
paths += ['test/built-ins/Array/prototype/map/15.4.4.19-8-c-ii-9.js', 'test/built-ins/Array/prototype/filter/15.4.4.20-9-c-ii-9.js']
assert len(paths) == 24
reviewed = {row['path'] for path in (root / 'packages/test/upstream/reviews').rglob('*.jsonl') for row in map(json.loads, path.read_text().splitlines())}
assert not (set(paths) & reviewed)
entries = []
full = []

for path in paths:
    entry = metadata[path]
    source = (upstream / path).read_bytes()
    assert hashlib.sha256(source).hexdigest() == entry['sha256']
    target = directory / '原文' / Path(path).parent.name / (Path(path).stem + '.txt')
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(source)
    entries.append(entry)
    full.extend([f'===== {path} =====', f'SHA256 {entry["sha256"]}', source.decode(), ''])

(directory / '原文metadata.json').write_text(json.dumps(entries, ensure_ascii=False, indent=4) + '\n')
(directory / '完整原文.txt').write_text('\n'.join(full))
print('Saved 24 complete unreviewed originals with index-matching SHA256')
