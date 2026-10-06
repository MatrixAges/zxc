import hashlib
import json
from pathlib import Path
import re
import subprocess


directory = Path(__file__).resolve().parent
initial = json.loads((directory / '初始版本起点.json').read_text())
current = json.loads((directory / '复验起点.json').read_text())
fixed = Path(current['cwd'])
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == current['source_commit']
status = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True)
assert {line[3:] for line in status.splitlines()} == set(current['drafts'])
expected_runs = {f'native-{fixture}-{route}': count for fixture, count in [('basic', 4), ('mixed', 7)] for route in ['original', 'linked', 'cached']}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for name, expected in current['drafts'].items():
    assert digest(directory / '草稿' / name) == expected
    assert digest(fixed / name) == expected
    assert digest(directory.parents[2] / name) == expected

formatting = json.loads((directory / '提交格式差异.json').read_text())
before_format = json.loads((directory / '格式前版本起点.json').read_text())

for name, row in formatting.items():
    tested = directory / '格式前源码' / (name + '.txt')
    formal = directory / '草稿' / name
    assert digest(tested) == row['tested_sha256'] == before_format['drafts'][name] == initial['drafts'][name]
    assert digest(formal) == row['formal_sha256'] == current['drafts'][name]
    assert [line for line in tested.read_bytes().splitlines() if line.strip()] == [line for line in formal.read_bytes().splitlines() if line.strip()]

for name in ['main.zx', 'helper.zx', 'choice.d.zx', 'choice.zig', 'runtime_test.zig']:
    path = 'packages/test/tests/incremental/native_runtime/' + name
    original = subprocess.check_output(['git', 'show', initial['source_commit'] + ':' + path], cwd=fixed)
    assert (fixed / path).read_bytes() == original
    assert (directory.parents[2] / path).read_bytes() == original

basic = fixed / 'packages/test/tests/incremental/native_runtime/runtime_test.zig'
mixed = fixed / 'packages/test/tests/incremental/native_runtime/mixed/runtime_test.zig'
assert len(re.findall(r'^test "', basic.read_text(), re.MULTILINE)) == 4
assert len(re.findall(r'^test "', mixed.read_text(), re.MULTILINE)) == 7
all_outputs = {}

for label, source in [('Debug', initial), ('ReleaseSafe', initial), ('当前版本Debug', before_format), ('当前版本ReleaseSafe', before_format), ('提交格式后Debug', current), ('提交格式后ReleaseSafe', current)]:
    saved = directory / label
    result = json.loads((saved / '执行结果.json').read_text())
    assert json.loads((directory / result['input_manifest']).read_text()) == source
    assert result['source_commit'] == source['source_commit'] and result['terminal_exit_code'] == 0
    assert result['runs'] == expected_runs and result['catalog_ids_added'] == 0
    log = saved / '原始日志.txt'
    assert digest(log) == result['log_sha256']
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', log.read_text())
    assert summary and summary[1] == summary[2] and summary[3] == summary[4] == '33'
    assert len(re.findall(r'run test native-\S+ \d+ pass', log.read_text())) == 6

    outputs = result['outputs']
    assert set(outputs) == {'mixed', 'basic'}

    for fixture, rows in outputs.items():
        assert set(rows) == {'original.zig', 'original_abi.zig', 'linked.zig', 'linked_abi.zig', 'cached.zig', 'cached_abi.zig'}

        for name, row in rows.items():
            raw = saved / row['raw_file']
            assert digest(raw) == row['sha256']

            if '_abi' not in name:
                assert set(re.findall(r'@import\("([^"]+)"\)', raw.read_text())) == {'std', 'choice', 'zxc_abi'}
                assert 'pub fn execute(' in raw.read_text()

                if fixture == 'mixed':
                    signature = re.search(r'pub fn execute\([^\n]+error\{([^}]+)\}', raw.read_text())
                    assert signature and {item.strip() for item in signature[1].split(',') if item.strip()} == {'OutOfMemory', 'NativeFailure', 'ZetaFailure'}

        assert rows['linked.zig']['sha256'] == rows['cached.zig']['sha256']
        assert rows['linked_abi.zig']['sha256'] == rows['cached_abi.zig']['sha256']

    all_outputs[label] = {fixture: {name: row['sha256'] for name, row in rows.items()} for fixture, rows in outputs.items()}

assert all_outputs['Debug'] == all_outputs['ReleaseSafe']
assert all_outputs['当前版本Debug'] == all_outputs['当前版本ReleaseSafe']
assert all_outputs['提交格式后Debug'] == all_outputs['提交格式后ReleaseSafe'] == all_outputs['当前版本Debug']

for label, source in [('初始版本相邻Debug', initial), ('当前版本相邻Debug', current), ('当前版本相邻ReleaseSafe', current)]:
    result = json.loads((directory / (label + '结果.json')).read_text())
    log = directory / (label + '日志.txt')
    assert result['source_commit'] == source['source_commit'] and result['terminal_exit_code'] == 0
    assert digest(log) == result['log_sha256']
    summary = re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed', log.read_text())
    assert summary and summary[1] == summary[2] and summary[3] == summary[4]
    assert int(summary[3]) == sum(int(row[1]) for row in re.finditer(r'\brun test\b[^\n]*? (\d+) pass \((\d+) total\)', log.read_text()))

    for gate in ['test-type-merge', 'test-cache-codec', 'test-module-generation']:
        assert gate + ' success' in log.read_text()

matrix = json.loads((directory / '目录矩阵原始报告.txt').read_text())
assert matrix['catalog_cases'] == 80625 and matrix['upstream_files'] == 53597
assert matrix['reviewed'] == {'adapted': 752, 'excluded': 1873, 'equivalent': 103}
assert matrix['unreviewed'] == 50869 and matrix['linked_cases'] == 5449
print(json.dumps({'initial_source': initial['source_commit'], 'current_source': current['source_commit'], 'new_unique_declarations': 7, 'native_route_passes_per_gate': 33, 'generated_files_verified': 72, 'adjacent_commands_verified': 3}, ensure_ascii=False))
