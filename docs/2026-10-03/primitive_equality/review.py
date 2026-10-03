from pathlib import Path
import hashlib
import json

root=Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
local=Path('packages/test/tests/language/expressions/comparison')
bools=[json.loads(x) for x in (local/'bool.jsonl').read_text().splitlines()]
strings=[json.loads(x) for x in (local/'string_upstream.jsonl').read_text().splitlines()]
empty=next(json.loads(x) for x in Path('packages/test/tests/built_ins/string/values/cases.jsonl').read_text().splitlines() if json.loads(x)['input']=={'left':'','right':''})
rows=[]
for directory,version,operator,strict in [
    ('equals','11.9.1','==',False),
    ('does-not-equals','11.9.2','!=',False),
    ('strict-equals','11.9.4','===',True),
    ('strict-does-not-equals','11.9.5','!==',True),
]:
    for category in ['bool','string']:
        suffix=('A3' if category=='bool' else 'A5')+('' if strict else '.1')
        path=f'test/language/expressions/{directory}/S{version}_{suffix}.js'
        cases=bools if category=='bool' else [empty]+([strings[i] for i in [0,2,3,4]] if strict else strings)
        assertions=[]
        for case in cases:
            left=json.dumps(case['input']['left'],ensure_ascii=False)
            right=json.dumps(case['input']['right'],ensure_ascii=False)
            assertions.append({'expression':f'{left} {operator} {right}','case':case['id'],'field':'value','expected':case['expected']['value']})
        rows.append({'path':path,'sha256':hashlib.sha256((root/path).read_bytes()).hexdigest(),'status':'equivalent','reason':f'完整关联原文 {len(cases)} 项同类型'+('布尔' if category=='bool' else '原始字符串')+'比较，ZX ==/!= 保留这些具体结果；严格运算符拼写按 ZX 同类型比较表达，不引入动态类型或强制转换。空串输入复用已有真实执行案例。','contract':'packages/zx/IR契约.md#表达式与求值','cases':[c['id'] for c in cases],'assertions':assertions,'diagnostics':[]})
for row in rows:
    if '_A3' in row['path']:
        row['reason']=row['reason'].replace('空串输入复用已有真实执行案例。','')
Path('packages/test/upstream/reviews/language/expressions/primitive_equality.jsonl').write_text(''.join(json.dumps(x,ensure_ascii=False,separators=(',',':'))+'\n' for x in rows))
