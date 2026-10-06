import hashlib
import json
from pathlib import Path
import shutil
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
fixed = Path('/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc')
draft = directory / '草稿'
start = json.loads((directory / '草稿起点.json').read_text())
reference = json.loads((directory / '原文结果.json').read_text())
mapping = json.loads((directory / '原文观察映射.json').read_text())
application = json.loads((directory / '应用执行.json').read_text())
audit = json.loads((directory / '覆盖审计.json').read_text())
paths = [
    'packages/test/build.zig',
    'packages/test/src/querystring/percent_cases.ts',
    'packages/test/src/data/querystring_uri.jsonl',
    'packages/test/tests/standard/querystring/escape/cases.jsonl',
    'packages/test/tests/standard/querystring/unescape/cases.jsonl',
    'packages/test/upstream/reviews/built_ins/uri/escape.jsonl',
    'packages/test/upstream/reviews/built_ins/uri/unescape.jsonl',
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert subprocess.check_output(['git', 'rev-parse', '--short=8', 'HEAD'], cwd=fixed, text=True).strip() == start['生产基线'] == 'a7662c5c'
actual_paths = [row[3:] for row in subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=fixed, text=True).splitlines()]
assert set(actual_paths) == set(paths), actual_paths

for name in paths:
    assert (root / name).read_bytes() == (fixed / name).read_bytes() == (draft / name).read_bytes(), name

assert reference['unchanged_executions'] == reference['observed_executions'] == 32
assert reference['core_observations'] == 134
assert reference['script_sha256'] == digest(directory / '原文验证.mjs')
assert len(reference['results']) == len(mapping) == 16
assert len({row['case'] for group in mapping for row in group['observations']}) == 130

for source, group in zip(reference['results'], mapping):
    assert source['path'] == group['path'] and source['sha256'] == group['sha256']
    assert {row['strict'] for row in source['modes']} == {False, True}
    assert all(row['unchanged_passed'] and row['observed_passed'] for row in source['modes'])
    assert source['modes'][0]['observations'] == source['modes'][1]['observations']
    assert source['modes'][0]['observations'] == [{'index': row['index'], 'input': row['input'], 'value': row['expected']} for row in group['observations']]
    original = directory / '原文' / source['operation'] / (Path(source['path']).stem + '.txt')
    assert digest(original) == source['sha256']

new_rows = [json.loads(line) for line in (root / paths[2]).read_text().splitlines()]
assert len(new_rows) == 35
new_ids = {f'standard/querystring/{row["operation"]}/{row["name"]}' for row in new_rows}
assert len(new_ids) == 35
reviews = []

for operation in ['escape', 'unescape']:
    catalog_name = f'packages/test/tests/standard/querystring/{operation}/cases.jsonl'
    original = subprocess.check_output(['git', 'show', f'a7662c5c:{catalog_name}'], cwd=root)
    actual = (root / catalog_name).read_bytes()
    assert actual.startswith(original)
    delta = [json.loads(line) for line in actual[len(original):].splitlines()]
    assert len(delta) == {'escape': 13, 'unescape': 22}[operation]
    assert {row['id'] for row in delta} == {name for name in new_ids if f'/{operation}/' in name}
    cases = {row['id']: row for row in map(json.loads, actual.decode().splitlines())}
    for group in mapping:
        if group['operation'] != operation:
            continue
        for row in group['observations']:
            assert cases[row['case']]['input'] == row['input']
            assert cases[row['case']]['expected']['value'] == row['expected']
    review_name = f'packages/test/upstream/reviews/built_ins/uri/{operation}.jsonl'
    reviews.extend(json.loads(line) for line in (root / review_name).read_text().splitlines())

assert len(reviews) == 16 and all(row['status'] == 'adapted' for row in reviews)
assert {row['path']: row['sha256'] for row in reviews} == {row['path']: row['sha256'] for row in mapping}
assert sum(len(row['assertions']) for row in reviews) == 134
managed = []

for mode in ['Debug', 'ReleaseSafe']:
    evidence = json.loads((directory / mode / '执行结果.json').read_text())
    assert evidence['exit_code'] == 0 and evidence['actual_managed_executions'] == 575
    assert len(evidence['reports']) == 6
    assert digest(directory / mode / '原始日志.txt') == evidence['log_sha256']
    ids = {name for report in evidence['reports'] for name in report['ids']}
    assert new_ids <= ids
    for report in evidence['reports']:
        assert not report['cached_test'] and report['actual_passed'] == len(report['ids'])
        assert digest(directory / mode / report['generated_assertion_file']) == report['generated_assertion_sha256']
        assert digest(Path(report['catalog'])) == report['catalog_sha256']
    managed.append(evidence)

