import hashlib
import json
from pathlib import Path
import shutil
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
review_path = Path('packages/test/upstream/reviews/built_ins/json/stringify.jsonl')
reference = json.loads((directory / '原文结果.json').read_text())
numeric = json.loads((directory / '数值原文结果.json').read_text())
audit = json.loads((directory / '覆盖审计.json').read_text())
closure = json.loads((directory / '家族闭合.json').read_text())
entries = [json.loads(line) for line in (directory / '待审文件.jsonl').read_text().splitlines()]
reviews = [json.loads(line) for line in (root / review_path).read_text().splitlines()]

assert len(entries) == len(reviews) == reference['files'] == 66
assert reference['json_stringify_replaced'] is False
assert len(reference['results']) == 132
assert all(row['passed'] and row['error'] is None for row in reference['results'])
assert {(row['path'], row['strict']) for row in reference['results']} == {(row['path'], mode) for row in entries for mode in [False, True]}
assert (root / review_path).read_bytes() == (directory / '草稿' / review_path).read_bytes()
assert all(row['status'] == 'excluded' and not row['cases'] for row in reviews)
assert {row['path']: row['sha256'] for row in entries} == {row['path']: row['sha256'] for row in reviews}

for row in entries:
    assert hashlib.sha256((upstream / row['path']).read_bytes()).hexdigest() == row['sha256']

for harness in reference['harness']:
    assert hashlib.sha256((upstream / 'harness' / harness['name']).read_bytes()).hexdigest() == harness['sha256']

assert len(numeric['results']) == 6
observations = [row for group in numeric['results'] for row in group['observations']]
assert len(observations) == 18 and not any(row['matches_test262'] for row in observations)
commands = [row for group in numeric['results'] for row in group['commands']]
assert len(commands) == 30
assert sum(row['status'] == 0 for row in commands) == 24
assert sum(row['status'] == 1 for row in commands) == 6
assert all(row['signal'] is None and row['error'] is None for row in commands)

for group in numeric['results']:
    assert len(group['observations']) == len(group['artifacts']) == 3
    path = directory / (group['definition']['name'] + '.zx')
    assert hashlib.sha256(path.read_bytes()).hexdigest() == group['source_sha256']
    assert {row['target'] for row in group['observations']} == {'native', 'wasm32-wasi', 'wasm32-freestanding'}
    for row in group['observations']:
        assert row['raw_utf8_hex'] == row['response']['output'].encode().hex()

assert audit['catalog_cases'] == 80585 and audit['linked_cases'] == 5314
assert audit['reviewed'] == {'adapted': 732, 'excluded': 1784, 'equivalent': 103}
assert audit['unreviewed'] == 50978
assert closure['matched_unreviewed'] == 0 and not Path('/tmp/zxc-json-stringify-pending.txt').read_bytes()
compiler = Path(numeric['compiler'])
assert hashlib.sha256(compiler.read_bytes()).hexdigest() == numeric['compiler_sha256']
assert compiler.as_posix() == json.loads((directory.parent / 'JSON输出数值边界回归/Debug/application-json-output-scalar.txt').read_text())['commands'][0]['command']

for source, target in [('/tmp/zxc-json-stringify-original.log', '原文执行日志.txt'), ('/tmp/zxc-json-stringify-numeric.log', '数值执行日志.txt')]:
    shutil.copyfile(source, directory / target)

