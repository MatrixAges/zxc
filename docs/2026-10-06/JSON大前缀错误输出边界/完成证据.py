import hashlib
import json
from pathlib import Path
import shutil
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
directory = Path(__file__).resolve().parent
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
manifest = json.loads((directory / '执行起点.json').read_text())
draft = json.loads((directory / '草稿清单.json').read_text())
relative = draft['formal_path']
original = subprocess.check_output(['git', 'show', 'fef9471a:' + relative], cwd=root)
actual = (root / relative).read_bytes()
assert actual.startswith(original)
assert len(actual.decode().splitlines()) - len(original.decode().splitlines()) == 2
assert (fixed / relative).read_bytes() == actual == (directory / '草稿' / relative).read_bytes()

for path, sha256 in manifest['sources'].items():
    assert hashlib.sha256((fixed / path).read_bytes()).hexdigest() == sha256, path

    if path.startswith('packages/test/'):
        assert (root / path).read_bytes() == (fixed / path).read_bytes(), path

results = []

for label in ['Debug', 'ReleaseSafe']:
    result = json.loads((directory / label / '执行结果.json').read_text())
    assert result['terminal_exit_code'] == 0 and result['build_summary'] == '40/40 steps succeeded'
    assert result['actual_combined_observations'] == 208 and result['actual_new_observations'] == 8

    for report in result['application_reports']:
        assert hashlib.sha256((directory / label / report['raw_report']).read_bytes()).hexdigest() == report['raw_report_sha256']

    assert hashlib.sha256((directory / label / 'HTTP原始报告.txt').read_bytes()).hexdigest() == result['http_raw_report_sha256']
    results.append(result)

shutil.copyfile('/tmp/zxc-json-large-prefix-audit.log', directory / '覆盖审计.json')
audit = json.loads((directory / '覆盖审计.json').read_text())
assert audit['catalog_cases'] == 80585 and audit['catalog_by_runner']['runtime'] == 63042
manifest['debug']['terminal_exit_code'] = 0
manifest['debug']['build_summary'] = '40/40 steps succeeded'
manifest['safe'] = {
    'command': manifest['debug']['command'].replace('-Doptimize=debug', '-Doptimize=safe'),
    'handle': 83467,
    'log': '/tmp/zxc-json-large-prefix-safe.log',
    'terminal_exit_code': 0,
    'build_summary': '40/40 steps succeeded',
}
manifest['complete'] = True
(directory / '执行起点.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
(directory / '执行结果.json').write_text(json.dumps({
    'source_commit': manifest['source_commit'],
    'new_ids': 2,
    'actual_new_observations_two_modes': 16,
    'shared_ids': 52,
    'actual_shared_observations_two_modes': 416,
    'prefix_bytes': 8192,
    'production_or_driver_change': False,
    'results': results,
    'self_review': 'Finite control uses identical 8192-byte prefix and follows deep overflow, proving actual transport and subsequent invocation. Only two JSONL rows added; error stdout and HTTP response bytes checked. This bounded case does not prove arbitrary lengths, OOM or leak absence.',
}, ensure_ascii=False, indent=2) + '\n')
print('2 added IDs and 16 new-case observations; 52 shared IDs and 416 total observations; fingerprints verified')
