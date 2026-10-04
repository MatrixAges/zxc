import ast
import hashlib
import json
import operator
import re
from pathlib import Path

root = Path(__file__).resolve().parents[3]
package = root / 'packages/test'
reference = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')


def rows(path):
    return [json.loads(line) for line in path.read_text().splitlines()]


def operand(text):
    parts = []
    for part in text.split(' + '):
        if part == 'x':
            parts.append('x')
        else:
            decoded = re.sub(r'\\u\{([0-9a-fA-F]+)\}', lambda m: chr(int(m.group(1), 16)), part)
            parts.append(ast.literal_eval(decoded))
    return ''.join(parts)


def utf16(text):
    encoded = text.encode('utf-16-be', 'surrogatepass')
    return tuple(int.from_bytes(encoded[i:i+2], 'big') for i in range(0, len(encoded), 2))


samples = rows(package / 'src/data/relational_string_order.jsonl')
reviews = {row['path']: row for row in rows(package / 'upstream/reviews/language/expressions/relational_string_order.jsonl')}
front = {row['id']: row for family in ['greater', 'less_equal', 'greater_equal'] for row in rows(package / f'tests/language/types/relational_string_order/{family}/cases.jsonl')}
assert len(samples) == 96 and len(reviews) == 12 and len(front) == 105
variant_count = 0
lexical_count = 0

for sample in samples:
    original = (reference / sample['path']).read_bytes()
    checks = re.findall(r'^if \(\((.*?)\) !== (true|false)\) \{', original.decode(), re.M)
    expression, expected = checks[sample['check'] - 1]
    assert sample['expression'] == '(' + expression + ')'
    assert sample['expected'] == (expected == 'true')
    assert hashlib.sha256(original).hexdigest() == sample['sha256'] == reviews[sample['path']]['sha256']
    left, operation, right = re.split(r' (>=|<=|>) ', expression)
    compare = {'>': operator.gt, '<=': operator.le, '>=': operator.ge}[operation]
    assert compare(utf16(operand(left)), utf16(operand(right))) == sample['expected']
    prefix = f"language/types/relational_string_order/{sample['family']}/{sample['group']}/{sample['check']}"
    case = front[prefix + '/original']
    assert 'return ' + sample['expression'] + ';' in case['source']
    unsupported = re.search(r"\\u|'", case['source'])
    if unsupported:
        lexical_count += 1
        start = len(case['source'][:unsupported.start()].encode())
        assert case['phase'] == 'parse' and case['diagnostic'] == 'lexical'
        assert case['span'] == [start, start + len(unsupported.group())]
    else:
        assert case['phase'] == 'analyze' and case['diagnostic'] == 'type_mismatch'

    if '\\u{' in expression:
        variant_count += 1
        variant = front[prefix + '/utf8']
        decoded = re.sub(r'\\u(?:\{([0-9a-fA-F]+)\}|([0-9a-fA-F]{4}))', lambda m: chr(int(m.group(1) or m.group(2), 16)), sample['expression'])
        assert 'return ' + decoded + ';' in variant['source']
        assert variant['phase'] == 'analyze' and variant['diagnostic'] == 'type_mismatch'
        assert variant['id'] in reviews[sample['path']]['cases']
    assert case['id'] in reviews[sample['path']]['cases']

assert variant_count == 9 and lexical_count == 30
print('PASS: 12 hashes, 96 original expressions and UTF16 truth values, 30 lexical spans, 9 real UTF8 variants, 105 frontend expectations')
