import hashlib
import json
from pathlib import Path
import subprocess


directory = Path(__file__).resolve().parent
root = directory.parents[2]
draft = directory / '草稿'
reference = json.loads((directory / '原文结果.json').read_text())
commit = 'a7662c5c'
base = {}
catalogs = {}
mapping = []
new_rows = []


def copy(name):
    source = subprocess.check_output(['git', 'show', f'{commit}:{name}'], cwd=root)
    target = draft / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(source)
    base[name] = hashlib.sha256(source).hexdigest()


def json_lines(rows):
    return ''.join(json.dumps(row, ensure_ascii=True, separators=(',', ':')) + '\n' for row in rows)


for name in ['packages/test/src/generate_querystring.ts', 'packages/test/src/querystring/percent_cases.ts', 'packages/test/src/querystring/parse_cases.ts', 'packages/test/src/shared/catalog.ts', 'packages/test/src/shared/json.ts', 'packages/test/build.zig']:
    copy(name)

for name in subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', commit, 'packages/test/tests/standard/querystring'], cwd=root, text=True).splitlines():
    copy(name)

for operation in ['escape', 'unescape']:
    path = draft / f'packages/test/tests/standard/querystring/{operation}/cases.jsonl'
    catalogs[operation] = [json.loads(line) for line in path.read_text().splitlines()]

for group in reference['results']:
    operation = 'escape' if group['operation'] == 'encodeURIComponent' else 'unescape'
    observations = group['modes'][0]['observations']
    assert group['modes'][1]['observations'] == observations
    links = []
    for observation in observations:
        matches = [row for row in catalogs[operation] if row['input'] == observation['input'] and row['expected']['value'] == observation['value']]
        if not matches:
            suffix = Path(group['path']).stem.split('_', 1)[1].lower()
            name = f'uri_{suffix}_{observation["index"]}'
            row = {'id': f'standard/querystring/{operation}/{name}', 'input': observation['input'], 'expected': {'value': observation['value']}}
            catalogs[operation].append(row)
            new_rows.append({'operation': operation, 'name': name, 'input': observation['input'], 'value': observation['value']})
            matches = [row]
        linked = {'index': observation['index'], 'case': matches[0]['id'], 'input': observation['input'], 'expected': observation['value']}
        links.append(linked)
    mapping.append({'path': group['path'], 'sha256': group['sha256'], 'operation': operation, 'observations': links})

assert len(new_rows) == 35
assert sum(row['operation'] == 'escape' for row in new_rows) == 13
assert sum(len(row['observations']) for row in mapping) == 134
data_path = draft / 'packages/test/src/data/querystring_uri.jsonl'
data_path.parent.mkdir(parents=True, exist_ok=True)
data_path.write_text(json_lines(new_rows))

percent_path = draft / 'packages/test/src/querystring/percent_cases.ts'
percent = percent_path.read_text()
percent = percent.replace("import { escape, unescape } from 'node:querystring'", "import assert from 'node:assert/strict'\nimport { escape, unescape } from 'node:querystring'\nimport { resolve } from 'node:path'\nimport { package_dir } from '../shared/catalog.ts'\nimport { readRows } from '../shared/json.ts'")
needle = '\treturn { escape: encode_rows, unescape: decode_rows }'
assert percent.count(needle) == 1
block = """\tfor (const row of readRows<Case & { operation: 'escape' | 'unescape' }>(
\t\tresolve(package_dir, 'src/data/querystring_uri.jsonl')
\t)) {
\t\tconst { operation, name, input, value } = row
\t\tconst output_rows = operation === 'escape' ? encode_rows : decode_rows

\t\tassert.equal((operation === 'escape' ? escape : unescape)(input), value, name)
\t\toutput_rows.push({ name, input, value })
\t}

"""
percent_path.write_text(percent.replace(needle, block + needle))
build_path = draft / 'packages/test/build.zig'
build = build_path.read_text()
needle = '        if (std.mem.eql(u8, script, "src/generate_switch_statement.ts"))'
assert build.count(needle) == 1
block = """        if (std.mem.eql(u8, script, "src/generate_querystring.ts")) {
            check.addFileInput(b.path("src/querystring/percent_cases.ts"));
            check.addFileInput(b.path("src/data/querystring_uri.jsonl"));
        }

"""
build_path.write_text(build.replace(needle, block + needle))

for operation in ['escape', 'unescape']:
    reviews = []
    for group in mapping:
        if group['operation'] != operation:
            continue
        reviews.append({
            'path': group['path'],
            'sha256': group['sha256'],
            'status': 'adapted',
            'reason': f'把完整URI成功原文适配为公开std:querystring.{operation}的普通string输入输出；保留全部{len(group["observations"])}项完整观察，不裁剪循环、控制字符、大小写百分号或俄文。编码采用原文允许的大写结果，原文短路分支保持不变。不声明JS全局函数、隐式ToString、孤立surrogate或损坏编码URIError兼容。',
            'contract': 'packages/compiler/standard/interfaces/querystring.d.zx；packages/compiler/standard/src/querystring/percent.zig',
            'cases': list(dict.fromkeys(row['case'] for row in group['observations'])),
            'assertions': [{'case': row['case'], 'field': 'value', 'expected': row['expected']} for row in group['observations']],
        })
    review_path = draft / f'packages/test/upstream/reviews/built_ins/uri/{operation}.jsonl'
    review_path.parent.mkdir(parents=True, exist_ok=True)
    review_path.write_text(json_lines(reviews))

(directory / '原文观察映射.json').write_text(json.dumps(mapping, ensure_ascii=False, indent=4) + '\n')
(directory / '草稿起点.json').write_text(json.dumps({'生产基线': commit, '原文件SHA256': base, '新增案例': 35, '原文观察': 134, '唯一关联': len({row['case'] for group in mapping for row in group['observations']})}, ensure_ascii=False, indent=4) + '\n')
print('Prepared 35 missing cases, 134 complete observations and 16 full adapted reviews')
