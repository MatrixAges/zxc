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


def string_value(text):
    wrapped = re.fullmatch(r'new String\((.*)\)', text)
    return json.loads(wrapped.group(1) if wrapped else text)


samples = rows(package / 'src/data/relational_string_conversion.jsonl')
reviews = rows(package / 'upstream/reviews/language/expressions/relational_string_conversion.jsonl')
front = {row['id']: row for family in ['less', 'greater', 'less_equal', 'greater_equal'] for row in rows(package / f'tests/language/types/relational_string_conversion/{family}/cases.jsonl')}
assert len(samples) == 40 and len(reviews) == 8 and len(front) == 24
assert sum(review['status'] == 'excluded' for review in reviews) == 4

for review in reviews:
    source = reference / review['path']
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    checks = re.findall(r'^if \((.*?)\) \{', source.read_text(), re.M)
    selected = [sample for sample in samples if sample['path'] == review['path']]
    assert len(checks) == len(selected)
    assert review['sha256'] == digest

    for number, (condition, sample) in enumerate(zip(checks, selected), 1):
        assert sample['sha256'] == digest and sample['check'] == number
        assert condition == sample['expression'] + ' !== ' + sample['expected']

        if review['status'] == 'excluded':
            assert not review['cases']
            assert 'toString()' in sample['expected']
            continue

        left, operation, right = re.split(r' (<=|>=|<|>) ', sample['expression'])
        compare = {'<': operator.lt, '>': operator.gt, '<=': operator.le, '>=': operator.ge}[operation]
        assert compare(string_value(left), string_value(right)) == (sample['expected'] == 'true')
        identifier = f"language/types/relational_string_conversion/{sample['family']}/{number}"
        case = front[identifier]
        syntax = left.startswith('new String(') or right.startswith('new String(')
        assert (case['phase'], case['diagnostic']) == (('parse', 'syntax') if syntax else ('analyze', 'type_mismatch'))
        assert 'return ' + sample['expression'] + ';' in case['source']
        assert identifier in review['cases']

print('PASS: 8 source hashes, 40 original conditions, 24 string truth values and frontend expectations, 4 excluded dynamic protocol files')
