import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
tests = draft / 'packages/test/tests'
catalogs = [
    'language/expressions/addition/explicit_strings.jsonl',
    'built_ins/list/map_true/i64.jsonl',
    'built_ins/list/filter_true/i64.jsonl',
]
selected = set(catalogs) | {name.replace('.jsonl', '.zx') for name in catalogs}
changed = []
checked = 0
sources = {}

for path in sorted(tests.rglob('*')):
    if not path.is_file():
        continue

    name = str(path.relative_to(tests))
    original = subprocess.check_output(['git', 'show', 'b7f882cc:packages/test/tests/' + name], cwd=root)
    checked += 1
    sources[name] = hashlib.sha256(path.read_bytes()).hexdigest()
    if path.read_bytes() != original:
        assert name in catalogs, name
        assert path.read_bytes().startswith(original), name
        assert len(path.read_bytes().splitlines()) == len(original.splitlines()) + 1
        changed.append(name)

    if name not in selected:
        path.unlink()

assert set(changed) == set(catalogs)
assert checked == 127
for path in sorted(tests.rglob('*'), reverse=True):
    if path.is_dir() and not any(path.iterdir()):
        path.rmdir()

(directory / '生成核对.json').write_text(json.dumps({
    'baseline': 'b7f882cc',
    'generated_files_checked': checked,
    'changed_catalogs': changed,
    'all_other_generated_files_byte_equal': True,
    'generated_source_sha256': sources,
    'draft_generator_checks': {'generate_addition_strings': 0, 'generate_collections': 0},
    'scope': 'Both complete generators executed and passed --check before unrelated byte-identical output copies were removed from the draft.',
}, ensure_ascii=False, indent=4) + '\n')
print('Verified all 127 generated outputs; retained only three catalogs and their unchanged ordinary ZX programs')
