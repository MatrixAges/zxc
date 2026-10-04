from pathlib import Path
import hashlib
import json
import re

repo = Path(__file__).resolve().parents[3]
upstream = Path('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd')
load = lambda relative: [json.loads(line) for line in (repo / 'packages/test' / relative).read_text().splitlines()]
samples = load('src/data/relational_whitespace.jsonl')
front = {row['id']: row for row in load('tests/language/types/relational_whitespace/cases.jsonl')}
runtime = {row['id']: row for row in load('tests/language/expressions/comparison/whitespace.jsonl')}
reviews = load('upstream/reviews/language/expressions/relational_whitespace.jsonl')
assert len(samples) == 40 and len(front) == 240 and len(runtime) == 216 and len(reviews) == 4
operators = {'less': '<', 'greater': '>', 'less_equal': '<=', 'greater_equal': '>='}
cross_operator = 0

for review in reviews:
    path = upstream / review['path']
    assert hashlib.sha256(path.read_bytes()).hexdigest() == review['sha256']
    originals = re.findall(r'if \(eval\(("[^"]*")\) !== (true|false)\)', path.read_text())
    records = [sample for sample in samples if sample['path'] == review['path']]
    assert len(originals) == len(records) == 10
    assert len(review['cases']) == 114 and len(set(review['cases'])) == 114

    for (raw, expected), sample in zip(originals, records):
        expression = f"{sample['left']}{sample['gap']}{sample['operator']}{sample['gap']}{sample['right']}"
        assert json.loads(raw) == expression
        assert sample['expected'] == (expected == 'true')
        ordering = (sample['left'] > sample['right']) - (sample['left'] < sample['right'])
        assert {'<': ordering == -1, '>': ordering == 1, '<=': ordering != 1, '>=': ordering != -1}[sample['operator']] == sample['expected']
        cross_operator += sample['operator'] != operators[sample['family']]
        original_case = front[f"language/types/relational_whitespace/{sample['family']}/{sample['gap_name']}/both/number"]
        assert 'return ' + expression + ';' in original_case['source']
        rejected = next((char for char in sample['gap'] if ord(char) > 127), None)

        for position in ['left', 'right', 'both']:
            for scalar in ['number', 'mixed']:
                row = front[f"language/types/relational_whitespace/{sample['family']}/{sample['gap_name']}/{position}/{scalar}"]
                assert row['id'] in review['cases']
                if rejected:
                    start = len(row['source'][:row['source'].index(rejected)].encode())
                    assert row['phase'] == 'parse' and row['diagnostic'] == 'lexical' and row['span'] == [start, start + 1]
                else:
                    assert row['phase'] == 'analyze'
                    assert row['diagnostic'] == ('type_mismatch' if scalar == 'mixed' else None)

            if not rejected:
                for value in [0, 1, 2]:
                    row = runtime[f"language/expressions/comparison/whitespace/{sample['family']}/{sample['gap_name']}/{position}/{value}"]
                    ordering = (value > sample['right']) - (value < sample['right'])
                    result = {'<': ordering == -1, '>': ordering == 1, '<=': ordering != 1, '>=': ordering != -1}[sample['operator']]
                    assert row['expected']['value'] == result
                    assert row['id'] in review['cases']
                    if value == sample['left']:
                        assert result == sample['expected']

assert cross_operator == 2
assert sum(row['diagnostic'] == 'lexical' for row in front.values()) == 96
print('PASS: 4 source hashes, 40 original expressions, 2 preserved cross-operator cases, 240 frontend expectations and 216 independent runtime results')
