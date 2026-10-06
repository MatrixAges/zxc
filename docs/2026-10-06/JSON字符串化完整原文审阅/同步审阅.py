from pathlib import Path


directory = Path(__file__).resolve().parent
root = directory.parents[2]
path = Path('packages/test/upstream/reviews/built_ins/json/stringify.jsonl')
source = directory / '草稿' / path
target = root / path
assert not target.exists() or target.read_bytes() == source.read_bytes()
target.write_bytes(source.read_bytes())
print('Copied 66 reviewed decisions; existing unrelated paths untouched')
