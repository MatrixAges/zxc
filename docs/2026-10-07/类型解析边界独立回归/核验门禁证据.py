import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
project = directory.parents[2]
manifest = json.loads((directory / '复验起点.json').read_text())
fixed = Path(manifest['cwd'])


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['source_commit']
assert subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip() == manifest['source_tree']
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {line[3:] for line in status.splitlines()} == set(manifest['test_inputs'])

for name, expected in manifest['test_inputs'].items():
    for root in [fixed, project, directory / '草稿']:
        assert digest(root / name) == expected, name

for name, count in manifest['new_declaration_counts'].items():
    source = project / 'packages/test/tests/language/types/resolution' / (name + '_test.zig')
    assert len(re.findall(r'^test "', source.read_text(), re.MULTILINE)) == count

assert manifest['new_declaration_counts'] == {'initialization': 10, 'names': 19, 'nodes': 20, 'views': 9, 'resources': 5}
assert sum(manifest['new_declaration_counts'].values()) == manifest['new_unique_declarations'] == 63

for label in ['Debug', 'ReleaseSafe', '相邻Debug']:
    result = json.loads((directory / (label + '执行结果.json')).read_text())
    log = directory / (label + '原始日志.txt')
    text = log.read_text()
    assert result['terminal_exit_code'] == 0
    assert result['source_commit'] == manifest['source_commit']
    assert result['test_inputs'] == manifest['test_inputs']
    assert digest(log) == result['log_sha256']
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4]
    leaves = [int(item[1]) for item in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', text)]
    assert leaves == result['leaf_declaration_counts']
    assert len(leaves) == result['actual_test_steps']
    assert sum(leaves) == int(summary[3]) == result['actual_test_passes']
    assert int(summary[1]) == result['build_steps']
    assert not re.search(r'\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)', text)
    assert result['cached_test_step_count'] == 0 and result['cached_declaration_count'] is None

    if label != '相邻Debug':
        assert result['build_steps'] == 31 and result['actual_test_passes'] == 63
        assert result['new_unique_declarations'] == 63
        assert result['new_declaration_counts'] == manifest['new_declaration_counts']
        assert leaves == [10, 19, 20, 9, 5]
        assert 'test-type-resolution success' in text
    else:
        assert result['build_steps'] == 30 and result['actual_test_passes'] == 50
        assert result['new_unique_declarations'] == 0
        assert leaves == [40, 4, 4, 2]
        for gate in ['test-native-declarations', 'test-expression-bindings']:
            assert gate + ' success' in text

outputs = json.loads((directory / '产物清单.json').read_text())
assert len(outputs) == 6

for name, entry in outputs.items():
    assert digest(directory / name) == entry['sha256']
    assert digest(Path(entry['build_output_path'])) == entry['sha256']

for name in ['type_resolution', 'resolution_abi', 'parser_options']:
    assert digest(directory / '生成产物/Debug' / (name + '.txt')) == digest(directory / '生成产物/ReleaseSafe' / (name + '.txt'))

source = (directory / '生成产物/Debug/type_resolution.txt').read_text()
assert set(re.findall(r'@import\("([^"\n]+)"\)', source)) == {'std', 'integers', 'resolution', 'zxc_abi'}
assert 'generated_parser: bool = true' in (directory / '生成产物/Debug/parser_options.txt').read_text()

failures = json.loads((directory / '夹具诊断记录.json').read_text())
for entry in failures.values():
    assert digest(directory / entry['log_file']) == entry['log_sha256']

assert failures['format']['terminal_exit_code'] == failures['first_debug']['terminal_exit_code'] == 1
assert failures['second_debug']['terminal_exit_code'] == 0
assert "found 'opaque'" in (directory / '首轮夹具格式错误.txt').read_text()
assert '60/62 tests passed (2 failed)' in (directory / '首轮Debug原始日志.txt').read_text()
assert 'try std.testing.expect(parsed == .indexed)' in (directory / '首轮Debug原始日志.txt').read_text()
assert '9/9 tests passed' in (directory / '第二轮Debug原始日志.txt').read_text()
assert json.loads((directory / '首次输入清单.json').read_text())['new_unique_declarations'] == 62
assert json.loads((directory / '第二轮输入清单.json').read_text())['new_unique_declarations'] == 62
assert all(item['exit_code'] == 0 for item in json.loads((directory / '源码检查.json').read_text()))
matrix = json.loads((directory / '目录矩阵原始报告.txt').read_text())
assert matrix['catalog_cases'] == 80625 and matrix['unreviewed'] == 50869
print(json.dumps({'source_commit': manifest['source_commit'], 'new_unique_declarations': 63, 'actual_passes_per_mode': 63, 'adjacent_debug_passes': 50, 'cached_test_steps': 0, 'formal_files_verified': len(manifest['test_inputs'])}, ensure_ascii=False))
