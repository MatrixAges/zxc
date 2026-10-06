import hashlib
import json
from pathlib import Path


directory = Path(__file__).resolve().parent
root = directory.parents[2]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
metadata = {row['path']: row for row in map(json.loads, (root / 'packages/test/upstream/metadata/built-ins.jsonl').read_text().splitlines())}
selected = {
    'encodeURIComponent': ['A3.1_T1', 'A3.2_T1', 'A3.2_T2', 'A3.2_T3', 'A3.3_T1', 'A4_T1', 'A4_T2', 'A4_T3', 'A4_T4'],
    'decodeURIComponent': ['A3_T1', 'A3_T2', 'A3_T3', 'A4_T1', 'A4_T2', 'A4_T3', 'A4_T4'],
}
entries = []
full = []

for operation, suffixes in selected.items():
    prefix = 'S15.1.3.4_' if operation == 'encodeURIComponent' else 'S15.1.3.2_'
    for suffix in suffixes:
        path = f'test/built-ins/{operation}/{prefix}{suffix}.js'
        entry = metadata[path]
        source = (upstream / path).read_bytes()
        assert hashlib.sha256(source).hexdigest() == entry['sha256']
        assert not entry.get('flags') and not entry.get('includes') and 'negative' not in entry
        target = directory / '原文' / operation / Path(path).name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.with_suffix('.txt').write_bytes(source)
        entries.append(entry)
        full.extend([f'===== {path} =====', f'SHA256 {entry["sha256"]}', source.decode(), ''])

assert len(entries) == 16
(directory / '原文metadata.json').write_text(json.dumps(entries, ensure_ascii=False, indent=4) + '\n')
(directory / '完整原文.txt').write_text('\n'.join(full))
print('Saved 16 complete originals with verified index fingerprints')
