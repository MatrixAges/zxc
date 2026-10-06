# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
directory = Path(__file__).resolve().parent
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
entries = [json.loads(line) for line in (directory / '待审文件.jsonl').read_text().splitlines()]
original = json.loads((directory / '原文结果.json').read_text())

assert len(entries) == 35 and len(original['results']) == 70
assert original['json_parse_replaced'] is False
assert all(row['passed'] and row['error'] is None for row in original['results'])

reasons = {
    'S15.12.2_A1': '文本{"__proto__":[]}同时要求Object.prototype原型和own __proto__数组；静态字段及序列化结果不能保留JS对象原型观察。',
    'builtin': '完整五项函数对象观察包含可扩展性、typeof function、[object Function]、Function.prototype原型及无own prototype；正式typed输入解析入口没有对应JS全局函数对象。',
    'duplicate-proto': '文本{ "__proto__": 1, "__proto__": 2 }要求最后字段值2；生产JSON入口只设alloc_always，Zig默认DuplicateField。此为显式契约差异，不能改测试ParseOptions为use_last冒充生产入口符合。',
    'length': 'JSON.parse.length必须为2且descriptor为writable=false、enumerable=false、configurable=true；这些是全局内建函数反射，文本输入解析不能替代。',
    'name': 'JSON.parse.name必须为parse且descriptor为writable=false、enumerable=false、configurable=true；现有应用execute不是这个JS内建函数对象。',
    'not-a-constructor': 'isConstructor(JSON.parse)为false，new JSON.parse("{}")须在解析开始前抛TypeError；接受或schema拒绝文本{}均无法替代构造协议。',
    'prop-desc': 'JSON对象的parse属性须writable=true、enumerable=false、configurable=true；现有typed入口不提供JS全局对象属性descriptor。',
    'revived-proxy-revoked': '合法[null, null]在首个reviver注入revoked proxy后抛TypeError，并要求returnCount=1；文本解析拒绝无法保留IsArray及回调完成次数。',
    'revived-proxy': '合法[null, null]重复三次，普通对象proxy的other必须访问，数组proxy及其外层proxy不能访问other；核心是IsArray和reviver遍历，不是最终JSON结构。',
    'reviver-array-define-prop-err': '合法["first", null]由reviver注入数组Proxy，后续defineProperty trap抛Test262Error；typed schema提前拒绝不是相同错误路径。',
    'reviver-array-delete-err': '合法[0,0]由reviver注入数组Proxy，随后deleteProperty trap抛Test262Error；普通文本入口没有该回调及删除协议。',
    'reviver-array-get-prop-from-prototype': '文本[1, 2]的回调删除own 1后读取Array.prototype[1]=3，最终own 1存在且值3，包含删除及清理断言；静态数组值不能替代原型链读取。',
    'reviver-array-length-coerce-err': '合法[0,0]注入array proxy，其length转换对象valueOf抛Test262Error；当前入口不保留reviver期间的Get/ToLength/ToPrimitive。',
    'reviver-array-length-get-err': '合法[0,0]注入array proxy，读取length trap抛Test262Error；输入scanner或schema错误不能替代后续属性访问异常。',
    'reviver-array-non-configurable-prop-create': '文本[1, 2]回调将index 1设non-configurable，再返回22；重定义失败不抛，最终仍1、2。相同恒等值会删除descriptor导致拒绝修改的核心行为。',
    'reviver-array-non-configurable-prop-delete': '文本[1, 2]的non-configurable index 1回调返回undefined，删除失败不抛，own 1仍有值2；恒等结果不能证明Delete及own属性约束。',
    'reviver-call-args-after-forward-modification': '两个情境[1,[]]与{"p":1,"q":{}}的前向添加项产生完整四项key/value/source日志；新增值source为undefined，typed恒等入口没有回调顺序及原始source。',
    'reviver-call-err': '文本0本身合法，reviver主动抛Test262Error；把0改成不匹配Input导致解析错误会删除callback异常语义。',
    'reviver-call-order': '文本{"p1":0,"p2":0,"p1":0,"2":0,"1":0}要求callback顺序1、2、p1、p2、空根名，包含重复字段合并和整数key排序；普通typed输入没有该过程。',
    'reviver-context-source-array-literal': '四个情境[1.0]、[1.1]、[]及混型嵌套数组，不仅检查结果，还验证context类型、Object.prototype、own names/symbols及primitive source完整descriptor；容器不能有source。',
    'reviver-context-source-object-literal': '五个对象情境包含空对象、数字key、普通字段、数组与嵌套对象；完整context/source descriptor以及own names/symbols都必须保留，仅最终typed结构相同不足。',
    'reviver-context-source-primitive-literal': '十四个情境包含正负数、e/E与显式正负指数、null、bool及字符串；逐次验证context原型、own names/symbols及source descriptor，数值重序列化会丢掉原始拼写。',
    'reviver-forward-modifies-object': '十个情境含四种replacement各用于数组/对象以及两种连续前向改写；必须保留遍历key、改写后的value/source与对象身份。原文key===5未执行分支不能算覆盖；结构序列化不是sameValue身份。',
    'reviver-get-name-err': '合法[0,0]首个reviver安装index 1 getter，后续holder属性Get抛Test262Error；提前schema拒绝不能保留getter异常。',
    'reviver-object-define-prop-err': '合法["first", null]的reviver注入普通对象Proxy，defineProperty trap抛Test262Error；当前应用入口没有复活属性协议。',
    'reviver-object-delete-err': '合法[0,0]的reviver注入普通对象Proxy，deleteProperty trap抛Test262Error；普通输入解析不是该异常路径。',
    'reviver-object-get-prop-from-prototype': '文本{"a": 1, "b": 2}回调删除own b后读取Object.prototype.b=3，最终own b存在且值3，含删除与清理断言；typed字段不能保留原型链访问。',
    'reviver-object-non-configurable-prop-create': '文本{"a": 1, "b": 2}的b变non-configurable，回调返回22，重定义失败但不抛，最终b=2；恒等输出相同不是descriptor协议覆盖。',
    'reviver-object-non-configurable-prop-delete': '文本{"a": 1, "b": 2}的non-configurable b回调返回undefined，删除失败但不抛，own b仍存在且值2；不能丢掉callback和Delete观察。',
    'reviver-object-own-keys-err': '合法[0,0]的reviver注入object Proxy，其ownKeys trap抛Test262Error；不是输入词法拒绝。',
    'reviver-wrapper': '文本2捕获reviver的this wrapper，验证可扩展普通对象、Object.prototype、唯一own空字符串key和完整descriptor，不能触发prototype setter。回调不返回值，不能误登记结果2。',
    'text-negative-zero': '完整五次观察：四个带不同空白的字符串-0结果为负零，第五个数值参数-0经ToString结果为正零。只做四个文本或用JSON.stringify抹掉符号都无法完成整份。',
    'text-non-string-primitive': '完整八种调用包含无参数/undefined的SyntaxError、null/bool/0/3.14经ToString成功以及Symbol的TypeError；文本输入已省略了本文件核心转换。',
    'text-object-abrupt': '两个对象参数分别在valueOf getter及toString调用抛Test262Error，均早于文本解析；提供转换后的文本不能保留Get/Call异常。',
    'text-object': '对象toString返回"string"而valueOf返回"default_or_number"，结果必须为string以验证转换优先级；提前提供已转换文本会删除核心行为。',
}