assert application['production_commit'] == 'a7662c5c'
assert digest(Path(application['compiler'])) == application['compiler_sha256']
assert digest(directory / '应用验证.mjs') == application['script_sha256']
assert len(application['commands']) == len(application['reports']) == 4
assert all(row['status'] == 0 and row['signal'] is None and row['error'] is None for row in application['commands'])

for name, sha in application['fingerprints'].items():
    path = Path(name) if name.startswith('/') else fixed / name
    assert digest(path) == sha

observations = []
commands = []

for row in application['reports']:
    path = Path(row['path'])
    assert digest(path) == row['sha256']
    report = json.loads(path.read_text())
    assert report['optimize'] == row['optimize']
    assert len(report['artifacts']) == 3
    assert all(item['executed'] and item['passed'] and item['response']['status'] == 0 for item in report['observations'])
    assert all(item['status'] == 0 and item['signal'] is None and item['error'] is None for item in report['commands'])
    observations.extend({**item, 'optimize': row['optimize']} for item in report['observations'])
    commands.extend(report['commands'])

assert len(observations) == 780 and len(commands) == 532
assert sum(row['id'] in new_ids for row in observations) == 210
assert len({(row['id'], row['target'], row['optimize']) for row in observations}) == 780
assert audit['catalog_cases'] == 80622 and audit['catalog_by_runner']['runtime'] == 63079
assert audit['reviewed'] == {'adapted': 749, 'excluded': 1784, 'equivalent': 103}
assert audit['unreviewed'] == 50961 and audit['linked_cases'] == 5446
assert not (directory / '类型检查日志.txt').read_bytes()
shutil.copyfile('/tmp/zxc-uri-draft-check.log', directory / '草稿生成检查日志.txt')
shutil.copyfile('/tmp/zxc-uri-draft-generate.log', directory / '草稿生成日志.txt')
fingerprint_paths = [root / name for name in paths]
fingerprint_paths += [fixed / name for name in ['packages/compiler/standard/src/querystring/percent.zig', 'packages/compiler/standard/src/querystring/root.zig', 'packages/compiler/standard/interfaces/querystring.d.zx', 'packages/test/build/runtime.zig', 'packages/test/tests/support/collections.zig']]
fingerprint_paths += [path for path in directory.rglob('*') if path.is_file() and path.name != '执行结果.json' and path.suffix != '.md']
fingerprints = {str(path): digest(path) for path in fingerprint_paths}
result = {
    'IDEA': {'Intent': '完整保留16份URI成功原文的134项观察', 'Data': '32次原样Node参考与32次辅助观察执行，双模式1150次具名Zig和780次三目标应用观察', 'Edges': '公开querystring接口适配；不声明损坏编码、孤立surrogate、JS全局或隐式转换兼容', 'Answer': '35个独立新ID，16份完整adapted审阅，原始报告、生成源码与来源SHA'},
    '生产基线': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip(),
    '生产树': subprocess.check_output(['git', 'rev-parse', 'HEAD^{tree}'], cwd=fixed, text=True).strip(),
    '编译器SHA256': application['compiler_sha256'],
    '原样Node参考执行': 32,
    '辅助intrinsic观察执行': 32,
    '完整原文': 16,
    '完整原文核心观察': 134,
    '复用现有观察': 99,
    '复用现有唯一案例': 95,
    '新增独立案例': 35,
    '唯一关联案例': 130,
    '具名Zig实际执行': 1150,
    '三目标实际观察': 780,
    '新增ID实际执行与观察': 280,
    '应用驱动进程记录': 536,
    '应用Wasm调用': 260,
    '应用生成产物': 12,
    '覆盖审计': audit,
    '来源SHA256': fingerprints,
    '自我批判': '原文全部读取，ASCII循环与短路行为完整保留。32次原样参考执行没有换掉intrinsic；另32次辅助观察只记录真实调用结果。134项原文观察映射到130个唯一案例，四个重复百分号输入不重复新增ID。99项观察复用95个已有ID，仅补35个缺少的输入。参考结果作为测试数据，由Node querystring再核对，不进入生产条件分支。两个旧catalog字节前缀与a7662c5c完全相同，四个邻接catalog与全部ZX源码不变。新增generator依赖防止数据更新被缓存忽略。首轮从根目录调用包内门禁失败，未执行案例；隔离检出缺少TypeScript依赖，最终在主检出对相同正式文件完成类型检查。两者是工具调用环境问题，没有当成生产缺陷通知实现聊天。根ebe3d605全量回归继续保留独立证据。',
}
(directory / '执行结果.json').write_text(json.dumps(result, ensure_ascii=False, indent=4) + '\n')
print('Verified 16 complete originals, 35 new IDs, 1150 named executions and 780 real application observations')
