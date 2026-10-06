import hashlib
import json
from pathlib import Path
import shutil
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
manifest_path = directory / '执行起点.json'
manifest = json.loads(manifest_path.read_text())
fixed = Path(manifest['cwd']).parents[1]
paths = ['packages/test/tests/rx/inference/parallel/check.zig', 'packages/test/tests/rx/inference/parallel/capture_ownership_test.zig', 'packages/test/tests/rx/inference/parallel/owned_input/root.zig']
patches = {}

for name in paths:
    original = subprocess.check_output(['git', 'show', manifest['production_commit'] + ':' + name], cwd=fixed)
    updated = (directory / '草稿' / name).read_bytes()
    assert updated != original
    assert (root / name).read_bytes() in [original, updated]
    assert (fixed / name).read_bytes() in [original, updated]
    patches[name] = {'original_sha256': hashlib.sha256(original).hexdigest(), 'sha256': hashlib.sha256(updated).hexdigest()}

for name in paths:
    updated = (directory / '草稿' / name).read_bytes()
    (root / name).write_bytes(updated)
    (fixed / name).write_bytes(updated)

manifest['test_patches'] = patches
failed = manifest['debug_neighbors']
assert failed['terminal_exit_code'] == 1
shutil.copyfile(failed['log'], directory / '首轮Debug相邻失败日志.txt')
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
print('Three test-only fixture corrections synchronized; production tree unchanged')
