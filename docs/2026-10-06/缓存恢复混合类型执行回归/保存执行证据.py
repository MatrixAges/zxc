import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys


directory = Path(__file__).resolve().parent
mode, label, log_name, exit_code = sys.argv[1:]
assert mode in ['Debug', 'ReleaseSafe'] and exit_code == '0'
manifest = json.loads((directory / '复验起点.json').read_text())
fixed = Path(manifest['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']

for name, expected in manifest['drafts'].items():
    assert hashlib.sha256((fixed / name).read_bytes()).hexdigest() == expected

log = Path(log_name)
text = log.read_text()
summary = re.search(r'Build Summary: (.+)', text)[1]
runs = {row[1]: int(row[2]) for row in re.finditer(r'run test (native-(?:basic|mixed)-(?:original|linked|cached)) (\d+) pass', text)}
assert runs == {f'native-{fixture}-{route}': count for fixture, count in [('basic', 4), ('mixed', 7)] for route in ['original', 'linked', 'cached']}
assert summary.endswith('33/33 tests passed')
saved = directory / label
saved.mkdir(exist_ok=True)
shutil.copyfile(log, saved / '原始日志.txt')
outputs = {}

for original in sorted((fixed / 'packages/test/.zig-cache/o').glob('*/original.zig')):
    if not log.stat().st_birthtime <= original.stat().st_mtime <= log.stat().st_mtime:
        continue

    fixture = 'mixed' if 'pub const Input = *const ' in original.read_text() else 'basic'
    assert fixture not in outputs
    rows = {}

    for name in ['original.zig', 'original_abi.zig', 'linked.zig', 'linked_abi.zig', 'cached.zig', 'cached_abi.zig']:
        source = original.parent / name
        target = saved / (fixture + '-' + name + '.txt')
        shutil.copyfile(source, target)
        rows[name] = {'original_path': str(source), 'raw_file': target.name, 'sha256': hashlib.sha256(source.read_bytes()).hexdigest()}

    outputs[fixture] = rows

assert set(outputs) == {'mixed', 'basic'}
value = {
    'source_commit': manifest['source_commit'],
    'input_manifest': '复验起点.json',
    'terminal_exit_code': 0,
    'argv': ['zig', 'build', 'test-native-runtime', '-Doptimize=' + mode, '-j2', '--summary', 'all'],
    'summary': summary,
    'runs': runs,
    'unique_new_declarations': 7,
    'existing_declarations': 4,
    'new_declaration_route_positions': 21,
    'catalog_ids_added': 0,
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    'outputs': outputs,
}
(saved / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=4) + '\n')
print(summary)
