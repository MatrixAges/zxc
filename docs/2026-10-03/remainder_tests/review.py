from pathlib import Path
import hashlib
import json

root = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
base = 'test/language/expressions/modulus/'
local = 'language/expressions/modulus/f64/'
common = ['nan', 'positive_zero', 'negative_zero', 'positive_infinity', 'negative_infinity', 'positive_max_finite', 'positive_min_subnormal', 'positive_one']
zeros = ['positive_zero', 'negative_zero']
ones = ['positive_one', 'negative_one']
infs = ['positive_infinity', 'negative_infinity']
maxima = ['positive_max_finite', 'negative_max_finite']
minimum = ['positive_min_subnormal', 'negative_min_subnormal']

rules = [
    ('T1.1', [('nan', x) for x in common], '原文八个 NaN 被除数组合全部以实际 f64 余数验证。'),
    ('T1.2', [(x, 'nan') for x in common], '原文八个 NaN 除数组合全部以实际 f64 余数验证。'),
    ('T2', [(a,b) for a in ones for b in ones] + [(a,b) for a in ['positive_hundred_one','negative_hundred_one'] for b in ['positive_fifty_one','negative_fifty_one']], '原文四个单位数余数符号零及四个 101/51 符号组合；位模式直接区分零的符号，等价于原文倒数符号断言。'),
    ('T3', [(a,b) for a in infs for b in infs+ones+maxima], '原文十二个无穷被除数组合，结果 NaN。'),
    ('T4', [(a,b) for a in zeros+ones+infs+['positive_min_subnormal','positive_max_finite'] for b in zeros], '原文十六个零除数组合，结果 NaN。'),
    ('T5', [(a,b) for a in ones+zeros+maxima+minimum for b in infs], '原文十六个有限被除数与无穷除数组合，原值及零符号按位保持。'),
    ('T6', [(a,b) for a in zeros for b in ones+['positive_max_finite','positive_min_subnormal']], '原文八个零被除数与有限非零除数组合，位模式直接核对零符号。'),
]
rows=[]
for suffix, pairs, reason in rules:
    path=base+'S11.5.3_A4_'+suffix+'.js'
    rows.append({'path':path,'sha256':hashlib.sha256((root/path).read_bytes()).hexdigest(),'status':'equivalent','reason':reason+' 宿主位模式输入保留 Number 数值语义，不声称原样执行 JS。','contract':'packages/zx/IR契约.md#数值','cases':[local+a+'/'+b for a,b in pairs]})
Path('packages/test/upstream/reviews/language/expressions/modulus.jsonl').write_text(''.join(json.dumps(x,ensure_ascii=False,separators=(',',':'))+'\n' for x in rows))
