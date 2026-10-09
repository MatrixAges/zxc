import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys


doc = Path(__file__).resolve().parent
root = doc.parents[2]
decoded = {}
baseline = json.loads(gzip.decompress((doc / '发布基线.json.gz').read_bytes()))
expected = set(json.loads((doc / '提交文件清单.json').read_text()))


def digest(data):
    return hashlib.sha256(data).hexdigest()


for row in json.loads((doc / '归档清单.json').read_text()):
    saved = (doc / row['saved']).read_bytes()
    raw = gzip.decompress(saved)
    assert digest(saved) == row['saved_sha256'] and digest(raw) == row['raw_sha256']
    assert len(saved) == row['saved_bytes'] and len(raw) == row['raw_bytes']
    assert Path(row['source']).read_bytes() == raw
    decoded[row['saved'].removesuffix('.gz')] = raw

identity = json.loads((doc / '原文身份与边界.json').read_text())
paths = {row['path']: row['sha256'] for row in identity}
assert len(paths) == 8 and sum(row['original_assertions'] for row in identity) == 12
reviews = [json.loads(line) for line in (root / baseline['formal_path']).read_text().splitlines()]
assert len(reviews) == 8 and {row['path']: row['sha256'] for row in reviews} == paths
assert all(row['status'] == 'excluded' and row['cases'] == [] for row in reviews)

result = json.loads(decoded['执行证据/stdout.json'])
terminal = json.loads(decoded['执行证据/terminal.json'])
assert terminal['exit_code'] == 0
assert digest(decoded['执行证据/stdout.json']) == terminal['stdout_sha256']
assert digest(decoded['执行证据/run-originals.mjs']) == terminal['runner_sha256']
assert digest(Path('/usr/local/bin/node').read_bytes()) == terminal['node_sha256']
assert len(result['executions']) == 16 and result['original_assertions_per_mode'] == 12
assert {(row['path'], row['mode']) for row in result['executions']} == {
    (path, mode) for path in paths for mode in ('sloppy', 'strict')
}
assert all(row['result'] == 'passed' and row['sha256'] == paths[row['path']] for row in result['executions'])

audit = json.loads(decoded['执行证据/catalog-audit.stdout.json'])
audit_terminal = json.loads(decoded['执行证据/catalog-audit.terminal.json'])
assert audit_terminal['exit_code'] == 0
assert digest(decoded['执行证据/catalog-audit.stdout.json']) == audit_terminal['stdout_sha256']
assert digest((root / baseline['formal_path']).read_bytes()) == audit_terminal['review_sha256']
assert audit['reviewed'] == {'adapted': 852, 'excluded': 2089, 'equivalent': 103}
assert audit['catalog_cases'] == 140773 and audit['unreviewed'] == 50553

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
    assert re.fullmatch(r'test\(test262\): [a-z][^\n]+', message.splitlines()[0])
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=root)
    actual = subprocess.check_output(['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD', '-z'], cwd=root)
    revision = 'HEAD:'
else:
    raise ValueError(phase)

assert set(actual.decode().strip('\0').split('\0')) == expected

for name in expected:
    assert subprocess.check_output(['git', 'show', revision + name], cwd=root) == (root / name).read_bytes(), name

print('PASS: 16 original executions, eight exclusions, zero new zxc cases and exact English publication')
