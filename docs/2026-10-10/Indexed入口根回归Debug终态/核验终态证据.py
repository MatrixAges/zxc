# coding: utf-8
import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess


document = Path(__file__).resolve().parent
records = json.loads((document / '归档清单.json').read_text())
assert len(records) == 6


def digest(path):
    value = hashlib.sha256()

    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            value.update(block)

    return value.hexdigest()


def read(name):
    return gzip.decompress((document / '原始终态' / (name + '.gz')).read_bytes())


for record in records:
    encoded = (document / record['saved']).read_bytes()
    raw = gzip.decompress(encoded)
    assert len(encoded) == record['saved_bytes'] and len(raw) == record['raw_bytes']
    assert hashlib.sha256(encoded).hexdigest() == record['saved_sha256']
    assert hashlib.sha256(raw).hexdigest() == record['raw_sha256']
    assert digest(record['source']) == record['raw_sha256']

manifest = json.loads(read('起点.json'))
start = json.loads(read('debug.start.json'))
terminal = json.loads(read('debug.terminal.json'))
result = json.loads((document / '终态结果.json').read_text())
assert manifest['source_commit'] == result['source_commit'] == 'bbd92b5c536139a6a36ce3ad4e0062768bf1337f'
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=manifest['cwd'], text=True).strip() == manifest['source_commit']
assert terminal['terminal_exit_code'] == 1 and terminal['pid'] == start['pid'] == 64064
assert terminal['runner_sha256'] == hashlib.sha256(read('运行根门禁.py')).hexdigest()
assert terminal['log_sha256'] == hashlib.sha256(read('debug.log.txt')).hexdigest()
assert not any(terminal[key] for key in ('changed_sources', 'changed_tools', 'changed_dependencies'))
assert result['release_safe_started_at_collection'] is False
assert result['direct_failed_steps'] == len(result['failed_steps']) == 40
assert sum(result['failed_step_groups'].values()) == 40
lines = read('debug.log.txt').decode().splitlines()
assert result['log_lines'] == len(lines) == 100082
assert result['log_bytes'] == len(read('debug.log.txt')) == 16376905
summary_index = next(index for index, line in enumerate(lines) if line.startswith('Build Summary:'))
assert result['summary'] == lines[summary_index] == terminal['build_summaries'][0]
failed_rows = []

for index, line in enumerate(lines[summary_index + 1:], summary_index + 2):
    if ((re.search(r'\bfailure\b', line) and 'transitive failure' not in line)
            or re.search(r'run test.*\d+ fail', line)
            or re.search(r'compile test.*\d+ errors?', line)):
        failed_rows.append({'line': index, 'text': line})

assert failed_rows == result['failed_steps']
failed_tests = [item for item in failed_rows if re.search(r'run test.*\d+ fail', item['text'])]
assert [int(re.search(r'(\d+) fail', item['text'])[1]) for item in failed_tests] == [6, 1, 3]
assert result['failed_zig_tests'] == 10
names = [match[1] for line in lines[:summary_index]
         if (match := re.match(r'^\d+/\d+ (.*?)\.\.\.OK$', line))]
assert result['plain_ok_occurrences'] == len(names) == 47387
assert result['distinct_plain_ok_names'] == len(set(names)) == 11499
old_document = document.parent / 'Indexed入口完整根回归'
old_records = json.loads((old_document / '归档清单.json').read_text())
prefix = next(item for item in old_records if item['saved'].startswith('根回归阶段证据/Debug日志快照'))
saved = (old_document / prefix['saved']).read_bytes()
raw_prefix = gzip.decompress(saved) if prefix['encoding'] == 'gzip' else saved
assert read('debug.log.txt').startswith(raw_prefix)
assert hashlib.sha256(raw_prefix).hexdigest() == prefix['raw_sha256']
assert len(manifest['sources']) == 6645 and len(manifest['node_dependencies']) == 451
assert len(manifest['zig_library']) == 19501

for name, expected in manifest['sources'].items():
    assert digest(Path(manifest['cwd']) / name) == expected, name

for tool in manifest['tools'].values():
    assert digest(tool['path']) == tool['sha256'], tool['path']

for group in ('node_dependencies', 'zig_library'):
    for path, expected in manifest[group].items():
        assert digest(path) == expected, path

print('PASS: immutable root Debug exit 1, 40 failed steps, 10 failed tests and six lossless archives')
