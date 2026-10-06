import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
manifest = json.loads((directory / '合并复验起点.json').read_text())
fixed = Path(manifest['cwd'])


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']
assert subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip() == manifest['source_tree']
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=fixed, text=True).strip()
assert manifest['parents'][1] == '7f03946bf35e775dc53ef4dd69f247d52f577bbc'
assert subprocess.check_output(['git', 'show', '-s', '--format=%P', 'HEAD'], cwd=fixed, text=True).strip().split() == manifest['parents']
assert manifest['test_inputs'] == json.loads((directory / '复验起点.json').read_text())['test_inputs']

for name, expected in manifest['test_inputs'].items():
    assert digest(fixed / name) == expected

for label, count, steps, expected_leaves in [
    ('合并Debug', 113, 41, [40, 4, 4, 2, 10, 19, 20, 9, 5]),
    ('合并ReleaseSafe', 63, 31, [10, 19, 20, 9, 5])
]:
    result = json.loads((directory / (label + '执行结果.json')).read_text())
    log = directory / (label + '原始日志.txt')
    text = log.read_text()
    assert result['source_commit'] == manifest['source_commit']
    assert result['terminal_exit_code'] == 0 and result['new_unique_declarations'] == 0
    assert result['test_inputs'] == manifest['test_inputs']
    assert digest(log) == result['log_sha256']
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and int(summary[1]) == int(summary[2]) == steps and int(summary[3]) == int(summary[4]) == count
    leaves = [int(item[1]) for item in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', text)]
    assert leaves == expected_leaves == result['leaf_declaration_counts']
    assert len(leaves) == result['actual_test_steps']
    assert sum(leaves) == result['actual_test_passes'] == count
    assert steps == result['build_steps']
    assert not re.search(r'\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)', text)
    assert result['cached_test_step_count'] == 0
    assert 'test-type-resolution success' in text

    if label == '合并Debug':
        for gate in ['test-native-declarations', 'test-expression-bindings']:
            assert gate + ' success' in text

workspace = json.loads((directory / '合并工作区核对.json').read_text())
assert workspace['before'] == workspace['after'] and workspace['byte_identical']
assert workspace['tracked_dirty_file_count'] == len(workspace['before']) == 11
print(json.dumps({'source_commit': manifest['source_commit'], 'clean_worktree': True, 'debug_actual_passes': 113, 'release_safe_actual_passes': 63, 'additional_unique_declarations': 0, 'cached_test_steps': 0}, ensure_ascii=False))
