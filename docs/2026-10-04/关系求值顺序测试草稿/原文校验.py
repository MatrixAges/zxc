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


samples = rows(package / 'src/data/relational_assignment.jsonl')
reviews = {row['path']: row for row in rows(package / 'upstream/reviews/language/expressions/relational_assignment.jsonl')}
front = {row['id']: row for row in rows(package / 'tests/language/types/relational_assignment/cases.jsonl')}
assert len(samples) == 20 and len(reviews) == 16 and len(front) == 16

for sample in samples:
    source = (reference / sample['path']).read_bytes()
    text = source.decode()
    review = reviews[sample['path']]
    assert hashlib.sha256(source).hexdigest() == sample['sha256'] == review['sha256']

    if sample['group'].startswith('A2.3'):
        assert re.search(r'try \{\s+' + re.escape(sample['expression']) + ';', text)
        assert 'valueOf: function () { throw "x"; }' in text
        assert 'valueOf: function () { throw "y"; }' in text
        assert 'if (e !== "x")' in text
        assert review['status'] == 'excluded' and review['cases'] == []
        continue

    if sample['group'].endswith('T3'):
        assert re.search(r'try \{\s+' + re.escape(sample['expression']) + ';', text)
        assert 'e instanceof ReferenceError' in text and sample['expected'] == 'ReferenceError'
    else:
        if sample['initial'] is not None:
            originals = re.findall(r'var x = ([01]);\s+if \((.*?) !== (true|false)\) \{', text)
            initial, expression, expected = originals[sample['check'] - 1]
            assert (int(initial), expression, expected) == (sample['initial'], sample['expression'], sample['expected'])
        else:
            assert 'flags: [noStrict]' in text
            expression, expected = re.search(r'if \((.*?) !== (true|false)\) \{', text).groups()
            assert (expression, expected) == (sample['expression'], sample['expected'])

        left, operation, right = re.split(r' (<=|>=|<|>) ', sample['expression'])
        environment = {} if sample['initial'] is None else {'x': sample['initial']}
        values = []

        for operand in [left, right]:
            assignment = re.fullmatch(r'\(([xy]) = ([01])\)', operand)
            if assignment:
                name, value = assignment.groups()
                environment[name] = int(value)
                values.append(int(value))
            else:
                values.append(environment[operand])

        compare = {'<': operator.lt, '>': operator.gt, '<=': operator.le, '>=': operator.ge}[operation]
        assert compare(*values) == (sample['expected'] == 'true')

    identifier = f"language/types/relational_assignment/{sample['family']}/{sample['group']}/{sample['check']}"
    case = front[identifier]
    assert 'return ' + sample['expression'] + ';' in case['source']
    if sample['initial'] is not None:
        assert f"const x: f64 = {sample['initial']};" in case['source']
    span = case['span']
    target = re.search(r'\([xy] (=) [01]\)', case['source'])
    assert span == list(target.span(1))
    assert case['source'].encode()[span[0]:span[1]] == b'='
    assert span[1] - span[0] == 1
    assert case['phase'] == 'parse' and case['diagnostic'] == 'syntax'
    assert identifier in review['cases']

print('PASS: 16 source hashes, 20 original scenarios, assignment initial values/results and 16 exact token spans; 4 valueOf protocols excluded')
