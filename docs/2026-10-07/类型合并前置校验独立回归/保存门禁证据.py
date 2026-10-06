import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys


directory = Path(__file__).resolve().parent
label, mode, log_name, exit_code, *gates = sys.argv[1:]
assert exit_code == '0' and mode in ['Debug', 'ReleaseSafe']
manifest = json.loads((directory / '复验起点.json').read_text())
fixed = Path(manifest['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']

for name, expected in manifest['drafts'].items():
    assert hashlib.sha256((fixed / name).read_bytes()).hexdigest() == expected

log = Path(log_name)
text = log.read_text()
summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
assert summary and summary[1] == summary[2] and summary[3] == summary[4]
actual = [int(row[1]) for row in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', text)]
cached = [line for line in text.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)]
assert sum(actual) == int(summary[3])

for gate in gates:
    assert gate + ' success' in text

if gates == ['test-type-merge']:
    assert [count for count in actual if count in [20, 8, 10]] == [20, 8, 10]

shutil.copyfile(log, directory / (label + '原始日志.txt'))
value = {
    'source_commit': manifest['source_commit'],
    'terminal_exit_code': 0,
    'argv': ['zig', 'build', *gates, '-Doptimize=' + mode, '-j2', '--summary', 'all'],
    'summary': summary[0].removeprefix('Build Summary: '),
    'actual_test_passes': sum(actual),
    'actual_test_steps': len(actual),
    'cached_test_step_count': len(cached),
    'cached_declaration_count': None,
    'new_declaration_counts': {'prefix': 20, 'origins': 8, 'resources': 10} if gates == ['test-type-merge'] else {},
    'new_unique_declarations': 38 if gates == ['test-type-merge'] else 0,
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    'test_inputs': manifest['drafts'],
}
(directory / (label + '执行结果.json')).write_text(json.dumps(value, ensure_ascii=False, indent=4) + '\n')
print(value['summary'])
