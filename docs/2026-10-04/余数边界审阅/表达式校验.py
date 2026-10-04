from pathlib import Path
import hashlib
import json
import re
import sys

root = Path(sys.argv[1])
package = Path('packages/test')
index = {row['path']: row['sha256'] for row in map(json.loads, (package / 'upstream/index/language.jsonl').read_text().splitlines())}
conversion = list(map(json.loads, (package / 'tests/language/types/modulus_conversion/cases.jsonl').read_text().splitlines()))
whitespace = list(map(json.loads, (package / 'tests/language/types/modulus_whitespace/cases.jsonl').read_text().splitlines()))
count = 0

for path in sorted((root / 'test/language/expressions/modulus').glob('S11.5.3_A3*')):
    relative = str(path.relative_to(root))
    assert hashlib.sha256(path.read_bytes()).hexdigest() == index[relative]
    text = path.read_text()
    expressions = re.findall(r'^if \((.*?) !== (?:0|1|true|Number\.POSITIVE_INFINITY)\) \{', text, re.M)
    assert len(expressions) == len(re.findall(r'^if ', text, re.M))
    assert len(expressions) == len(re.findall(r'//CHECK#', text))
    group = path.stem.split('_A3_')[1]
    cases = [row for row in conversion if f'/{group}/' in row['id']]
    assert len(cases) == len(expressions)

    for expression, row in zip(expressions, cases):
        if expression.startswith('isNaN('):
            assert expression.endswith(')')
            expression = expression[6:-1]

        assert row['source'].split('  return ')[1].split(';\n')[0] == expression

    count += len(cases)
    print(f'{path.name}: SHA256 and {len(cases)} expressions verified')

assert count == 72
path = root / 'test/language/expressions/modulus/S11.5.3_A1.js'
assert hashlib.sha256(path.read_bytes()).hexdigest() == index[str(path.relative_to(root))]
expressions = re.findall(r'if \(eval\((".*?")\) !== 0\)', path.read_text())
cases = [row for row in whitespace if row['id'].endswith('/both/number')]
assert len(expressions) == len(cases) == 10

for expression, row in zip(expressions, cases):
    assert row['source'].split('  return ')[1].split(';\n')[0] == json.loads(expression)

print('A1: SHA256 and all 10 original whitespace sequences verified')
print('15 files, 72 conversion expressions, 10 whitespace expressions verified')
