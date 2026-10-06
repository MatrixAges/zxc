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

analysis = project / 'packages/test/tests/language/expressions/loop_policy/standalone_test.zig'
runtime = project / 'packages/test/tests/incremental/native_runtime/loops/runtime_test.zig'
assert len(re.findall(r'^test "', analysis.read_text(), re.MULTILINE)) == 9
assert len(re.findall(r'^test "', runtime.read_text(), re.MULTILINE)) == 15
assert manifest['new_unique_declarations'] == 24

for mode in ['Debug', 'ReleaseSafe']:
    result = json.loads((directory / (mode + '执行结果.json')).read_text())
    log = directory / (mode + '原始日志.txt')
    text = log.read_text()
    assert result['terminal_exit_code'] == 0
    assert result['source_commit'] == manifest['source_commit']
    assert result['test_inputs'] == manifest['test_inputs']
    assert digest(log) == result['log_sha256']
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', text)
    assert summary and summary[1] == summary[2] and summary[3] == summary[4] == '91'
    leaves = list(re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', text))
    assert len(leaves) == 11 and sum(int(item[1]) for item in leaves) == 91
    assert not re.search(r'\brun test\b[^\n]*?(?<!\S)cached(?:\s|$)', text)
    for path in ['original', 'linked', 'cached']:
        assert re.search(r'run test native-loops-' + path + r' 15 pass \(15 total\)', text)
    assert '9 pass (9 total)' in text
    assert 'ℹ tests 2' in text and 'ℹ pass 2' in text and 'ℹ fail 0' in text
    assert result['actual_zig_test_passes'] == 91
    assert result['new_unique_declarations'] == 24
    assert result['new_zig_test_executions'] == 54
    assert result['cached_test_step_count'] == 0

outputs = json.loads((directory / '产物清单.json').read_text())
for name, entry in outputs.items():
    assert digest(directory / name) == entry['sha256']
    assert digest(Path(entry['build_output_path'])) == entry['sha256']

for mode in ['Debug', 'ReleaseSafe']:
    for kind in ['source', 'abi']:
        assert digest(directory / '产物' / mode / ('linked_' + kind + '.txt')) == digest(directory / '产物' / mode / ('cached_' + kind + '.txt'))

for name in ['首轮夹具错误', '第二轮负例入口错误', '错误工作目录']:
    entry = json.loads((directory / (name + '.json')).read_text())
    assert entry['terminal_exit_code'] == 1
    assert digest(directory / (name + '日志.txt')) == entry['log_sha256']

print(json.dumps({'source_commit': manifest['source_commit'], 'new_unique_declarations': 24, 'actual_zig_passes_per_mode': 91, 'new_zig_executions_per_mode': 54, 'node_passes_per_mode': 2, 'cached_test_steps': 0, 'formal_files_verified': len(manifest['test_inputs'])}, ensure_ascii=False))
