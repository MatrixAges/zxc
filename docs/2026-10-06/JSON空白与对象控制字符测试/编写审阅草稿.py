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

assert len(entries) == 19 and len(cases) == 372
assert original['observed_json_parse_calls'] == 688
reviews = []
evidence = []
linked = set()
prefix = 'built_ins/json/parse/lexical/'

for entry in entries:
    name = Path(entry['path']).stem
    assert hashlib.sha256((upstream / entry['path']).read_bytes()).hexdigest() == entry['sha256']

    if name.startswith('15.12.2-2-'):
        group = int(name.rsplit('-', 1)[1])
        case_prefix = prefix + 'object_controls/2_' + str(group) + '/'
        associated = [case for case in cases if case['id'].startswith(case_prefix)]
        expected_count = 32

        if group in (3, 5):
            reason = '完整保留32个控制字符拼接；原文未加引号的 key 在控制字符前已非法，不宣称 scanner 已读到该控制字符。'
        elif group in (8, 10):
            reason = '完整保留32个控制字符拼接；原文未加引号的 value 在控制字符前已非法，不宣称 scanner 已读到该控制字符。'
        elif group in (1, 2, 4):
            reason = '完整保留32个 key 原始文本；raw control 在完整 key token 扫描前触发 SyntaxError，不能由 UnknownField 替代。'
        else:
            reason = '完整保留32个 value 原始文本；合法 name 字段匹配后，raw control 必须触发 SyntaxError，不能由 schema 错误替代。'

        reason += ' U+0000由Wasm内存入口完整执行；native/WASI的argv传输限制分别记为未执行。另有独立合法同schema控制，不计上游观察。'
    elif name == 'invalid-whitespace':
        associated = [case for case in cases if case['id'].startswith(prefix + 'whitespace/invalid_')]
        expected_count = 16
        reason = '保留全部16个原文Unicode前缀与ASCII数字1；每条必须精确拒绝为SyntaxError。'
    else:
        number = int(name.rsplit('-', 1)[1])
        associated = [case for case in cases if case['id'] == prefix + 'whitespace/0_' + str(number)]
        expected_count = 1
        reason = {
            1: '保留12与34之间全部TAB/CR/LF/SP；两个数字token必须拒绝。',
            2: 'VT不是JSON空白，原始VT加1234必须拒绝。',
            3: 'FF不是JSON空白，原始FF加1234必须拒绝。',
            4: 'NBSP不是JSON空白，原始NBSP加1234必须拒绝。',
            5: 'U+200B不是JSON空白，原始字符加1234必须拒绝。',
            6: 'BOM不是JSON空白，原始BOM加1234必须拒绝。',
            8: 'U+2028与U+2029组合后接1234，是原文一次完整观察；不能拆成两个上游观察。',
            9: '完整保留对象、异构数组与每个原始TAB/CR/SP/LF位置。原文只要求解析成功；输出值严格比较是额外本地断言。',
        }[number]

    executions = [result for result in original['results'] if result['path'] == entry['path']]
    assert len(executions) == 2 and {result['strict'] for result in executions} == {False, True}
    assert all(result['passed'] for result in executions)
    observations = executions[0]['observations']
    assert observations == executions[1]['observations']
    assert len(associated) == len(observations) == expected_count
    proofs = []

    for case, observation in zip(associated, observations):
        assert case['json_text'] == observation['json_text']
        assert case['expected'] == observation['expected']
        raw = case['json_text'].encode('utf-8')
        assert raw.hex() == observation['input_utf8_hex']
        assert case['id'] not in linked
        linked.add(case['id'])
        proofs.append({'case': case['id'], 'input_utf8_hex': raw.hex(), 'input_sha256': hashlib.sha256(raw).hexdigest(), 'original_expected': observation['expected'], 'application_expected': case['expected'], 'argv_transportable': b'\x00' not in raw})

    reason += ' 适配正式有类型JSON应用入口，不新增JS全局函数或异常对象。'
    row = {key: entry[key] for key in ('path', 'sha256')}
    row.update(status='adapted', reason=reason, contract='packages/cli/README.md 非void Input单JSON参数及Wasm/WASI入口；docs/2026-10-06/JSON空白与对象控制字符测试计划.md', cases=[case['id'] for case in associated])
    row['assertions'] = [{'case': case['id'], 'field': next(iter(case['expected'])), 'expected': next(iter(case['expected'].values()))} for case in associated]
    row['input_observations'] = proofs
    reviews.append(row)
    evidence.append({**entry, '完整观察数': len(proofs), '结论草稿': 'adapted', '逐份理由': reason, '观察': proofs})

assert len(linked) == 344
controls = [case for case in cases if case['id'] == prefix + 'object_controls/valid']
assert len(controls) == 1 and controls[0]['id'] not in linked
target = directory / '草稿/packages/test/upstream/reviews/built_ins/json/whitespace_controls.jsonl'
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in reviews))
(directory / '逐份审阅.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print('19 complete-file adapted drafts; 344 exact original observations; 1 independent positive control')