assert set(reasons) == {Path(row['path']).stem for row in entries}
reviews = []
proofs = []

for entry in entries:
    assert hashlib.sha256((upstream / entry['path']).read_bytes()).hexdigest() == entry['sha256']
    executions = [row for row in original['results'] if row['path'] == entry['path']]
    assert len(executions) == 2 and {row['strict'] for row in executions} == {False, True}
    reason = reasons[Path(entry['path']).stem]
    row = {key: entry[key] for key in ('path', 'sha256')}
    row.update(status='excluded', reason=reason + ' 当前完整文件不适配，不声称JS兼容通过。', contract='packages/cli/README.md 非void Input单JSON参数及Wasm/WASI入口；packages/genz/src/host/cli/input.zig；packages/genz/src/host/wasm/json.zig；docs/2026-10-06/JSON剩余原文边界审阅计划.md', cases=[])
    reviews.append(row)
    proofs.append({**entry, '完整原文结论': 'excluded', '逐份理由': reason, '原样参考执行': executions, '新增ZX案例': 0})

target = directory / '草稿/packages/test/upstream/reviews/built_ins/json/remaining.jsonl'
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in reviews))
(directory / '逐份审阅.json').write_text(json.dumps(proofs, ensure_ascii=False, indent=2) + '\n')
lines = ['# 逐份审阅结论', '', '35份完整原文；70次原样Node参考执行全部通过。新增ZX案例为0，excluded不计兼容通过。', '', '| 文件 | 完整文件边界 |', '|---|---|']
lines += ['| ' + Path(row['path']).name + ' | ' + reasons[Path(row['path']).stem] + ' |' for row in entries]
(directory / '逐份审阅结论.md').write_text('\n'.join(lines) + '\n')
print('35 complete excluded drafts; 70 unchanged reference executions; 0 added ZX cases')
