# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
directory = Path(__file__).resolve().parent
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
entries = [json.loads(line) for line in (directory / '待审文件.jsonl').read_text().splitlines()]
original = json.loads((directory / '原文结果.json').read_text())
cases = []

for path in (root / 'packages/test/tests/built_ins/json/parse/lexical').glob('*.jsonl'):
    cases.extend(json.loads(line) for line in path.read_text().splitlines())

assert len(entries) == 23 and len(cases) == 27
assert original['observed_json_parse_calls'] == 54
reasons = {
    'g2-1': '原始双引号文本 22 61 62 63 22 解码为 abc，正式 JSON 输出解码后与准确字符串值比较。',
    'g2-2': '原始单引号文本 27 61 62 63 27 必须拒绝，不用 ZX 字符串字面量解析代替 JSON 输入。',
    'g2-3': '引号外字面反斜杠 u0022 不能构成 JSON 字符串边界；保留完整原始文本并准确拒绝。',
    'g2-4': '原文 22 61 62 63 27 缺少终止双引号，保留拒绝行为；JS SyntaxError 显式对应 ZX/Zig UnexpectedEndOfInput，不声称异常对象或分类完全相同。',
    'g2-5': '原始两个双引号必须接受并得到空字符串；不能把空业务字符串混同零字节输入。',
    'g5-1': 'JSON 字符串内四位 Unicode 转义 u0058 解码为 X，输入反斜杠与结果字节 58 均准确保留。',
    'g5-2': 'u005 只有三位 hex，但原始输入仍有末尾引号；在第四位 hex 位置拒绝为 SyntaxError，不改为输入结束错误。',
    'g5-3': 'Unicode 转义 u0X50 中 X 非 hex，保留原始非法输入并准确拒绝。',
    'g6-1': '合法 JSON 转义反斜杠 slash 解码为单个 slash，比较结果值而不强制输出编码排版。',
    'g6-2': '合法双反斜杠转义解码为一个反斜杠，准确保留输入及结果字节 5c。',
    'g6-3': '合法 b 转义解码为单个退格字符，结果字节为 08。',
    'g6-4': '合法 f 转义解码为单个换页字符，结果字节为 0c。',
    'g6-5': '合法 n 转义解码为单个 LF，结果字节为 0a。',
    'g6-6': '合法 r 转义解码为单个 CR，结果字节为 0d。',
    'g6-7': '合法 t 转义解码为单个 TAB，结果字节为 09。',
}
reviews = []
evidence = []
linked = set()

for entry in entries:
    code = Path(entry['path']).stem.removeprefix('15.12.1.1-')
    assert hashlib.sha256((upstream / entry['path']).read_bytes()).hexdigest() == entry['sha256']
    prefix = 'built_ins/json/parse/lexical/' + code.replace('-', '_')
    associated = [case for case in cases if case['id'] == prefix or case['id'].startswith(prefix + '/')]
    executions = [result for result in original['results'] if result['path'] == entry['path']]
    assert len(executions) == 2 and {result['strict'] for result in executions} == {False, True}
    assert all(result['passed'] for result in executions)
    observations = executions[0]['observations']
    assert observations == executions[1]['observations']
    assert len(associated) == len(observations) == (2 if code.startswith('g1-') else 1)
    proofs = []

    for case, observation in zip(associated, observations):
        assert case['json_text'] == observation['json_text']
        raw = case['json_text'].encode('utf-8')
        assert raw.hex() == observation['input_utf8_hex']

        if 'value' in observation['expected']:
            assert case['expected'] == observation['expected']
        else:
            assert observation['expected'] == {'error': 'SyntaxError'}
            assert case['expected'] == {'error': 'UnexpectedEndOfInput' if code == 'g2-4' else 'SyntaxError'}

        proofs.append({'case': case['id'], 'input_utf8_hex': raw.hex(), 'input_sha256': hashlib.sha256(raw).hexdigest(), 'original_expected': observation['expected'], 'application_expected': case['expected'], 'argv_transportable': b'\x00' not in raw})
        assert case['id'] not in linked
        linked.add(case['id'])

    if code.startswith('g1-'):
        name = ('TAB', 'CR', 'LF', 'SP')[int(code[-1]) - 1]
        reason = name + ' 在数字前是合法 JSON 空白并得到 1234，但在 12 与 34 之间形成两个 token，必须准确拒绝。两个原文观察全部保留，未删除负例。'
    elif code.startswith('g4-'):
        index = int(code[-1]) - 1
        reason = f'原始 U+{index * 8:04X}..U+{index * 8 + 7:04X} 八个控制字符组成的单个 JSON 字符串必须拒绝；完整组合原样传输，不再次编码、不拆成八个原文观察。'
        if any(not proof['argv_transportable'] for proof in proofs):
            reason += ' 含真实 NUL，Wasm 全部字节执行；native/WASI 的 argv 无法传输，分别显式记录未执行的目标观察。'
    else:
        reason = reasons[code]

    reason += ' 适配为正式生成的有类型 JSON 应用入口，不新增全局 JSON.parse 或 JS 异常对象。'
    row = {key: entry[key] for key in ('path', 'sha256')}
    row.update(status='adapted', reason=reason, contract='packages/cli/README.md 非void Input单JSON参数及Wasm/WASI入口；docs/2026-10-05/WASM参考.md；docs/2026-10-06/JSON输入词法测试计划.md', cases=[case['id'] for case in associated])
    row['assertions'] = [{'case': case['id'], 'field': next(iter(case['expected'])), 'expected': next(iter(case['expected'].values()))} for case in associated]
    row['input_observations'] = proofs
    reviews.append(row)
    evidence.append({**entry, '完整观察数': len(proofs), '结论草稿': 'adapted', '逐份理由': reason, '观察': proofs})

assert len(linked) == 27
target = directory / '草稿/packages/test/upstream/reviews/built_ins/json/lexical.jsonl'
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in reviews))
(directory / '逐份审阅.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print('23 complete-file adapted drafts; 27 exact original payloads and observations verified')
