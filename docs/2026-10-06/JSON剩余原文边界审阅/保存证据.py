# -*- coding: utf-8 -*-
import hashlib
import json
from pathlib import Path
import shutil
import subprocess


root = Path('/Users/xiewendao/Documents/MatrixAges/zxc')
directory = Path(__file__).resolve().parent
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
original = json.loads((directory / '原文结果.json').read_text())
reviews_path = Path('packages/test/upstream/reviews/built_ins/json/remaining.jsonl')

assert original['files'] == 35 and len(original['results']) == 70
assert original['json_parse_replaced'] is False
assert all(row['passed'] and row['error'] is None for row in original['results'])
assert (root / reviews_path).read_bytes() == (directory / '草稿' / reviews_path).read_bytes()

entries = [json.loads(line) for line in (directory / '待审文件.jsonl').read_text().splitlines()]
for row in entries:
    assert hashlib.sha256((upstream / row['path']).read_bytes()).hexdigest() == row['sha256']

audit = json.loads((directory / '覆盖审计.json').read_text())
assert audit['catalog_cases'] == 80533 and sum(audit['reviewed'].values()) == 2553
assert audit['reviewed']['adapted'] == 732 and audit['reviewed']['excluded'] == 1718
assert audit['unreviewed'] == 51044 and audit['linked_cases'] == 5314
closure = json.loads((directory / '家族闭合.json').read_text())
assert closure['matched_unreviewed'] == 0
assert not Path('/tmp/zxc-json-boundary-pending.txt').read_bytes()

all_reviews = [json.loads(line) for path in (root / 'packages/test/upstream/reviews/built_ins/json').glob('*.jsonl') for line in path.read_text().splitlines()]
family = [row for row in all_reviews if row['path'].startswith('test/built-ins/JSON/parse/')]
assert len(family) == 77 and len({row['path'] for row in family}) == 77
assert sum(row['status'] == 'adapted' for row in family) == 42
assert sum(row['status'] == 'excluded' for row in family) == 35

sources = [str(reviews_path), 'packages/cli/README.md', 'packages/genz/src/host/cli/input.zig', 'packages/genz/src/host/wasm/json.zig', 'packages/test/src/audit_matrix.ts', 'packages/test/src/query_upstream.ts', 'packages/test/src/shared/upstream.ts', 'packages/test/upstream/lock.json']
fingerprints = {path: hashlib.sha256((root / path).read_bytes()).hexdigest() for path in sources}
stdlib = Path('/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/lib/std/json/static.zig')
shutil.copyfile('/tmp/zxc-json-boundary-original.log', directory / '原文执行日志.txt')
value = {
    '证据主检出提交': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip(),
    'Test262提交': '7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd',
    'Node版本': subprocess.check_output(['node', '--version'], text=True).strip(),
    '原始源码与metadata核对': 35,
    '原样Node普通及严格执行': {'实际执行': 70, '通过': 70, '退出码': 0, 'JSON_parse替换': False},
    '新增ZX可执行案例': 0,
    '新增excluded': 35,
    'JSON_parse家族': {'完整文件': 77, 'adapted': 42, 'excluded': 35, '未审阅': 0, '完全JS兼容': False},
    '参考执行器SHA256': hashlib.sha256((directory / '原文验证.mjs').read_bytes()).hexdigest(),
    '来源SHA256': fingerprints,
    'Zig默认重复字段契约SHA256': hashlib.sha256(stdlib.read_bytes()).hexdigest(),
    '完整矩阵审计': audit,
    '查询闭合': closure,
    '自我批判': '原文函数反射、callback、descriptor、原型、source及sameValue身份属于核心断言。Node原样通过只证明参考原文可执行，不计ZX通过。未替换JSON.parse，避免改变length/name/constructor或丢弃reviver。原文key===5分支不会命中，不填为观察。未对负零expected做JSON.stringify转换。重复字段差异来自生产入口标准库默认选项源码，未将其声称为已经运行的ZX缺陷复现。excluded是当前完整适配边界，整个Test262与所有语言特性的原始目标未缩减。',
}
(directory / '执行结果.json').write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
print('77 complete JSON.parse review decisions; 70 original runs; 0 new ZX compatibility claims')
