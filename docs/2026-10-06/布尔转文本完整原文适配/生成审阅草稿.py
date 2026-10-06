import hashlib
import json
from pathlib import Path
import shutil


directory = Path(__file__).resolve().parent
root = directory.parents[2]
path = 'test/language/expressions/concatenation/S9.8_A3_T2.js'
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
entries = [json.loads(line) for line in (root / 'packages/test/upstream/metadata/language.jsonl').read_text().splitlines()]
entry = next(row for row in entries if row['path'] == path)
source = (upstream / path).read_bytes()
assert hashlib.sha256(source).hexdigest() == entry['sha256'] == 'b2ebdfab8c9b4cd341dcb86aab412b7f57889ce8b4d0b510983d222dffa66b2b'
assert not entry.get('flags') and not entry.get('includes') and 'negative' not in entry
shutil.copyfile(upstream / path, directory / '完整原文.txt')
(directory / '原文metadata.json').write_text(json.dumps(entry, ensure_ascii=False, indent=2) + '\n')
catalog = Path('packages/test/tests/language/expressions/template_primitives/bool.jsonl')
rows = [json.loads(line) for line in (directory / '草稿' / catalog).read_text().splitlines()]
assert [row['input'] for row in rows] == [False, True]
assert [row['expected']['value'] for row in rows] == ['false', 'true']
review = {
    'path': path,
    'sha256': entry['sha256'],
    'status': 'adapted',
    'reason': '把原文false/true加空字符串的隐式转换适配为ZX现有显式bool模板插值。完整保留两项输入与精确完整文本，不使用混合模板子串，不声称JS一般加法、boxed或对象ToPrimitive兼容。',
    'contract': 'packages/genz/src/zx/templates.zig bool文本生成；packages/test/tests/language/expressions/template_primitives/bool.zx 普通Input/Output',
    'cases': [row['id'] for row in rows],
    'assertions': [{'case': row['id'], 'field': 'value', 'expected': row['expected']['value']} for row in rows],
}
review_path = Path('packages/test/upstream/reviews/language/expressions/concatenation_boolean.jsonl')
(directory / '草稿' / review_path).write_text(json.dumps(review, ensure_ascii=False, separators=(',', ':')) + '\n')
registry = json.loads((root / 'packages/test/suites.json').read_text())
assert not any(row['path'] == 'language/expressions/template_primitives/bool' for row in registry['runtime'])
index = next(index for index, row in enumerate(registry['runtime']) if row['name'] == 'template-primitives-dynamic') + 1
registry['runtime'].insert(index, {'name': 'template-primitives-bool', 'path': 'language/expressions/template_primitives/bool', 'kind': 'control'})
(directory / '草稿/packages/test/suites.json').write_text(json.dumps(registry, ensure_ascii=False, indent=2) + '\n')
print('Complete original and two full boolean observations prepared; existing runner reused')
