import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys


doc = Path(__file__).resolve().parent
root = doc.parents[2]
baseline = json.loads(gzip.decompress((doc / '发布基线.json.gz').read_bytes()))
expected = set(json.loads((doc / '提交文件清单.json').read_text()))
result = json.loads((doc / '执行结果.json').read_text())
assert result['semantics_cases'] == {'baseline': 42, 'simd128': 42}
assert result['assembly_exit_codes'] == {'baseline': 0, 'simd128': 1}
assert result['simd128_target_feature_present']
assert result['program_vector_constructors'] == 0
assert result['whole_assembly_f32x4_instructions'] == 0


def digest(data):
    return hashlib.sha256(data).hexdigest()


for item in json.loads((doc / '归档清单.json').read_text()):
    saved = (doc / item['saved']).read_bytes()
    raw = gzip.decompress(saved) if item['encoding'] == 'gzip' else saved
    assert digest(saved) == item['saved_sha256']
    assert digest(raw) == item['raw_sha256']
    assert len(saved) == item['saved_bytes'] and len(raw) == item['raw_bytes']

for name, identity in baseline['protected'].items():
    assert digest((root / name).read_bytes()) == identity, name

phase = sys.argv[1]

if phase == 'staged':
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip() == baseline['parent']
    actual = subprocess.check_output(['git', 'diff', '--cached', '--name-only', '-z'], cwd=root)
    revision = ':'
elif phase == 'committed':
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD^'], cwd=root, text=True).strip() == baseline['parent']
    message = subprocess.check_output(['git', 'log', '-1', '--format=%B'], cwd=root, text=True).strip()
    assert message == baseline['expected_message'].strip()
    assert message.isascii() and all(len(line) <= 72 for line in message.splitlines())
    assert re.fullmatch(r'test\(simd\): [a-z][^\n]+', message.splitlines()[0])
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=root)
    actual = subprocess.check_output(['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD', '-z'], cwd=root)
    revision = 'HEAD:'
else:
    raise ValueError(phase)

assert set(actual.decode().strip('\0').split('\0')) == expected

for name in expected:
    assert subprocess.check_output(['git', 'show', revision + name], cwd=root) == (root / name).read_bytes(), name

print('PASS: lossless evidence, protected inputs, exact scope and English Conventional Commit')
