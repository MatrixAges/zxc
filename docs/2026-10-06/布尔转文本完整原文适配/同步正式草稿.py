import json
from pathlib import Path


directory = Path(__file__).resolve().parent
root = directory.parents[2]
paths = ['packages/test/tests/language/expressions/template_primitives/bool.zx', 'packages/test/tests/language/expressions/template_primitives/bool.jsonl', 'packages/test/upstream/reviews/language/expressions/concatenation_boolean.jsonl']
registry_path = Path('packages/test/suites.json')
registry = json.loads((directory / '草稿' / registry_path).read_text())
original = json.loads(json.dumps(registry))
original['runtime'] = [row for row in original['runtime'] if row['path'] != 'language/expressions/template_primitives/bool']
assert json.loads((root / registry_path).read_text()) in [original, registry]

for name in paths:
    target = root / name
    source = directory / '草稿' / name
    assert not target.exists() or target.read_bytes() == source.read_bytes()

for name in [*paths, str(registry_path)]:
    (root / name).write_bytes((directory / '草稿' / name).read_bytes())

print('Two cases, one complete adapted original and one existing-runner registration synchronized')
