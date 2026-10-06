# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import re


directory = Path(__file__).resolve().parent
root = directory.parents[2]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
entries = [json.loads(line) for line in (directory / '待审文件.jsonl').read_text().splitlines()]
reasons = {
    'S11.9.2_A6.1.js': '六项观察包含 undefined 自身、void 与 undefined、eval 无返回值、undefined/null、null/void、null/null。前五项依赖不提供的 undefined、void 运算或动态 eval；仅最后的双 null 子观察可通过显式 optional 上下文保留，不能将文件整体登记等价。',
    'S11.9.2_A6.2_T1.js': '左侧 undefined 分别对 true、0、字符串 undefined 与空对象不等；左侧 null 分别对 false、0、字符串 null 与空对象不等。后四项只在显式 optional 上下文中局部保留；undefined 不可替换成 null，整份观察未适配。',
    'S11.9.2_A6.2_T2.js': '右侧 undefined 分别与 false、NaN、字符串 undefined 与空对象比较；右侧 null 分别与 false、0、字符串 null 与空对象比较，均不等。后四项按真实左右方向局部保留；NaN/undefined 不能以普通 optional 比较替代，整份观察未适配。',
    'S11.9.2_A7.1.js': '八组观察包括分别创建的 Boolean/Number/String/Object 包装对象不等、普通对象 x 的别名 y 与 x 相等，以及不同包装对象不等。第五项确实是普通对象别名，排除原因是完整动态对象身份契约；ZX 聚合一般相等明确不提供，字段或 payload 相等不能替代地址身份。',
    'S11.9.2_A7.2.js': '左侧 Boolean(true)、Number(1)、String(1) 包装对象对右侧 true 均不等为 false，要求先解包装再做抽象相等的布尔/数字/字符串转换。ZX 不提供该隐式协议；同型标量比较会删除原始观察。',
    'S11.9.2_A7.3.js': 'true 位于左侧，右侧 Boolean(true)、Number(1)、String(+1) 包装对象均不等为 false。操作数方向与字符串 +1 都是实际观察，不能以 A7.2 或普通 bool 相等替代对象转换。',
    'S11.9.2_A7.4.js': '左侧 Boolean(true)、Number(-1)、String(-1) 包装对象对右侧 1/-1/-1 均不等为 false。需要对象解包和数值隐式转换，不属于 ZX 固定同型比较契约。',
    'S11.9.2_A7.5.js': 'A7.4 的数值在左、包装对象在右，三项不等均 false。仅保留数值相等会移除右侧 ToPrimitive，不能称为另一方向协议已通过。',
    'S11.9.2_A7.6.js': '左侧 Boolean(true)、Number(-1)、String(x) 包装对象对右侧字符串 1/-1/x 均不等为 false。第三项仍需包装 String 解包，前两项还含数字/布尔转换；普通字符串字节比较不保留完整语义。',
    'S11.9.2_A7.7.js': 'A7.6 的字符串在左、包装对象在右，三项均 false。实际转换方向必须保留，ZX 同型 string 比较不实现动态包装对象协议。',
    'S11.9.2_A7.8.js': '实际源码为 primitive 在左、object 在右，与标题方向相反。七个正常比较及两类异常观察 valueOf 优先、成功后跳过 toString、只含 toString 或 valueOf 返回对象时的回退、不同字符串转换、valueOf 抛出原错误、两个方法都返回对象导致 TypeError。ZX 没有动态 ToPrimitive；普通 native 调用轨迹不能替代该协议。',
    'S11.9.2_A7.9.js': '实际源码为 object 在左、primitive 在右，与标题方向相反。包含对应的 valueOf 优先与跳过、toString 回退、两次不同字符串比较、原异常传播和非 primitive 的 TypeError。错误消息分支中的重复表达式不是正常路径新观察；ZX 不提供此动态转换协议。',
    'bigint-and-bigint.js': '35 次 sameValue 比较 BigInt 正负零、正负一、超过安全数范围的相邻整数，以及正负 2^64 和 2^64+1。完整观察需要任意精度整数值；删除 n 或只取 i64 可容纳子集不能保留该文件契约。',
    'bigint-and-boolean.js': '16 次 sameValue 双向比较 -1n/0n/1n/2n 与 false/true，0n 对 false、1n 对 true 不等为 false。需要 Boolean 转数值再与 BigInt 数学值比较，不是同型 bool 或固定整数比较。',
    'bigint-and-incomparable-primitive.js': '12 次 sameValue 双向比较 0n/1n 与 undefined、null、Symbol，均不等。观察抽象相等中类型不可比较的结果；ZX 没有 BigInt、undefined、Symbol，普通 u64/null 不能替代类型身份。',
    'bigint-and-non-finite.js': '18 次 sameValue 双向比较 0n/1n/-1n 与正负 Infinity/NaN，均不等。ZX 具有浮点非有限运算语义，但没有 BigInt/Number 混型比较，普通 NaN 回归不能替代此原文。',
    'bigint-and-number-extremes.js': '10 次 sameValue 包含 1n 对正负 Number.MAX_VALUE，以及最大有限 f64 精确整数值的减一/相等/加一双向比较。三个 1024 位原字面量已用 (2^53-1)*2^971 独立核对；转 f64 会抹掉正负一差异，不得用浮点排列替代。',
    'bigint-and-number.js': '20 次 sameValue 双向保留 0n 对正负零、微小非整数、1n 对近一和一，以及 0n/-10n 对正负最小非零 Number。核心是精确整数数学值与 IEEE64 值的跨域比较，ZX 不提供整数/浮点变量隐式比较。',
    'bigint-and-object.js': '32 次 sameValue 双向观察 BigInt 包装对象、普通空对象、返回 BigInt 的 valueOf、返回字符串的 toString，以及两个超安全范围相邻整数。同时需要 BigInt、动态对象转换与 StringToBigInt；换成 payload 字段比较会删除协议。',
    'bigint-and-string.js': '36 次 sameValue 双向比较空串、正负零/一、无效数值文本及超安全范围的精确整数文本。StringToBigInt 需要空串到零、无效文本产生不等而非解析异常、无损大整数转换；ZX string 字节相等不实现此行为。',
}
contracts = 'packages/compiler/README.md#edges-边界；packages/core/IR契约.md#数值；packages/core/IR契约.md#表达式与求值；docs/zx_design_doc.md §14.3/14.4；docs/2026-10-06/不等表达式目录收尾审阅计划.md'
reviews = []
evidence = []
cases = {}

