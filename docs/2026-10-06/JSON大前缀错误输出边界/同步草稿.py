import hashlib
import json
from pathlib import Path
import shutil


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
directory = Path(__file__).resolve().parent
manifest = json.loads((directory / '草稿清单.json').read_text())
relative = Path(manifest['formal_path'])
original = (root / relative).read_bytes()
assert hashlib.sha256(original).hexdigest() == manifest['original_sha256']
assert (fixed / relative).read_bytes() == original
draft = (directory / '草稿' / relative).read_bytes()
assert hashlib.sha256(draft).hexdigest() == manifest['draft_sha256']
assert draft.startswith(original)

for checkout in [root, fixed]:
    shutil.copyfile(directory / '草稿' / relative, checkout / relative)

print('formal change is exactly two appended JSONL records')
