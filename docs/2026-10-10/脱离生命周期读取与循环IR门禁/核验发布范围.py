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
phase = sys.argv[1]
subprocess.run([sys.executable, str(doc / '核验阶段证据.py')], check=True)


def digest(path):
    result = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)

    return result.hexdigest()


for name, identity in baseline['protected'].items():
    assert digest(root / name) == identity, name

if phase == 'staged':
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip() == baseline['parent']
    actual = subprocess.check_output(['git', 'diff', '--cached', '--name-only', '-z'], cwd=root)
    revision = ':'

    for name, identity in baseline['formal_originals'].items():
        original = subprocess.check_output(['git', 'show', 'HEAD:' + name], cwd=root)
        assert hashlib.sha256(original).hexdigest() == identity, name
elif phase == 'committed':
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD^'], cwd=root, text=True).strip() == baseline['parent']
    message = subprocess.check_output(['git', 'log', '-1', '--format=%B'], cwd=root, text=True).strip()
    assert message == baseline['expected_message'].strip()
    assert message.isascii() and all(len(line) <= 72 for line in message.splitlines())
    assert re.fullmatch(r'(fix|test)\([a-z_]+\): [a-z][^\n]+', message.splitlines()[0])
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=root)
    actual = subprocess.check_output(['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD', '-z'], cwd=root)
    revision = 'HEAD:'
else:
    raise ValueError(phase)

assert set(actual.decode().strip('\0').split('\0')) == expected

for name in expected:
    saved = subprocess.check_output(['git', 'show', revision + name], cwd=root)
    assert saved == (root / name).read_bytes(), name

print('PASS: exact publication scope, protected inputs and English Conventional Commit')
