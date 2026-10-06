import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys


directory = Path(__file__).resolve().parent
draft = directory / '草稿'
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
mode, log_name, exit_code, *labels = sys.argv[1:]
assert mode in ['debug', 'safe'] and exit_code == '0'
baseline = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip()
assert baseline.startswith('6ec98c71')
log = Path(log_name)
text = log.read_text()
summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
assert summary and summary[1] == summary[2] and summary[3] == summary[4]
tail = text[summary.start():]
leaves = [line for line in tail.splitlines() if re.search(r'\brun test\b.*? \d+ pass \(\d+ total\)', line)]
assert sum(int(re.search(r' (\d+) pass ', line)[1]) for line in leaves) == int(summary[3])
for fixture in ['native_scalar', 'borrowed_objects']:
    for route in ['source', 'library']:
        assert re.search(r'run test value-return-' + fixture + '-' + route + r' (3 pass \(3 total\)|cached)', tail)

saved = directory / (labels[0] if labels else ('Debug' if mode == 'debug' else 'ReleaseSafe'))
saved.mkdir(exist_ok=True)
shutil.copyfile(log, saved / '原始日志.txt')
sources = {}
for source in sorted(draft.rglob('*')):
    if not source.is_file():
        continue

    name = source.relative_to(draft)
    assert (fixed / name).read_bytes() == source.read_bytes(), str(name)
    sources[str(name)] = hashlib.sha256(source.read_bytes()).hexdigest()

status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {line[3:] for line in status.splitlines()} == set(sources), status
cache = fixed / 'packages/test/.zig-cache/o'
generated = {}
for fixture, signature in [('native_scalar', '@import("native_scalar")'), ('borrowed_objects', '.ordinal')]:
    candidates = [path for path in cache.glob('*/source.zig') if signature in path.read_text()]
    assert candidates
    source = max(candidates, key=lambda path: path.stat().st_mtime)
    for route in ['source', 'library']:
        for suffix in ['.zig', '_abi.zig']:
            original = source.parent / (route + suffix)
            name = fixture + '-' + route + suffix + '.txt'
            shutil.copyfile(original, saved / name)
            generated[name] = {'original': str(original), 'sha256': hashlib.sha256(original.read_bytes()).hexdigest()}

reports = []
if mode == 'safe':
    for path in sorted(cache.rglob('execution.json')):
        if path.stat().st_mtime < log.stat().st_birthtime:
            continue

        report = json.loads(path.read_text())
        if '/tests/native/references/runtime/' not in report.get('source', '') or report.get('optimize') != mode:
            continue

        assert report['status'] == 0 and report['signal'] is None and report['error'] is None
        name = '原生执行报告-' + str(len(reports)) + '.txt'
        shutil.copyfile(path, saved / name)
        reports.append({'raw_report': name, 'source': report['source'], 'declarations': len(re.findall(r'^test "', Path(report['source']).read_text(), re.MULTILINE)), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})

    assert len(reports) in [0, 28]
    if reports:
        assert sum(row['declarations'] for row in reports) == 90
    targets = []
    for path in sorted(cache.glob('*/application-targets.json')):
        if path.stat().st_mtime < log.stat().st_birthtime:
            continue

        report = json.loads(path.read_text())
        if report.get('optimize') != mode:
            continue

        assert len(report['reports']) == 9 and all(row['passed'] for row in report['reports'])
        shutil.copyfile(path, saved / '原生三目标执行报告.txt')
        targets.append({'original': str(path), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(), 'passed': 9})

    assert len(targets) in [0, 1]
else:
    targets = []

gates = ['test-module-generation', 'test-value-return']
if mode == 'safe':
    gates += ['test-iterate-buffer', 'test-typed-try-runtime', 'test-native-references']

value = {
    'production_commit': baseline,
    'cwd': str(fixed / 'packages/test'),
    'argv': ['zig', 'build', *gates, '-Doptimize=' + ('Debug' if mode == 'debug' else 'ReleaseSafe'), '--summary', 'all'],
    'terminal_exit_code': 0,
    'summary': summary[0],
    'actual_managed_test_passes': int(summary[3]),
    'actual_managed_test_leaves': leaves,
    'cached_test_steps': [line for line in tail.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)],
    'new_unique_declarations': 8,
    'new_runtime_route_executions': sum(int(re.search(r' (\d+) pass ', line)[1]) for line in leaves if 'value-return-native_scalar-' in line or 'value-return-borrowed_objects-' in line),
    'catalog_ids_added': 0,
    'test_sources': sources,
    'generated_zig': generated,
    'native_runtime_reports': reports,
    'native_target_reports': targets,
    'raw_log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    'counting_boundary': 'Six new runtime declarations execute through two routes. Two new generation declarations belong to the existing module-generation suite. Build-managed numeric leaves, cached steps, native external tests and target-driver observations remain separate; none create JSONL IDs.',
}
(saved / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=4) + '\n')
print(json.dumps({key: value[key] for key in ['summary', 'actual_managed_test_passes', 'new_runtime_route_executions']}, ensure_ascii=False))
