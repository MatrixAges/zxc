import hashlib
import json
from pathlib import Path
import shutil
import sys
import re


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
mode, label, log_name, exit_code = sys.argv[1:]
log = Path(log_name)
assert exit_code == '0'
summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded', log.read_text())
assert summary and summary[1] == summary[2]

catalog = json.loads((fixed / 'packages/test/suites.json').read_text())
suites = [suite for suite in catalog['runtime'] if suite['kind'] == 'application_json']
assert len(suites) == 12
saved = directory / label
saved.mkdir(exist_ok=True)
reports = []

for suite in suites:
    paths = list((fixed / 'packages/test/.zig-cache/o').glob('*/' + suite['name'] + '-' + mode + '.json'))
    paths = [path for path in paths if path.stat().st_mtime >= log.stat().st_birthtime]
    assert len(paths) == 1, (suite['name'], paths)
    path = paths[0]
    report = json.loads(path.read_text())
    rows = [json.loads(line) for line in (fixed / 'packages/test/tests' / (suite['path'] + '.jsonl')).read_text().splitlines()]
    ids = {row['id'] for row in rows}
    observations = report['observations']

    assert report['optimize'] == mode
    assert len(ids) == len(rows)
    assert len(observations) == len(ids) * 3
    assert {(row['id'], row['target']) for row in observations} == {(case_id, target) for case_id in ids for target in ['native', 'wasm32-freestanding', 'wasm32-wasi']}
    assert all(row['passed'] for row in observations if row['executed'])
    assert all(row['reason'] == 'argv cannot transport NUL' for row in observations if not row['executed'])
    assert all(command['error'] is None and command['signal'] is None for command in report['commands'])
    assert all(command['status'] == 0 for command in report['commands'] if command['command'].endswith('/zxc'))

    name = suite['name'] + '.txt'
    shutil.copyfile(path, saved / name)
    reports.append({
        'name': suite['name'],
        'cases': len(ids),
        'positions': len(observations),
        'executed': sum(row['executed'] for row in observations),
        'passed': sum(row['executed'] and row['passed'] for row in observations),
        'excluded': sum(not row['executed'] for row in observations),
        'raw_report': name,
        'raw_report_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
        'compiler_sha256': hashlib.sha256(Path(report['commands'][0]['command']).read_bytes()).hexdigest(),
    })

value = {
    'mode': mode,
    'label': label,
    'terminal_exit_code': 0,
    'build_summary': summary[0].removeprefix('Build Summary: '),
    'reports': reports,
    'cases': sum(row['cases'] for row in reports),
    'target_positions': sum(row['positions'] for row in reports),
    'actual_target_observations': sum(row['executed'] for row in reports),
    'transport_exclusions': sum(row['excluded'] for row in reports),
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
}

assert value['cases'] == 422 and value['target_positions'] == 1266
assert value['actual_target_observations'] == 1244 and value['transport_exclusions'] == 22
shutil.copyfile(log, saved / '原始日志.txt')
(saved / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({key: value[key] for key in ['mode', 'cases', 'actual_target_observations', 'transport_exclusions']}, ensure_ascii=False))
