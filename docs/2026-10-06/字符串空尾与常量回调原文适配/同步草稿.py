import hashlib
import json
from pathlib import Path
import subprocess
import sys


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
target_root = Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else root
paths = ['packages/test/src/generate_addition_strings.ts', 'packages/test/src/generate_collections.ts']
paths += ['packages/test/tests/' + name for name in [
    'language/expressions/addition/explicit_strings.jsonl',
    'built_ins/list/map_true/i64.jsonl',
    'built_ins/list/filter_true/i64.jsonl',
]]
paths += [str(path.relative_to(draft)) for path in (draft / 'packages/test/upstream/reviews').rglob('*.jsonl')]
assert len(paths) == 8
sources = {}

for name in paths:
    source = draft / name
    target = target_root / name
    original = subprocess.run(['git', 'show', 'b7f882cc:' + name], cwd=root, capture_output=True)
    if target.exists():
        assert target.read_bytes() == source.read_bytes() or original.returncode == 0 and target.read_bytes() == original.stdout, name
    else:
        assert original.returncode != 0, name

    sources[name] = hashlib.sha256(source.read_bytes()).hexdigest()

for name in paths:
    target = target_root / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes((draft / name).read_bytes())

(directory / '同步来源.json').write_text(json.dumps({'baseline': 'b7f882cc', 'sources': sources}, ensure_ascii=False, indent=4) + '\n')
print('Synchronized eight scoped generator/catalog/review files to ' + str(target_root))
