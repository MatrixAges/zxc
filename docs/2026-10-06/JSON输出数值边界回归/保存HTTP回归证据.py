import hashlib
import json
from pathlib import Path
import shutil
import sys


directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
mode, label, log_name, exit_code = sys.argv[1:]
log = Path(log_name)
assert exit_code == '0'

catalog = json.loads((fixed / 'packages/test/suites.json').read_text())
suites = [suite for suite in catalog['runtime'] if suite['name'].startswith('application-json-output-')]
cases = {}

for suite in suites:
    for line in (fixed / 'packages/test/tests' / (suite['path'] + '.jsonl')).read_text().splitlines():
        row = json.loads(line)
        assert row['id'] not in cases
        cases[row['id']] = row

paths = list((fixed / 'packages/test/.zig-cache/o').glob('*/application-json-gateway-' + mode + '.json'))
paths = [path for path in paths if path.stat().st_mtime >= log.stat().st_birthtime]
assert len(paths) == 1, paths
path = paths[0]
report = json.loads(path.read_text())
rows = report['observations']
assert report['optimize'] == mode
assert len(cases) == len(rows) == 50
assert {row['id'] for row in rows} == set(cases)
assert all(row['passed'] and row['target'] == 'gateway-http' for row in rows)
assert report['stdout'] == ''
errors = 0

for row in rows:
    case = cases[row['id']]
    wire = bytes.fromhex(row['wire_hex'])
    headers, body = wire.split(b'\r\n\r\n', 1)
    assert body.decode() == row['body']
    assert bytes.fromhex(row['input_utf8_hex']).decode() == case['json_text']
    assert int(headers.split(b'\r\n', 1)[0].split()[1]) == row['status']

    if 'error' in case['expected']:
        assert row['status'] == 500 and row['body'] == 'service failed'
        assert row['headers'].get('content-type') != 'application/json'
        errors += 1
    else:
        assert row['status'] == 200 and row['headers']['content-type'] == 'application/json'

assert errors == 16
assert report['stderr'].count('Gateway service failed: NonFiniteJsonNumber') == errors
saved = directory / label
saved.mkdir(exist_ok=True)
shutil.copyfile(path, saved / 'HTTP原始报告.txt')
value = {
    'mode': mode,
    'terminal_exit_code': 0,
    'shared_cases': 50,
    'new_catalog_ids': 0,
    'actual_http_observations': 50,
    'http_200_finite_or_null': 34,
    'http_500_non_finite': 16,
    'non_finite_error_log_count': 16,
    'single_server_process': True,
    'stdout_empty': True,
    'executable_sha256': report['executable_sha256'],
    'compiler_sha256': hashlib.sha256(Path(report['compiler']).read_bytes()).hexdigest(),
    'raw_report_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
    'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
}
(saved / 'HTTP执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print('50 actual shared-case HTTP observations: 34 finite/null successes and 16 non-finite failures')
