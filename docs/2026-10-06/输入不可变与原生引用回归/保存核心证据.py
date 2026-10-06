import hashlib
import json
from pathlib import Path
import re
import shutil
import sys


directory = Path(__file__).resolve().parent
manifest = json.loads((directory / '执行起点.json').read_text())
fixed = Path(manifest['cwd']).parents[1]
mode, label, key = sys.argv[1:]
gate = manifest[key]
assert gate['terminal_exit_code'] == 0
log = Path(gate['log'])
text = log.read_text()
summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
assert summary and summary[1] == summary[2] and summary[3] == summary[4]
tree = text[summary.start():]
counts = [int(value) for value in re.findall(r'\brun test\b[^\n]*? (\d+) pass \(\d+ total\)', tree)]
assert sum(counts) == int(summary[3])
cached = [line for line in tree.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)]
assert sum(int(value) for value in re.findall(r'All (\d+) tests passed\.', text)) == 90
assert len(re.findall(r'✔ native reference application boundary', text)) == 9
destination = directory / label
destination.mkdir(exist_ok=True)
shutil.copyfile(log, destination / '原始日志.txt')
cache = fixed / 'packages/test/.zig-cache/o'
reports = []

for path in sorted(cache.rglob('execution.json')):
    if path.stat().st_mtime < log.stat().st_birthtime:
        continue

    report = json.loads(path.read_text())
    if report.get('optimize') != mode or '/native/references/runtime/' not in report.get('source', ''):
        continue

    assert report['status'] == 0 and report['signal'] is None and report['error'] is None
    generated = {source.name: hashlib.sha256(source.read_bytes()).hexdigest() for source in path.parent.iterdir() if source.is_file() and source.suffix in ['.zig', '.json']}
    name = '原生运行-' + str(len(reports)) + '.txt'
    shutil.copyfile(path, destination / name)
    reports.append({'raw_report': name, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(), 'source': report['source'], 'native_identity': report['native_identity'], 'generated_sha256': generated})

assert len(reports) == 28
assert len({row['source'] for row in reports}) == 14
boundaries = []

for path in cache.glob('*/application-targets.json'):
    if path.stat().st_mtime < log.stat().st_birthtime:
        continue

    report = json.loads(path.read_text())
    if report.get('optimize') == mode:
        boundaries.append((path, report))

assert len(boundaries) == 1
path, report = boundaries[0]
assert len(report['reports']) == 9 and all(row['passed'] for row in report['reports'])
commands = [command for row in report['reports'] for command in row['commands']]
assert len(commands) == 246
assert all(row['signal'] is None and row['error'] is None for row in commands)
assert sum(row['status'] != 0 for row in commands) == 192
assert all(re.search(r'error: UnsupportedHostReference\b', row['stderr']) for row in commands if row['status'] != 0)
shutil.copyfile(path, destination / '应用边界原始报告.txt')
input_folders = [path.parent for path in cache.glob('*/mutating_abi.zig') if path.stat().st_mtime >= log.stat().st_birthtime and (path.parent / 'republished.zig').is_file()]
assert len(input_folders) == 1, input_folders
input_sources = {}
folder = input_folders[0]
(destination / '输入生成').mkdir(exist_ok=True)

for name in ['source', 'linked', 'library', 'republished', 'owned', 'mutating']:
    for suffix in ['.zig', '_abi.zig']:
        source = folder / (name + suffix)
        assert source.is_file()
        shutil.copyfile(source, destination / '输入生成' / (source.name + '.txt'))
        input_sources[source.name + '.txt'] = hashlib.sha256(source.read_bytes()).hexdigest()

owned_routes = {match[1]: int(match[2]) for match in re.finditer(r'\brun test owned-input-([a-z]+) (\d+) pass \(\d+ total\)', tree)}
assert owned_routes == {name: 10 for name in ['source', 'linked', 'library', 'republished', 'owned', 'mutating']}
value = {
    'mode': mode,
    'terminal_exit_code': 0,
    'build_summary': summary[0].removeprefix('Build Summary: '),
    'actual_managed_test_instances': sum(counts),
    'cached_managed_test_steps': len(cached),
    'cached_managed_test_declarations': None,
    'owned_input_independent_declarations': 47,
    'owned_input_runtime_routes': owned_routes,
    'native_independent_declarations': 147,
    'native_external_zig_instances': 90,
    'native_reports': reports,
    'application_boundary_report_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
    'application_boundary_command_records': 246,
    'application_boundary_rejections': 192,
    'input_generation_sha256': input_sources,
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    'counting_boundary': '194 independent core declarations are reused across modes and routes; Safe all-gate managed count also includes the five neighbor gates. Driver command records are not added as unique case IDs. Cached test declarations have no printed count and remain separate.',
}
(destination / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'mode': mode, 'summary': value['build_summary'], 'native_instances': 90, 'input_routes': owned_routes}, ensure_ascii=False))
