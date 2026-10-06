import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/native-reference-conformance/zxc')
mode, label, log_name, exit_code = sys.argv[1:]
log = Path(log_name)
text = log.read_text()
summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
assert exit_code == '0' and summary
assert summary[1] == summary[2] and summary[3] == summary[4]
tree = text[summary.start():]
actual = [int(match[1]) for match in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', tree)]
assert sum(actual) == int(summary[3])
cached_tests = [line for line in tree.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)]
cached_node = [line for line in tree.splitlines() if re.search(r'\brun node\b.*?\bcached(?:\s|$)', line)]
assert len([line for line in tree.splitlines() if '(results.jsonl)' in line and (' success ' in line or ' cached' in line)]) == 6
manifest = json.loads((directory / '复跑起点.json').read_text())
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']
assert not subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
cutoff = log.stat().st_birthtime
phases = {'current': {'log': str(log), 'terminal_exit_code': 0}}
if mode == 'safe' and str(log) == manifest['safe_test_gate']['log']:
    interrupted = manifest['interrupted_safe_test']
    cutoff = Path(interrupted['log']).stat().st_birthtime
    phases['interrupted'] = {'log': interrupted['log'], 'terminal_exit_code': None, 'classification': 'Interrupted whole gate; cached report observations are retained individually, never claimed as a completed gate.'}
saved = directory / label
saved.mkdir(exist_ok=True)
shutil.copyfile(log, saved / '原始日志.txt')
cache = fixed / '.zig-cache/o'
reports = {'application_json': [], 'native_runtime': [], 'native_targets': [], 'safety': []}


def save_report(path, group, value):
    name = group + '-' + str(len(reports[group])) + '.txt'
    shutil.copyfile(path, saved / name)
    phase = 'current' if path.stat().st_mtime >= log.stat().st_birthtime else 'interrupted'
    assert phase in phases
    reports[group].append({'original_path': str(path), 'raw_report': name, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(), 'generation_phase': phase, 'generated_at_unix': path.stat().st_mtime, **value})


for path in sorted(cache.glob('*/application-json-*-' + mode + '.json')):
    if path.stat().st_mtime < cutoff:
        continue

    assert path.stat().st_mtime >= cutoff
    report = json.loads(path.read_text())
    rows = report['observations']
    assert report['optimize'] == mode
    assert all(row['passed'] for row in rows if row['executed'])
    assert len({(row['id'], row['target']) for row in rows}) == len(rows)
    save_report(path, 'application_json', {'ids': len({row['id'] for row in rows}), 'positions': len(rows), 'executed': sum(row['executed'] for row in rows), 'excluded': sum(not row['executed'] for row in rows)})

for path in sorted(cache.rglob('execution.json')):
    if path.stat().st_mtime < cutoff:
        continue

    report = json.loads(path.read_text())
    if '/tests/native/references/runtime/' not in report.get('source', '') or report.get('optimize') != mode:
        continue

    assert path.stat().st_mtime >= cutoff
    assert report['status'] == 0 and report['signal'] is None and report['error'] is None
    count = len(re.findall(r'^test "', Path(report['source']).read_text(), re.MULTILINE))
    save_report(path, 'native_runtime', {'source': report['source'], 'native_identity': report['native_identity'], 'declarations': count, 'status': 0})

for path in sorted(cache.glob('*/application-targets.json')):
    if path.stat().st_mtime < cutoff:
        continue

    report = json.loads(path.read_text())
    if report.get('optimize') != mode:
        continue

    assert path.stat().st_mtime >= cutoff
    assert len(report['reports']) == 9 and all(row['passed'] for row in report['reports'])
    save_report(path, 'native_targets', {'ids': 9, 'passed': 9})

for path in sorted(cache.glob('*/results.jsonl')):
    if path.stat().st_mtime < cutoff:
        continue

    rows = [json.loads(line) for line in path.read_text().splitlines()]
    if not rows or not rows[0].get('id', '').startswith('runtime/safety/'):
        continue

    assert path.stat().st_mtime >= cutoff
    assert all(row['passed'] for row in rows)
    assert len({row['id'] for row in rows}) == len(rows)
    scalar = rows[0]['id'].split('/')[3]
    installed = fixed / 'zig-out/conformance' / mode / (scalar + '.jsonl')
    assert installed.read_bytes() == path.read_bytes()
    save_report(path, 'safety', {'ids': len(rows), 'passed': len(rows)})

assert len(reports['application_json']) == 4
assert sum(row['ids'] for row in reports['application_json']) == 372
assert sum(row['executed'] for row in reports['application_json']) == 1094
assert sum(row['excluded'] for row in reports['application_json']) == 22
assert len(reports['native_runtime']) == 28
assert len({row['source'] for row in reports['native_runtime']}) == 14
assert sum(row['declarations'] for row in reports['native_runtime']) == 90
assert len(reports['native_targets']) == 1
assert len(reports['safety']) == 6
assert sum(row['ids'] for row in reports['safety']) == 464
value = {
    'mode': mode,
    'source_commit': manifest['source_commit'],
    'report_phases': phases,
    'terminal_exit_code': 0,
    'build_summary': summary[0].removeprefix('Build Summary: '),
    'actual_build_test_leaves': len(actual),
    'actual_build_test_passes': sum(actual),
    'cached_build_test_step_count': len(cached_tests),
    'cached_build_test_declaration_count': None,
    'cached_node_step_count': len(cached_node),
    'cached_test_steps': cached_tests,
    'reports': reports,
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
    'counting_boundary': 'Build-managed test passes are summed only from numeric run test leaves; cached steps have no printed count and are separate. Native external Zig 90, native target 9, application JSON 1094 and safety 464 are separate driver observations, never added as unique catalog IDs.',
}
(saved / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({key: value[key] for key in ['mode', 'build_summary', 'actual_build_test_leaves', 'actual_build_test_passes', 'cached_build_test_step_count', 'cached_node_step_count']}, ensure_ascii=False))
