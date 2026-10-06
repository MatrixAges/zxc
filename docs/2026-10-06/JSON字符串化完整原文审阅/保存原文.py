import hashlib
import json
from pathlib import Path


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
directory = Path(__file__).resolve().parent
entries = [json.loads(line) for line in (root / 'packages/test/upstream/metadata/built-ins.jsonl').read_text().splitlines()]
entries = [row for row in entries if row['path'].startswith('test/built-ins/JSON/stringify/')]
indexed = {row['path']: row['sha256'] for row in [json.loads(line) for line in (root / 'packages/test/upstream/index/built-ins.jsonl').read_text().splitlines()]}
assert len(entries) == 66
originals = []

for row in entries:
    source = (upstream / row['path']).read_bytes()
    assert hashlib.sha256(source).hexdigest() == row['sha256'] == indexed[row['path']]
    assert row['metadata_status'] == 'parsed'
    assert not row.get('flags') and 'negative' not in row
    originals.append('FILE: ' + row['path'] + '\nSHA256: ' + row['sha256'] + '\n\n' + source.decode() + '\n')

(directory / '待审文件.jsonl').write_text(''.join(json.dumps(row, ensure_ascii=False) + '\n' for row in entries))
(directory / '完整原文.txt').write_text('\n'.join(originals))
print('66 original files; all metadata and index SHA256 matched')
