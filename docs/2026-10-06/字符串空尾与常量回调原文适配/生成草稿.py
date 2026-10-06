import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
baseline = 'b7f882cc'
sources = ['src/generate_addition_strings.ts', 'src/generate_collections.ts', 'src/collection_programs.ts', 'src/models/collections.ts']
sources += ['src/shared/catalog.ts', 'src/shared/json.ts']
sources += ['tests/language/expressions/addition/explicit_strings.zx', 'tests/language/expressions/addition/explicit_strings.jsonl']
sources += ['tests/built_ins/list/' + operation + '/i64' + suffix for operation in ['map_true', 'filter_true'] for suffix in ['.zx', '.jsonl']]

for name in sources:
    target = draft / 'packages/test' / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(subprocess.check_output(['git', 'show', baseline + ':packages/test/' + name], cwd=root))

addition = draft / 'packages/test/src/generate_addition_strings.ts'
text = addition.read_text()
needle = "['e', '\\u0301']]"
assert text.count(needle) == 1
addition.write_text(text.replace(needle, "['e', '\\u0301'], ['lego', '']]"))
collections = draft / 'packages/test/src/generate_collections.ts'
text = collections.read_text()
needle = "values = [[], [0n], [-1n, 1n], [1n, 2n, 3n, 4n, 5n]]"
assert text.count(needle) == 1
collections.write_text(text.replace(needle, "values = [[], [0n], [-1n, 1n], [1n, 2n, 3n, 4n, 5n], [11n]]"))

reasons = {
    'S15.5.4.6_A10': '检查内建函数自身length属性、不可写属性及写入后值，ZX无动态函数对象和属性描述符。',
    'S15.5.4.6_A11': '检查内建函数的自身length属性及精确形参数量1，静态调用接口不发布JS函数反射。',
    'S15.5.4.6_A1_T1': '使用boxed Number接收者、动态挂载concat和bool实参隐式ToString，不能缩成已有显式文本拼接。',
    'S15.5.4.6_A1_T10': '对象toString/valueOf优先级、多个实参隐式转换和提升的undefined变量共同构成完整观察。',
    'S15.5.4.6_A1_T2': 'boxed Boolean接收者、动态方法挂载和true+1隐式数值运算不属于静态ZX契约。',
    'S15.5.4.6_A1_T5': '函数调用得到字符串后隐式将null转成文本null；不能预先替换null为字符串裁掉转换。',
    'S15.5.4.6_A1_T6': 'new String接收者、var提升及undefined实参ToString均为JS动态协议。',
    'S15.5.4.6_A1_T7': 'String动态转换和undefined实参ToString无对应静态原始值入口。',
    'S15.5.4.6_A1_T8': 'String(42)与void 0得到undefined后参与隐式文本转换，不能只登记42undefined字面量。',
    'S15.5.4.6_A1_T9': 'boxed Number文本接收者和无返回函数得到undefined再转文本，不能删掉转换路径。',
    'S15.5.4.6_A2': 'boxed Number动态接收者与128个实参的逐个隐式ToString和可变参数方法调用；完整文件不能简化为预制字符串拼接。',
    'S15.5.4.6_A3': 'new String对象接收者在调用后通过宽松比较转成原始文本，检查不可变性同时依赖boxed对象与隐式转换。',
    'S15.5.4.6_A4_T1': '自定义接收者toString和undefined实参的转换顺序，没有相应JS动态方法分派。',
    'S15.5.4.6_A4_T2': '通过Function.call选择接收者并观察接收者toString抛错优先于实参toString；不等同于普通显式函数错误传播。',
    'S15.5.4.6_A6': '检查内建函数没有prototype属性且读取结果是undefined，ZX无函数对象原型反射。',
    'S15.5.4.6_A7': '以动态内建函数作为new目标并观察运行时不可构造异常，ZX静态构建拒绝不能替代该观察。',
    'S15.5.4.6_A8': '检查函数length自身属性、propertyIsEnumerable和for-in枚举，需完整JS属性协议。',
    'S15.5.4.6_A9': '删除内建函数length后观察成功及自身属性消失，普通静态类型字段不支持delete协议。',
    'name': '检查函数name的值及writable/enumerable/configurable属性描述符，无静态函数反射对应。',
    'not-a-constructor': 'Reflect.construct判定和new调用的运行时TypeError同时被观察，不能改成静态语法错误。',
    'this-value-not-obj-coercible': '观察内建函数类型及Function.call对null/undefined接收者的RequireObjectCoercible TypeError；没有动态this调用入口。',
}
entries = json.loads((directory / '原文metadata.json').read_text())
reviews = {'string/concat': [], 'list/map_unused_parameter': [], 'list/filter_unused_parameter': []}
for entry in entries:
    path = entry['path']
    row = {key: entry[key] for key in ['path', 'sha256']}
    stem = Path(path).stem
    if stem == 'S15.5.4.6_A1_T4':
        case = 'language/expressions/addition/explicit_strings/10'
        row.update(status='adapted', reason='完整保留无实参拼接的原始lego结果；适配为已有普通字符串模板拼接的显式空尾输入，不声称JS原型方法、动态接收者或一般可变参数调用。', contract='packages/test/tests/language/expressions/addition/explicit_strings.zx；packages/genz/src/zx/templates.zig', cases=[case], assertions=[{'case': case, 'field': 'value', 'expected': 'lego'}])
        reviews['string/concat'].append(row)
    elif '/String/' in path:
        row.update(status='excluded', reason=reasons[stem], contract='packages/core/IR契约.md 数值与所有权契约；packages/compiler/src/zx/analysis/calls.zig 静态函数与list调用边界', cases=[])
        reviews['string/concat'].append(row)
    else:
        operation = Path(path).parent.name
        case = 'built_ins/list/' + operation + '_true/i64/items_p11'
        expected = [True] if operation == 'map' else [11]
        row.update(status='adapted', reason='原文零形式参数回调忽略所有实参且只返回true；适配为现有显式但未使用的item回调，完整保留结果观察。map保留第0项true；filter同时保留长度1及第0项11。不声明零形参lambda、JS函数length/arguments/this或稀疏数组协议。', contract='packages/test/tests/built_ins/list/' + operation + '_true/i64.zx；packages/compiler/src/zx/analysis/transforms.zig 显式单参数无捕获回调', cases=[case], assertions=[{'case': case, 'field': 'value', 'expected': expected}])
        reviews['list/' + operation + '_unused_parameter'].append(row)

assert len(reasons) == 21 and sum(len(rows) for rows in reviews.values()) == 24
for name, rows in reviews.items():
    target = draft / 'packages/test/upstream/reviews/built_ins' / (name + '.jsonl')
    assert not (root / target.relative_to(draft)).exists()
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in rows))

print('Prepared two generator edits and 24 full-file reviews; run both draft generators before synchronizing catalogs')
