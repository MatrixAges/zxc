import hashlib
import json
from pathlib import Path
import sys


directory = Path(__file__).resolve().parent
root = directory.parents[2]
target_root = Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else root
draft = directory / '草稿'
base = json.loads((directory / '草稿起点.json').read_text())['原文件SHA256']
paths = [
    'packages/test/build.zig',
    'packages/test/src/querystring/percent_cases.ts',
    'packages/test/src/data/querystring_uri.jsonl',
    'packages/test/tests/standard/querystring/escape/cases.jsonl',
    'packages/test/tests/standard/querystring/unescape/cases.jsonl',
    'packages/test/upstream/reviews/built_ins/uri/escape.jsonl',
    'packages/test/upstream/reviews/built_ins/uri/unescape.jsonl',
]

for name, sha in base.items():
    if name in paths:
        continue
    assert hashlib.sha256((target_root / name).read_bytes()).hexdigest() == sha, name

for name in paths:
    target = target_root / name
    source = draft / name
    if target.exists():
        same = target.read_bytes() == source.read_bytes()
        assert same or name in base and hashlib.sha256(target.read_bytes()).hexdigest() == base[name], name
        if name.endswith('/cases.jsonl') and not same:
            assert source.read_bytes().startswith(target.read_bytes()), name

for name in paths:
    target = target_root / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes((draft / name).read_bytes())

print(f'Synchronized only seven reviewed test files to {target_root}')
