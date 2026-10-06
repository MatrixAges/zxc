import hashlib
import json
from pathlib import Path
import shutil


directory = Path(__file__).resolve().parent
root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
manifest = json.loads((directory / '执行起点.json').read_text())

for path, sha256 in manifest['sources'].items():
    assert hashlib.sha256((fixed / path).read_bytes()).hexdigest() == sha256, path

    if path.startswith('packages/test/'):
        assert (root / path).read_bytes() == (fixed / path).read_bytes(), path

results = []

for label in ['Debug', 'ReleaseSafe']:
    application = json.loads((directory / label / '执行结果.json').read_text())
    gateway = json.loads((directory / label / 'HTTP执行结果.json').read_text())
    assert application['terminal_exit_code'] == gateway['terminal_exit_code'] == 0
    assert application['build_summary'] == '44/44 steps succeeded'
    assert application['cases'] == 422 and application['actual_target_observations'] == 1244
    assert gateway['shared_cases'] == gateway['actual_http_observations'] == 50

    for report in application['reports']:
        assert hashlib.sha256((directory / label / report['raw_report']).read_bytes()).hexdigest() == report['raw_report_sha256']

    assert hashlib.sha256((directory / label / 'HTTP原始报告.txt').read_bytes()).hexdigest() == gateway['raw_report_sha256']
    results.append({'mode': application['mode'], 'application': application, 'gateway': gateway})

for relative in ['packages/test/build/runtime.zig', 'packages/test/build/application_json_gateway.zig', 'packages/test/suites.json', 'packages/test/tests/targets/application_json/check.ts', 'packages/test/tests/targets/application_json/gateway/run_test.ts']:
    assert (root / relative).read_bytes() == (directory / '草稿' / relative).read_bytes(), relative

for path in (fixed / 'packages/test/tests/built_ins/json/output').iterdir():
    relative = path.relative_to(fixed)
    assert path.read_bytes() == (directory / '草稿' / relative).read_bytes(), str(relative)

shutil.copyfile('/tmp/zxc-json-output-audit.log', directory / '覆盖审计.json')
shutil.copyfile('/tmp/zxc-json-output-typecheck.log', directory / '类型检查日志.txt')
audit = json.loads((directory / '覆盖审计.json').read_text())
assert audit['catalog_cases'] == 80583 and audit['catalog_by_runner']['runtime'] == 63040
assert audit['unreviewed'] == 51044 and audit['linked_cases'] == 5314
manifest['debug']['terminal_exit_code'] = 0
manifest['debug']['build_summary'] = '44/44 steps succeeded'
manifest['debug']['evidence'] = ['Debug/执行结果.json', 'Debug/HTTP执行结果.json']
manifest['safe'] = {
    'command': manifest['debug']['command'].replace('-Doptimize=debug', '-Doptimize=safe'),
    'handle': 50953,
    'log': '/tmp/zxc-json-output-final-safe.log',
    'terminal_exit_code': 0,
    'build_summary': '44/44 steps succeeded',
    'evidence': ['ReleaseSafe/执行结果.json', 'ReleaseSafe/HTTP执行结果.json'],
}
manifest['complete'] = True
(directory / '执行起点.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
value = {
    'production_commit': manifest['production_commit'],
    'completed_part': 'JSON application and HTTP numeric output boundaries',
    'new_catalog_ids': 50,
    'upstream_review_changes': 0,
    'actual_new_case_observations_two_modes_four_targets': 400,
    'actual_application_observations_two_modes': 2488,
    'actual_http_observations_two_modes': 100,
    'actual_combined_observations_two_modes': 2588,
    'transport_exclusions_two_modes': 44,
    'typecheck_exit_code': 0,
    'audit_exit_code': 0,
    'results': results,
    'self_review': 'Ordinary identity and division source plus eight computed boolean projections, no input-specific result hardcoding. Error responses preserve complete stdout/HTTP boundaries and later requests continue. HTTP reuses all 50 IDs. This does not prove memory leak absence or JavaScript JSON.stringify text compatibility. The independent source audit found no concrete harness logic defect. Root ebe3d605 regression remains a separate pending gate.',
}
(directory / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print('50 unique new IDs; 400 new-case observations; 2588 total observations; final source and report fingerprints verified')
