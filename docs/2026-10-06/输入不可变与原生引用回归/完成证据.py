import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
manifest = json.loads((directory / '执行起点.json').read_text())
fixed = Path(manifest['cwd']).parents[1]
assert manifest['completed'] and manifest['safe_all']['terminal_exit_code'] == 0
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=fixed, text=True).strip() == manifest['production_commit']

for name, expected in manifest['sources'].items():
    assert hashlib.sha256((fixed / name).read_bytes()).hexdigest() == expected, name
    assert hashlib.sha256(subprocess.check_output(['git', 'show', manifest['production_commit'] + ':' + name], cwd=fixed)).hexdigest() == expected, name

for name, patch in manifest['test_patches'].items():
    assert (root / name).read_bytes() == (fixed / name).read_bytes() == (directory / '草稿' / name).read_bytes()
    assert hashlib.sha256((fixed / name).read_bytes()).hexdigest() == patch['sha256']

debug = json.loads((directory / 'Debug核心/执行结果.json').read_text())
neighbors = json.loads((directory / 'Debug相邻执行结果.json').read_text())
safe = json.loads((directory / 'ReleaseSafe完整/执行结果.json').read_text())
assert debug['actual_managed_test_instances'] == 190 and debug['cached_managed_test_steps'] == 0
assert safe['actual_managed_test_instances'] == 888 and safe['cached_managed_test_steps'] == 0
assert neighbors['final_actual_instances'] == 105 and neighbors['cached_passed_instances_from_unchanged_initial'] == 593

for label, result in [('Debug核心', debug), ('ReleaseSafe完整', safe)]:
    for row in result['native_reports']:
        assert hashlib.sha256((directory / label / row['raw_report']).read_bytes()).hexdigest() == row['sha256']
    for name, expected in result['input_generation_sha256'].items():
        assert hashlib.sha256((directory / label / '输入生成' / name).read_bytes()).hexdigest() == expected
    assert hashlib.sha256((directory / label / '应用边界原始报告.txt').read_bytes()).hexdigest() == result['application_boundary_report_sha256']
    assert hashlib.sha256((directory / label / '原始日志.txt').read_bytes()).hexdigest() == result['log_sha256']

fingerprints = {str(path.relative_to(root)): hashlib.sha256(path.read_bytes()).hexdigest() for path in directory.rglob('*') if path.is_file() and path.name != '执行结果.json' and path.suffix != '.md'}
value = {
    '固定生产提交': manifest['production_commit'],
    '测试专用修正': manifest['test_patches'],
    'Debug核心': debug,
    'Debug相邻': neighbors,
    'ReleaseSafe完整': safe,
    '核心独立声明': 194,
    '新增JSONL案例': 0,
    '新增Test262审阅': 0,
    '生产源码修改': 0,
    '来源SHA256': fingerprints,
    '自我批判': '首轮邻接失败不是生产缺陷，而是迁移为成功用例后遗漏Store槽数和aggregate类型预期。没有删除失败用例或跳过类型检查，保持scalar默认比较并给两aggregate补完整结构检查，始终保留Store数量和IR验证。Debug最终105个实际实例与593个先前通过的缓存实例分开；缓存80是步骤数，不是声明数。Safe所有七门禁实际888个构建管理实例及90个外部原生实例通过。194只统计核心既有独立声明，路线、模式和分配失败注入轮次不增加案例。此部分不代表603文件迁移或全仓库已经验证，根完整回归仍使用早于迁移的独立基线。',
}
(directory / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
(directory / '执行结论.md').write_text('''# 输入不可变与原生引用回归结论

## IDEA

Intent：验证移除owned Input后的普通输入不可变，以及原生引用、RX并行和相邻缓冲优化契约。

Data：固定f38d9b4f，194个既有核心独立声明；Debug核心153/153步骤、190/190构建管理测试实例，另90个外部原生测试实例；ReleaseSafe全部七门禁521/521步骤、888/888实际实例，另90个外部原生实例。

Edges：主检出并发修改不进入证据。独立声明、路线复用、测试实例和缓存单独计数；专项通过不替代新版本全仓库回归。

Answer：修正三份测试文件中的四个遗漏预期，七门禁完成两个模式验证，完整失败/成功日志、56份原生运行报告、两份应用边界报告和24份生成输入源码均已保存。

## 首轮失败与修正

Debug相邻首轮395/397步骤、694/698测试实例，四个失败全在RX推断夹具：两个Store用例默认slots=0但实际1，两个aggregate用例默认scalar但实际object/list。

只修正测试预期：Store显式slots=1；aggregate完整验证object{left:u64[],right:u64[]}或u64[][]。未设置callback的用例仍做原始scalar深比较；所有成功用例仍做Store数量检查及validateIr；诊断定位与defer释放不变。

修正后Debug397/397步骤、105/105本次实际实例通过，另80个缓存测试步骤对应首轮已通过且源文件不变的593个实例。不能把105写成698次新执行，也不能把缓存步骤80写成80个案例。

## 真实出口与生命周期

两模式每次核心运行都有45个原生执行声明通过source/library两路线，实际90个外部Zig实例；九个应用边界登记产生246条命令记录，其中192个准确UnsupportedHostReference拒绝。六条输入路线各执行10个具名声明，成功和分配失败时保留原输入比较。

## 自我批判

''' + value['自我批判'] + '\n')
print('Final source and raw evidence verified; 3 test-only files corrected; Safe 888 actual managed instances and 90 external native instances passed')
