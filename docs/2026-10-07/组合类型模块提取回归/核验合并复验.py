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
assert manifest['parents'] == ['c60bc0f75240fe069663bd25cfceb8971cf3cff2', 'bbdfdc6630974a0b2ec1bab547890369dc53eb3e']
assert manifest['test_inputs'] == json.loads((directory / '复验起点.json').read_text())['test_inputs']

for name, expected in manifest['test_inputs'].items():
    assert digest(fixed / name) == expected

for label, count, expected_leaves in [
    ('合并Debug', 105, [4, 4, 4, 7, 7, 7, 15, 15, 15, 6, 6, 2, 10, 3]),
    ('合并ReleaseSafe', 27, [6, 6, 2, 10, 3])
]:
    result = json.loads((directory / (label + '执行结果.json')).read_text())
    log = directory / (label + '原始日志.txt')
    text = log.read_text()
    assert result['source_commit'] == manifest['source_commit']
    assert result['terminal_exit_code'] == 0
    assert result['new_unique_declarations'] == 0
    assert result['test_inputs'] == manifest['test_inputs']
    assert digest(log) == result['log_sha256']
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and int(summary[3]) == int(summary[4]) == count
    leaves = [int(item[1]) for item in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', text)]
    assert leaves == expected_leaves == result['leaf_declaration_counts']
    assert len(leaves) == result['actual_test_steps']
    assert sum(leaves) == result['actual_test_passes'] == count
    assert int(summary[1]) == result['build_steps']
    assert not re.search(r'\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)', text)
    assert result['cached_test_step_count'] == 0
    assert 'test-module-artifacts success' in text

    if label == '合并Debug':
        assert 'test-native-runtime success' in text

print(json.dumps({'source_commit': manifest['source_commit'], 'clean_worktree': True, 'debug_actual_passes': 105, 'release_safe_actual_passes': 27, 'additional_unique_declarations': 0, 'cached_test_steps': 0}, ensure_ascii=False))