fingerprint_paths = [root / review_path, root / 'packages/cli/README.md', root / 'packages/genz/src/host/json_output.zig', root / 'packages/compiler/src/zx/frontend/parser/types/field.zx', root / 'packages/test/tests/targets/application_json/fixture.ts', root / 'packages/test/tests/targets/wasm/host.ts']
fingerprint_paths += [path for path in directory.rglob('*') if path.is_file() and path.name != '执行结果.json' and path.suffix not in ['.md']]
fingerprints = {str(path.relative_to(root)): hashlib.sha256(path.read_bytes()).hexdigest() for path in fingerprint_paths}
result = {
    'IDEA': {'Intent': '完整审阅JSON.stringify原文，不删除关键观察', 'Data': '66份原文SHA、132次Node参考及18次ZX输出边界核验', 'Edges': '不宣称Node通过即ZX通过，不以解析值替代精确文本，不为JS对象模型引入运行库', 'Answer': '66份逐份excluded理由、家族未审阅0、完整原始输出与来源指纹'},
    '主检出提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip(),
    '数值编译器生产基线': 'e5d21277aa29e1d647887a931cf470e52e1bf13c',
    '数值编译器SHA256': numeric['compiler_sha256'],
    '原样Node参考执行': {'实际执行': 132, '通过': 132, '退出码': 0, 'ZX通过数': 0},
    '数值完整原文观察': {'文件': 2, '核心观察': 6, '普通应用': 6, '三目标实际观察': 18, '与原文精确文本相同': 0, '进程命令': 30, '编译产物': 18, 'Wasmmemory调用': 6, '退出码': 0},
    '家族审阅': {'完整文件': 66, '新增excluded': 66, '未审阅': 0, '新ZX案例': 0, '完全JS兼容': False},
    '审计': audit,
    '来源SHA256': fingerprints,
    '自我批判': 'excluded只记录当前完整适配边界，不是通过，不是永久不需要实现。两份数值原文能够由普通typed应用表达，分类依据是精确输出契约差异。其余64份保留反射、回调、PropertyList、Proxy、盒装、循环、动态key、undefined或孤立surrogate观察。原文全部读取，普通/严格运行未替换JSON.stringify。应用业务逻辑仅恒等或普通除法与容器构造，未按输入、文件名或目标返回预期文本。数值核验仅Debug三目标；ReleaseSafe四目标的非有限与负零既有正式回归另有独立证据，不把其数目重复计入本部分。',
}
(directory / '执行结果.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')

lines = ['# JSON字符串化完整原文审阅结论', '', '## IDEA', '', 'Intent：保留全部原文关键观察，完成当前公开契约边界审阅。', '', 'Data：66份固定原文及SHA；132次原样Node参考执行全部通过；六个普通ZX应用的18次三目标实际观察。', '', 'Edges：Node不是ZX。excluded不是通过。数值两份可以完整表达，但精确文本或非有限输出政策与JS不同。', '', 'Answer：66份逐份审阅已登记，家族未审阅为0；没有新增可执行适配案例，也没有新增JS兼容通过声明。', '', '## 实际数值文本', '', '| 观察 | JS要求 | 三目标实际结果 |', '| --- | --- | --- |', '| 标量-0 | 0 | -0 |', '| 混合tuple | ["-0",0,0] | ["-0",0,-0] |', '| 固定key对象-0 | {"key":0} | {"key":-0} |', '| Infinity | null | NonFiniteJsonNumber |', '| 对象-Infinity | {"key":null} | NonFiniteJsonNumber |', '| 数组NaN | [null] | NonFiniteJsonNumber |', '', 'native/WASI成功输出只移除协议追加的一个LF；Wasm直接比较完整result。非有限native/WASI错误stdout均为空，Wasm status=1且结果是错误名。原始字节、status、stderr、构建命令和18个产物SHA保留在数值原文结果.json。', '', '## 逐份完整边界', '', '| 原文 | 当前完整适配边界 |', '| --- | --- |']
lines += ['| ' + Path(row['path']).name + ' | ' + row['reason'].replace('|', '\\|') + ' |' for row in reviews]
lines += ['', '## 自我批判', '', result['自我批判'], '', '审计目录仍有50,978份上游原文未审阅；原始全量目标继续，不把本家族审阅闭合等同于Test262对齐完成。', '']
(directory / '审阅结论.md').write_text('\n'.join(lines))
print('Verified 132 unchanged reference runs and 18 real typed observations; 66 excluded decisions; no fabricated passes')
