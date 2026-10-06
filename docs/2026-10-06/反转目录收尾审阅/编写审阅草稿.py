# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path


directory = Path(__file__).resolve().parent
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
entries = [json.loads(line) for line in (directory / '待审文件.jsonl').read_text().splitlines()]
reasons = {
    'S15.4.4.8_A1_T2.js': '混型原始值 true/Infinity/显式undefined/字符串与空洞，第一次十个位置，截长为九后第二次九个位置，并两次检查返回接收者本身。源码没有标题暗示的对象元素。ZX 同型消费列表不保留空洞、动态undefined或JS返回身份；不能改成普通数字排列。',
    'S15.4.4.8_A2_T1.js': '普通 array-like 对象 length=10、自有稀疏数值键，借用通用 reverse；改length为九后再次检查返回原对象与逐位置结果。普通对象改length不自动删第九键。ZX 实际slice不能替代 generic 对象属性算法或返回身份。',
    'S15.4.4.8_A2_T2.js': '普通对象的length先为10.5，再为Number包装对象9.5，两轮分别按截断后的十和九处理，保留全部位置与返回身份。第二轮同时需要对象解包和ToLength；改成整数长度列表会删除核心转换。',
    'S15.4.4.8_A2_T3.js': 'length先为字符串10，再为String包装对象9，通用reverse两轮检查19个位置和两个接收者返回身份。ZX不提供该字符串/包装对象ToLength，不以预设长度列表替代。',
    'S15.4.4.8_A3_T3.js': '对象含x/y/z三个数值键，length=-4294967294；reverse正常返回同一对象，负length属性原样保留，三键均不变。处理长度钳零而原属性不改是核心；空列表或负数静态拒绝不等价。',
    'S15.4.4.8_A4_T1.js': 'Array.prototype和Object.prototype提供继承索引一。reverse读取继承值、创建自有键，数组截零或普通对象删除自有键后再次读到原型值。ZX没有原型/稀疏Has-Get算法，补成稠密列表会移除协议。',
    'S15.4.4.8_A4_T2.js': '自有索引一的值1优先于原型-1，初始稠密反序为1/0；随后数组截零、普通对象删除自有键后回落为-1。仅关联前两个稠密结果，不能覆盖其余原型与删除观察。',
    'array-has-one-entry.js': '冻结单元素数组1后reverse必须正常完成，没有显式assert但证明长度一没有执行会因冻结而失败的写入。ZX本地单元素反序只保留值，不证明JS冻结属性协议；该文件不是零测试。',
    'call-with-boolean.js': '对true/false原始值调用reverse，返回值分别必须是Boolean包装实例。核心为ToObject和返回包装对象，ZX bool或空列表结果均不能替代。',
    'get_if_present_with_delete.js': 'lower getter在读取时清空数组length再返回first；随后必须删除lower、自有upper存在且值first。Has/Get顺序、getter删除与后来Set共同决定结果；普通字符串反序会删除副作用协议。',
    'length-exceeding-integer-limit-with-object.js': 'length=2^53+2，三个巨大索引分别设不同抛错getter。正确ToLength钳为2^53-1，首次upper读取2^53-2并抛StopReverse；后两个Test262Error不能出现。普通list越界或固定整数安全检查不是该正常属性算法。',
    'length-exceeding-integer-limit-with-proxy.js': '稀疏array-like、six traps与索引四的StopReverse getter。精确29项轨迹覆盖双方存在/缺失与单边存在的Has→Get→Set/Delete→descriptor/define，首错误截断后还检查九项位置/length/存在性。ZX普通list或native调用轨迹不实现JS MOP协议。',
    'length.js': 'reverse函数对象length为零，writable=false、enumerable=false、configurable=true。观察动态函数对象描述符，不是列表length或静态方法参数数目。',
    'name.js': 'reverse函数对象name文本及false/false/true属性标志。静态内建调用名不是运行时函数对象属性契约。',
    'not-a-constructor.js': 'Reflect.construct辅助判定reverse没有Construct，再实际new调用抛TypeError。ZX new解析拒绝不能代替运行期构造能力和真实异常。',
    'prop-desc.js': 'typeof reverse为function，并验证Array.prototype上该属性writable=true、enumerable=false、configurable=true。静态list方法存在不提供动态原型描述符。',
    'resizable-buffer.js': '每个实际ctor的20次reverse/whole-view比较，多个offset、固定与length-tracking视图共享同一RAB，在长度四、三、一、零、六时观察越界无写入、恢复和范围内反序。参考Node实际包含15种ctor与子类。两个稠密值投影仅保留顺序，不包含共享视图、resize、OOB恢复或TypedArray身份。',
}
reviews = []
evidence = []
assert len(entries) == len(reasons) == 17

for entry in entries:
    name = Path(entry['path']).name
    assert hashlib.sha256((upstream / entry['path']).read_bytes()).hexdigest() == entry['sha256']
    row = {key: entry[key] for key in ('path', 'sha256')}
    row.update(status='excluded', reason=reasons[name], contract='packages/core/IR契约.md#所有权与集合回调；docs/zx_design_doc.md §14.3/14.4；docs/2026-10-06/反转目录收尾审阅计划.md', cases=[])

    if name == 'S15.4.4.8_A4_T2.js':
        row['cases'] = ['built_ins/list/reverse/i64/items_p0_p1']
        row['assertions'] = [{'case': row['cases'][0], 'field': 'value', 'expected': [1, 0]}]
        row['partial_observations'] = [{'lines': [17, 21], 'scope': '仅初始自有稠密值反序，不含原型和delete'}]
    elif name == 'array-has-one-entry.js':
        row['cases'] = ['built_ins/list/reverse/i64/items_p1']
        row['assertions'] = [{'case': row['cases'][0], 'field': 'value', 'expected': [1]}]
        row['partial_observations'] = [{'line': 23, 'scope': '仅单元素值投影，不含freeze和无写入契约'}]
    elif name == 'resizable-buffer.js':
        row['cases'] = ['built_ins/list/reverse/projections/rab_initial', 'built_ins/list/reverse/projections/rab_shrunk']
        row['assertions'] = [{'case': row['cases'][0], 'field': 'value', 'expected': [6, 4, 2, 0]}, {'case': row['cases'][1], 'field': 'value', 'expected': [4, 2, 0]}]
        row['partial_observations'] = [{'line': 33, 'input': [0, 2, 4, 6], 'scope': '仅初始全长稠密反序'}, {'line': 82, 'input': [0, 2, 4], 'scope': '仅缩到三后的length-tracking稠密反序'}]

    reviews.append(row)
    evidence.append({**entry, '结论': 'excluded', '逐份理由': row['reason'], '局部观察': row.get('partial_observations', [])})

target = directory / '草稿/packages/test/upstream/reviews/built_ins/array/reverse_remaining.jsonl'
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in reviews))
(directory / '逐份审阅.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print('17 complete-file excluded drafts with explicit partial projections written')
