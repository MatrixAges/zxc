import hashlib
import json
from pathlib import Path
import shutil
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
execution = json.loads((directory / '实际执行.json').read_text())
audit = json.loads((directory / '覆盖审计.json').read_text())
paths = [
    'packages/test/tests/language/expressions/template_primitives/bool.zx',
    'packages/test/tests/language/expressions/template_primitives/bool.jsonl',
    'packages/test/upstream/reviews/language/expressions/concatenation_boolean.jsonl',
    'packages/test/suites.json',
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert len(execution['references']) == 2
assert {row['strict'] for row in execution['references']} == {False, True}
assert all(row['passed'] for row in execution['references'])
assert digest(Path(execution['compiler'])) == execution['compiler_sha256']
assert execution['production_commit'] == 'f38d9b4f'
assert len(execution['commands']) == 6
assert all(row['status'] == 0 and row['signal'] is None and row['error'] is None for row in execution['commands'])
native = [row for row in execution['commands'] if row['command'] == 'zig']
assert len(native) == 2
assert all('All 2 tests passed.' in row['stderr'] for row in native)
assert {row['argv'][1] for row in native} == {'-Odebug', '-Osafe'}

for name, sha in execution['source_fingerprints'].items():
    path = directory / name if name == '执行草稿.mjs' else root / name
    assert digest(path) == sha

for name in paths:
    assert (root / name).read_bytes() == (directory / '草稿' / name).read_bytes()

assert digest(root / paths[0]) == execution['source_sha256']
assert digest(root / paths[1]) == execution['catalog_sha256']
catalog = [json.loads(line) for line in (root / paths[1]).read_text().splitlines()]
assert [row['input'] for row in catalog] == [False, True]
assert [row['expected']['value'] for row in catalog] == ['false', 'true']
review = json.loads((root / paths[2]).read_text())
assert review['status'] == 'adapted'
assert review['cases'] == [row['id'] for row in catalog]
assert review['assertions'] == [{'case': row['id'], 'field': 'value', 'expected': row['expected']['value']} for row in catalog]
assert digest(directory / '完整原文.txt') == review['sha256']

registry = json.loads((root / paths[3]).read_text())
registry['runtime'] = [row for row in registry['runtime'] if row['path'] != 'language/expressions/template_primitives/bool']
original_registry = json.loads(subprocess.check_output(['git', 'show', 'HEAD:packages/test/suites.json'], cwd=root))
assert registry == original_registry

observations = []
nested_commands = []

for group in execution['reports']:
    report_path = Path(group['raw_report'])
    assert digest(report_path) == group['sha256']
    report = json.loads(report_path.read_text())
    assert report['optimize'] == group['optimize']
    assert len(report['observations']) == 6
    assert len(report['commands']) == 7
    assert len(report['artifacts']) == 3
    assert all(row['executed'] and row['passed'] and row['response']['status'] == 0 for row in report['observations'])
    assert all(row['status'] == 0 and row['signal'] is None and row['error'] is None for row in report['commands'])
    assert {(row['id'], row['target']) for row in report['observations']} == {(row['id'], target) for row in catalog for target in ['native', 'wasm32-wasi', 'wasm32-freestanding']}
    observations += report['observations']
    nested_commands += report['commands']

assert len(observations) == 12 and len(nested_commands) == 14
assert audit['catalog_cases'] == 80587 and audit['catalog_by_runner']['runtime'] == 63044
assert audit['reviewed'] == {'adapted': 733, 'excluded': 1784, 'equivalent': 103}
assert audit['unreviewed'] == 50977 and audit['linked_cases'] == 5316
shutil.copyfile('/tmp/zxc-boolean-original-final.log', directory / '实际执行日志.txt')
fingerprint_paths = [root / name for name in paths]
fingerprint_paths += [path for path in directory.rglob('*') if path.is_file() and path.name != '执行结果.json' and path.suffix != '.md']
fingerprints = {str(path.relative_to(root)): digest(path) for path in fingerprint_paths}
result = {
    'IDEA': {
        'Intent': '完整适配两项primitive布尔转文本原文观察',
        'Data': '固定原文SHA、两次原样Node、四次具名Zig执行与十二次三目标观察',
        'Edges': '只声明显式模板适配；模式与目标复跑不增加独立ID；不声明通用JS加法',
        'Answer': '两条正式案例、一份完整adapted审阅、原始报告与来源SHA',
    },
    '主检出提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip(),
    '编译器生产基线': execution['production_commit'],
    '编译器SHA256': execution['compiler_sha256'],
    '参考Node实际执行': 2,
    '具名Zig实际执行': 4,
    '三目标补充实际观察': 12,
    '进程命令记录': 20,
    'Wasm调用': 4,
    '独立案例': 2,
    '新增完整adapted文件': 1,
    '退出码': 0,
    '覆盖审计': audit,
    '来源SHA256': fingerprints,
    '自我批判': '原文两项完整文本均保留；参考Node通过不是ZX通过。显式模板是当前公開能力的适配形式，不能扩张为一般隐式加法。生成Zig仅由普通bool输入选择true/false的标准文本，没有ID、模式或目标分支。编译器固定f38d9b4f，应用优化分别Debug/Safe，不把当前主检出的新生产修改算作该基线的通过。共享注册文件按9605b0c2的新四空格规则格式化；移除新增注册后JSON结构与HEAD逐项相同，其他差异只有旧tab缩进迁移。',
}
(directory / '执行结果.json').write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
print('Verified complete bool original, 4 named executions, 12 supplementary observations and exact registry semantic delta')
