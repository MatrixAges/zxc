import hashlib
import json
import math
import re
from pathlib import Path

root = Path(__file__).resolve().parents[3]
reference = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
package = root / 'packages/test'


def read_rows(path):
    return [json.loads(line) for line in path.read_text().splitlines()]


def numeric_operand(text):
    wrapped = re.fullmatch(r'new (Boolean|Number|String)\((.*)\)', text)
    value = wrapped.group(2) if wrapped else text

    if value == 'true':
        return 1
    if value == 'null':
        return 0
    if value == 'undefined':
        return math.nan
    if value.startswith('"'):
        value = json.loads(value)

    try:
        return float(value)
    except ValueError:
        return math.nan


samples = read_rows(package / 'src/data/less_than_conversion.jsonl')
frontend = {row['id']: row for row in read_rows(package / 'tests/language/types/less_than_conversion/cases.jsonl')}
reviews = read_rows(package / 'upstream/reviews/language/expressions/less_than_conversion.jsonl')
assert len(samples) == len(frontend) == 62
assert len(reviews) == 12

for review in reviews:
    original = reference / review['path']
    digest = hashlib.sha256(original.read_bytes()).hexdigest()
    checks = re.findall(r'^if \((.*?) !== (true|false)\) \{', original.read_text(), re.M)
    selected = [sample for sample in samples if sample['path'] == review['path']]
    assert len(checks) == len(selected)
    assert review['sha256'] == digest

    for number, ((expression, expected), sample) in enumerate(zip(checks, selected), 1):
        assert sample['sha256'] == digest
        assert sample['expression'] == expression and sample['check'] == number
        assert sample['expected'] == (expected == 'true')
        left, right = expression.split(' < ')
        assert (numeric_operand(left) < numeric_operand(right)) == sample['expected']
        identifier = f"language/types/less_than_conversion/{sample['group']}/{number}"
        case = frontend[identifier]
        assert 'return ' + expression + ';' in case['source']

        if left.startswith('new ') or right.startswith('new '):
            phase, diagnostic = 'parse', 'syntax'
        elif left == 'null':
            phase, diagnostic = 'analyze', 'type_mismatch'
        elif 'undefined' in [left, right]:
            phase, diagnostic = 'analyze', 'name'
        elif left.isdigit() and right.isdigit():
            phase, diagnostic = 'analyze', None
        else:
            phase, diagnostic = 'analyze', 'type_mismatch'

        assert (case['phase'], case['diagnostic']) == (phase, diagnostic)
        assert identifier in review['cases']

controls = {row['id']: row for row in read_rows(package / 'tests/language/expressions/comparison/whitespace.jsonl')}
control = controls['language/expressions/comparison/whitespace/less/tab/left/1']
assert control['input'] == {'shape': 0, 'value': 1}
assert control['expected']['value'] is False
assert 'case 0: return in.value\t< 1;' in (package / 'tests/language/expressions/comparison/whitespace.zx').read_text()
print('PASS: 12 source hashes, 62 original expressions and JS truth values, 62 frontend expectations, existing numeric runtime control')