for name in ('optional/bool', 'optional/f64', 'null_inequality/string', 'null_inequality/empty_object'):
    path = root / ('packages/test/tests/language/expressions/comparison/' + name + '.jsonl')

    for line in path.read_text().splitlines():
        row = json.loads(line)
        cases[row['id']] = row

assert len(entries) == len(reasons) == 20

for entry in entries:
    name = Path(entry['path']).name
    source = (upstream / entry['path']).read_bytes()
    assert hashlib.sha256(source).hexdigest() == entry['sha256']
    text = source.decode()
    row = {key: entry[key] for key in ('path', 'sha256')}
    row.update(status='excluded', reason=reasons[name], contract=contracts, cases=[])

    if name == 'S11.9.2_A6.1.js':
        row['cases'] = ['language/expressions/comparison/optional/f64/0/0']
        row['assertions'] = [{'case': row['cases'][0], 'field': 'different', 'expected': False}]
        row['partial_observations'] = [{'line': 36, 'scope': '仅 null != null，显式 f64? 上下文'}]
    elif name in ('S11.9.2_A6.2_T1.js', 'S11.9.2_A6.2_T2.js'):
        left = name.endswith('T1.js')
        row['cases'] = [
            'language/expressions/comparison/optional/bool/' + ('0/1' if left else '1/0'),
            'language/expressions/comparison/optional/f64/' + ('0/2' if left else '2/0'),
            'language/expressions/comparison/null_inequality/string/value',
            'language/expressions/comparison/null_inequality/empty_object/value',
        ]
        row['assertions'] = [{'case': case, 'field': 'different' if '/optional/' in case else 'left_different' if left else 'right_different', 'expected': True} for case in row['cases']]
        row['partial_observations'] = [{'line': line, 'scope': '仅原值 false/0/字符串null/空对象与 null，显式 optional 上下文'} for line in (31, 36, 41, 46)]

    for assertion in row.get('assertions', []):
        selected = assertion['field']
        assert cases[assertion['case']]['expected']['value'][selected] == assertion['expected']
        assertion['observation_field'] = 'value.' + selected
        assertion['field'] = 'value'
        assertion['expected'] = cases[assertion['case']]['expected']['value']

    reviews.append(row)
    evidence.append({
        **entry,
        '结论': 'excluded',
        '逐份理由': row['reason'],
        '静态sameValue数量': len(re.findall(r'assert\.sameValue\s*\(', text)),
        '部分观察': row.get('partial_observations', []),
    })

target = directory / '草稿/packages/test/upstream/reviews/language/expressions/does_not_equals_remaining.jsonl'
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in reviews))
(directory / '逐份审阅.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')

assert sum(row['静态sameValue数量'] for row in evidence) == 179
print('20 reviewed drafts written; 3 files retain explicit partial null observations')
