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


def digest(data):
    return hashlib.sha256(data).hexdigest()


for item in json.loads((doc / '归档清单.json').read_text()):
    saved = (doc / item['saved']).read_bytes()
    raw = gzip.decompress(saved) if item['encoding'] == 'gzip' else saved
    assert digest(saved) == item['saved_sha256']
    assert digest(raw) == item['raw_sha256']
    assert len(saved) == item['saved_bytes'] and len(raw) == item['raw_bytes']
    assert Path(item['source']).read_bytes() == raw

result = json.loads((doc / '证据/执行结果.json.txt').read_text())
assert digest(Path(result['cli']).read_bytes()) == result['cli_sha256']
assert result['source_commit'] == 'bbd92b5c536139a6a36ce3ad4e0062768bf1337f'
assert len(result['records']) == 8
assert {item['mode'] for item in result['records']} == {
    'map', 'filter', 'local', 'nested', 'tuple', 'shared', 'borrowed', 'repeated'
}

for item in result['records']:
    assert item['terminal_exit_code'] == 0
    source = gzip.decompress((doc / f"证据/{item['mode']}.zig.gz").read_bytes())
    assert digest(source) == item['generated_sha256']
    text = source.decode()
    start = text.index('pub fn execute(')
    end = text.index('\n}', start) + 2
    entry = text[start:end]
    lines = [line.strip() for line in entry.splitlines() if '.dupe(' in line]
    assert lines == item['ordinary_dupe_lines']
    assert len(lines) == (1 if item['mode'] == 'borrowed' else 2)
    assert sum('operand_' in line for line in lines) == 1
    assert '@constCast' not in entry

comparison = json.loads((doc / '静态比较.json').read_text())
assert comparison['runtime_executed'] is False
assert comparison['generated_programs'] == 8

for name in comparison['unchanged_paths']:
    assert not subprocess.check_output([
        'git', 'diff', comparison['executed_source'],
        comparison['comparison_commit'], '--', name
    ], cwd=root)

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
    assert re.fullmatch(r'test\(ownership\): [a-z][^\n]+', message.splitlines()[0])
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=root)
    actual = subprocess.check_output(['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD', '-z'], cwd=root)
    revision = 'HEAD:'
else:
    raise ValueError(phase)

assert set(actual.decode().strip('\0').split('\0')) == expected

for name in expected:
    assert subprocess.check_output(['git', 'show', revision + name], cwd=root) == (root / name).read_bytes(), name

print('PASS: eight generated entries, immutable evidence, exact scope and English Conventional Commit')
