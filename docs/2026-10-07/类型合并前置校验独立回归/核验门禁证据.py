import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
manifest = json.loads((directory / '复验起点.json').read_text())
fixed = Path(manifest['cwd'])
project = directory.parents[2]
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']
assert subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip() == manifest['source_tree']
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {row[3:] for row in status.splitlines()} == set(manifest['drafts'])


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for name, expected in manifest['drafts'].items():
    assert digest(directory / '草稿' / name) == expected
    assert digest(fixed / name) == expected
    assert digest(project / name) == expected

expected_counts = {'prefix': 20, 'origins': 8, 'resources': 10}

for name, count in expected_counts.items():
    path = project / 'packages/test/tests/incremental/type_merge/preflight' / (name + '_test.zig')
    assert len(re.findall(r'^test "', path.read_text(), re.MULTILINE)) == count

for label, passes, steps, cached in [('Debug', 38, 3, 5), ('ReleaseSafe', 56, 8, 0), ('相邻Debug', 63, 14, 0)]:
    result = json.loads((directory / (label + '执行结果.json')).read_text())
    log = directory / (label + '原始日志.txt')
    text = log.read_text()
    assert digest(log) == result['log_sha256']
    assert result['source_commit'] == manifest['source_commit'] and result['terminal_exit_code'] == 0
    assert result['test_inputs'] == manifest['drafts']
    assert result['actual_test_passes'] == passes and result['actual_test_steps'] == steps
    assert result['cached_test_step_count'] == cached and result['cached_declaration_count'] is None
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4] == str(passes)
    counts = [int(row[1]) for row in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', text)]
    assert sum(counts) == passes and len(counts) == steps
    assert len([line for line in text.splitlines() if re.search(r'\brun test\b.*?\bcached(?:\s|$)', line)]) == cached

    if label != '相邻Debug':
        assert counts[-3:] == [20, 8, 10]
        assert result['new_declaration_counts'] == expected_counts and result['new_unique_declarations'] == 38
    else:
        for gate in ['test-module-artifacts', 'test-library-link', 'test-semantic-cache']:
            assert gate + ' success' in text

initial = json.loads((directory / '首轮模块边界错误.json').read_text())
assert initial['terminal_exit_code'] == 1
assert digest(directory / '首轮模块边界错误日志.txt') == initial['log_sha256']
assert 'import of file outside module path' in (directory / '首轮模块边界错误日志.txt').read_text()
print(json.dumps({'source_commit': manifest['source_commit'], 'new_unique_declarations': 38, 'debug_actual_passes': 38, 'debug_cached_steps': 5, 'safe_actual_passes': 56, 'adjacent_debug_actual_passes': 63, 'formal_files_verified': 5}, ensure_ascii=False))
