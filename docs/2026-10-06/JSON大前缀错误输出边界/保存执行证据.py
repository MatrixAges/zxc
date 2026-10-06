import hashlib
import json
from pathlib import Path
import shutil
import sys


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
mode, label, log_name, exit_code = sys.argv[1:]
log = Path(log_name)
assert exit_code == '0' and 'Build Summary: 40/40 steps succeeded' in log.read_text()
manifest = json.loads((directory / '草稿清单.json').read_text())
catalog = json.loads((fixed / 'packages/test/suites.json').read_text())
suites = [suite for suite in catalog['runtime'] if suite['name'].startswith('application-json-output-')]
assert len(suites) == 8
saved = directory / label
saved.mkdir(exist_ok=True)
cases = {}
reports = []
new_observations = []

for suite in suites:
    suite_cases = [json.loads(line) for line in (fixed / 'packages/test/tests' / (suite['path'] + '.jsonl')).read_text().splitlines()]

    for case in suite_cases:
        assert case['id'] not in cases
        cases[case['id']] = case

    paths = list((fixed / 'packages/test/.zig-cache/o').glob('*/' + suite['name'] + '-' + mode + '.json'))
    paths = [path for path in paths if path.stat().st_mtime >= log.stat().st_birthtime]
    assert len(paths) == 1, paths
    path = paths[0]
    report = json.loads(path.read_text())
    rows = report['observations']
    assert report['optimize'] == mode
    assert len(rows) == len(suite_cases) * 3
    assert all(row['executed'] and row['passed'] for row in rows)
    assert {(row['id'], row['target']) for row in rows} == {(case['id'], target) for case in suite_cases for target in ['native', 'wasm32-freestanding', 'wasm32-wasi']}
    assert all(command['error'] is None and command['signal'] is None for command in report['commands'])
    assert all(command['status'] == 0 for command in report['commands'] if command['command'].endswith('/zxc'))

    for row in rows:
        assert bytes.fromhex(row['input_utf8_hex']).decode() == cases[row['id']]['json_text']

        if row['id'] in manifest['new_ids']:
            if 'error' in cases[row['id']]['expected']:
                if row['target'] == 'wasm32-freestanding':
                    assert row['response']['status'] == 1 and row['response']['output'] == 'NonFiniteJsonNumber'
                else:
                    assert row['response']['status'] != 0 and row['response']['output'] == ''
            else:
                assert row['response']['status'] == 0
                assert json.loads(row['response']['output']) == cases[row['id']]['expected']['value']

            new_observations.append(row)

    name = suite['name'] + '.txt'
    shutil.copyfile(path, saved / name)
    reports.append({'name': suite['name'], 'cases': len(suite_cases), 'actual_observations': len(rows), 'raw_report': name, 'raw_report_sha256': hashlib.sha256(path.read_bytes()).hexdigest()})

paths = list((fixed / 'packages/test/.zig-cache/o').glob('*/application-json-gateway-' + mode + '.json'))
paths = [path for path in paths if path.stat().st_mtime >= log.stat().st_birthtime]
assert len(paths) == 1, paths
path = paths[0]
gateway = json.loads(path.read_text())
rows = gateway['observations']
assert len(cases) == len(rows) == 52
assert {row['id'] for row in rows} == set(cases)
assert all(row['passed'] and row['target'] == 'gateway-http' for row in rows)
assert gateway['stdout'] == ''
assert gateway['stderr'].count('Gateway service failed: NonFiniteJsonNumber') == 17
assert sum(row['status'] == 200 for row in rows) == 35
assert sum(row['status'] == 500 for row in rows) == 17

for row in rows:
    assert bytes.fromhex(row['input_utf8_hex']).decode() == cases[row['id']]['json_text']
    assert bytes.fromhex(row['wire_hex']).split(b'\r\n\r\n', 1)[1].decode() == row['body']

    if row['id'] in manifest['new_ids']:
        if 'error' in cases[row['id']]['expected']:
            assert row['status'] == 500 and row['body'] == 'service failed'
            assert row['headers'].get('content-type') != 'application/json'
        else:
            assert row['status'] == 200 and row['headers']['content-type'] == 'application/json'
            assert json.loads(row['body']) == cases[row['id']]['expected']['value']

        new_observations.append(row)

assert len(new_observations) == 8
assert all(len(json.loads(cases[case_id]['json_text'])['prefix'].encode()) == 8192 for case_id in manifest['new_ids'])
shutil.copyfile(path, saved / 'HTTP原始报告.txt')
shutil.copyfile(log, saved / '原始日志.txt')
value = {
    'mode': mode,
    'terminal_exit_code': 0,
    'build_summary': '40/40 steps succeeded',
    'shared_cases': 52,
    'new_cases': 2,
    'actual_three_target_observations': 156,
    'actual_http_observations': 52,
    'actual_combined_observations': 208,
    'actual_new_observations': 8,
    'new_observations': new_observations,
    'application_reports': reports,
    'http_raw_report_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
    'http_executable_sha256': gateway['executable_sha256'],
    'compiler_sha256': hashlib.sha256(Path(gateway['compiler']).read_bytes()).hexdigest(),
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
}
(saved / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print(mode + ': 52 shared IDs, 208 actual observations including 8 observations of 2 new IDs')
