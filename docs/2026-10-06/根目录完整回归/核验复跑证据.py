import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
manifest = json.loads((directory / '复跑起点.json').read_text())
fixed = Path(manifest['cwd'])


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']
assert subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip() == manifest['source_tree']
assert not subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)

for name, expected in manifest['sources'].items():
    assert digest(fixed / name) == expected

for name in ['solver', 'archive']:
    assert digest(Path(manifest[name]['path'])) == manifest[name]['sha256']

for mode, label, passes, cached in [('debug', '复跑Debug', 87545, 33), ('safe', '复跑ReleaseSafe', 19610, 939)]:
    saved = directory / label
    result = json.loads((saved / '执行结果.json').read_text())
    log = saved / '原始日志.txt'
    assert digest(log) == result['log_sha256']
    if mode == 'safe':
        assert result['source_commit'] == manifest['source_commit']
    else:
        assert result['log_sha256'] == manifest['debug_test']['log_sha256']
    assert result['terminal_exit_code'] == 0 and result['mode'] == mode
    assert result['actual_build_test_passes'] == passes
    assert result['cached_build_test_step_count'] == cached
    assert result['cached_build_test_declaration_count'] is None

    tree = log.read_text().split('Build Summary: ', 1)[1]
    actual = [int(row[1]) for row in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', tree)]
    cached_steps = [line for line in tree.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)]
    assert sum(actual) == passes and len(actual) == result['actual_build_test_leaves']
    assert cached_steps == result['cached_test_steps'] and len(cached_steps) == cached
    assert len(actual) + cached == 1253
    assert tree.splitlines()[0] == result['build_summary']

    reports = result['reports']
    assert {name: len(rows) for name, rows in reports.items()} == {'application_json': 4, 'native_runtime': 28, 'native_targets': 1, 'safety': 6}

    for group, rows in reports.items():
        for row in rows:
            raw = saved / row['raw_report']
            assert digest(raw) == row['sha256']
            report = [json.loads(line) for line in raw.read_text().splitlines()] if group == 'safety' else json.loads(raw.read_text())

            if group == 'application_json':
                observations = report['observations']
                assert report['optimize'] == mode
                assert all(item['passed'] for item in observations if item['executed'])
                assert len({item['id'] for item in observations}) == row['ids']
                assert sum(item['executed'] for item in observations) == row['executed']
                assert sum(not item['executed'] for item in observations) == row['excluded']
            elif group == 'native_runtime':
                assert report['status'] == 0 and report['signal'] is None and report['error'] is None
                assert report['optimize'] == mode and report['source'] == row['source']
                assert len(re.findall(r'^test "', Path(report['source']).read_text(), re.MULTILINE)) == row['declarations']
            elif group == 'native_targets':
                assert report['optimize'] == mode and len(report['reports']) == 9
                assert all(item['passed'] for item in report['reports'])
            else:
                assert len(report) == row['ids'] and all(item['passed'] for item in report)
                scalar = report[0]['id'].split('/')[3]
                assert digest(fixed / 'zig-out/conformance' / mode / (scalar + '.jsonl')) == row['sha256']
                if mode == 'safe':
                    assert row['generation_phase'] == 'interrupted'

    assert sum(row['ids'] for row in reports['application_json']) == 372
    assert sum(row['executed'] for row in reports['application_json']) == 1094
    assert sum(row['excluded'] for row in reports['application_json']) == 22
    assert len({row['source'] for row in reports['native_runtime']}) == 14
    assert sum(row['declarations'] for row in reports['native_runtime']) == 90
    assert sum(row['ids'] for row in reports['safety']) == 464

for key, name in [('debug_build', '复跑Debug构建日志.txt'), ('safe_build', '复跑ReleaseSafe构建日志.txt'), ('safe_dist', '复跑ReleaseSafe发行日志.txt')]:
    result = manifest[key]
    log = directory / name
    assert result['terminal_exit_code'] == 0 and digest(log) == result['log_sha256']
    assert result['build_summary'] in log.read_text()

for name, key in [('ReleaseSafe测试终态.json', 'safe_test_gate'), ('ReleaseSafe发行终态.json', 'safe_dist')]:
    terminal = json.loads((directory / name).read_text())
    assert terminal['terminal_exit_code'] == 0 and terminal['argv'] == manifest[key]['argv']

for name, value in manifest['dist_artifacts'].items():
    artifact = fixed / name
    assert artifact.stat().st_size == value['bytes'] and digest(artifact) == value['sha256']

assert (fixed / 'zig-out/LICENSE').read_bytes() == (fixed / 'LICENSE').read_bytes()
interrupted = json.loads((directory / '复跑ReleaseSafe测试中断记录.json').read_text())
assert interrupted['terminal_exit_code'] is None and not interrupted['build_summary_present']
assert manifest['interrupted_safe_test']['terminal_exit_code'] is None
assert manifest['root_test_completed'] and manifest['safe_test_completed'] and manifest['dist_completed']
assert manifest['current_gate'] is None
print(json.dumps({'source_commit': manifest['source_commit'], 'debug_actual_tests': 87545, 'safe_actual_tests': 19610, 'safe_cached_steps': 939, 'external_reports_per_mode': 39, 'dist_artifacts': 4}, ensure_ascii=False))
