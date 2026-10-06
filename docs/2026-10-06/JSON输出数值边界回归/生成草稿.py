import json
from pathlib import Path


directory = Path(__file__).resolve().parent
draft = directory / '草稿/packages/test/tests/built_ins/json/output'
error = {'error': 'NonFiniteJsonNumber'}


def value(expected):
    return {'value': expected}


def write_suite(name, type_source, rows, body='return in'):
    source = (
        type_source
        + '\n\nexport default function (in: Input): Output {\n'
        + '  ' + body + '\n}\n'
    )
    catalog = []

    for suffix, text, expected in rows:
        catalog.append({
            'id': 'built_ins/json/output/' + name + '/' + suffix,
            'json_text': text,
            'expected': expected,
        })

    draft.mkdir(parents=True, exist_ok=True)
    (draft / (name + '.zx')).write_text(source, encoding='utf-8')
    (draft / (name + '.jsonl')).write_text(
        ''.join(json.dumps(row, ensure_ascii=False, separators=(',', ':')) + '\n' for row in catalog),
        encoding='utf-8',
    )

    return {'name': 'application-json-output-' + name, 'path': 'built_ins/json/output/' + name, 'kind': 'application_json', 'count': len(rows)}


suites = [
    write_suite('scalar', 'export type Input = f64\n\nexport type Output = f64', [
        ('finite', '1.5', value(1.5)),
        ('positive_zero', '0', value(0)),
        ('negative_zero', '-0', value(-0.0)),
        ('positive_overflow', '1e400', error),
        ('negative_overflow', '-1e400', error),
        ('largest_finite', '1.7976931348623157e308', value(1.7976931348623157e308)),
        ('smallest_positive', '5e-324', value(5e-324)),
        ('finite_after_errors', '-2.5', value(-2.5)),
    ]),
    write_suite('f32', 'export type Input = f32\n\nexport type Output = f32', [
        ('finite', '1.5', value(1.5)),
        ('negative_finite', '-2', value(-2)),
        ('positive_overflow', '1e40', error),
        ('negative_overflow', '-1e40', error),
        ('finite_after_errors', '0', value(0)),
    ]),
    write_suite('division', 'export type Input = { numerator: f64\n denominator: f64 }\n\nexport type Output = f64', [
        ('finite', '{"numerator":6,"denominator":2}', value(3)),
        ('positive_infinity', '{"numerator":1,"denominator":0}', error),
        ('negative_infinity', '{"numerator":-1,"denominator":0}', error),
        ('nan', '{"numerator":0,"denominator":0}', error),
        ('negative_zero', '{"numerator":0,"denominator":-1}', value(-0.0)),
        ('finite_after_errors', '{"numerator":12,"denominator":4}', value(3)),
    ], 'return in.numerator / in.denominator'),
    write_suite('list', 'export type Input = f64[][]\n\nexport type Output = f64[][]', [
        ('empty', '[]', value([])),
        ('empty_layers', '[[],[]]', value([[], []])),
        ('finite', '[[],[1.5,-2,0]]', value([[], [1.5, -2, 0]])),
        ('first_overflow', '[[1e400,1],[]]', error),
        ('middle_overflow', '[[1,1e400,2]]', error),
        ('last_negative_overflow', '[[],[1,-1e400]]', error),
        ('finite_after_errors', '[[3],[],[4]]', value([[3], [], [4]])),
    ]),
    write_suite('tuple', 'export type Input = [string, f64, f64?]\n\nexport type Output = [string, f64, f64?]', [
        ('finite', '["prefix",1.5,-2]', value(['prefix', 1.5, -2])),
        ('none', '["prefix",1,null]', value(['prefix', 1, None])),
        ('required_overflow', '["prefix",1e400,null]', error),
        ('optional_overflow', '["prefix",1,-1e400]', error),
        ('finite_after_errors', '["after",2,3]', value(['after', 2, 3])),
    ]),
    write_suite('object', 'export type Value = { first: f64\n rest: f64[] }\n\nexport type Input = { prefix: string\n value: Value? }\n\nexport type Output = Input', [
        ('none', '{"prefix":"prefix","value":null}', value({'prefix': 'prefix', 'value': None})),
        ('empty_list', '{"prefix":"prefix","value":{"first":1,"rest":[]}}', value({'prefix': 'prefix', 'value': {'first': 1, 'rest': []}})),
        ('finite', '{"prefix":"prefix","value":{"first":1.5,"rest":[2,-3]}}', value({'prefix': 'prefix', 'value': {'first': 1.5, 'rest': [2, -3]}})),
        ('field_overflow', '{"prefix":"prefix","value":{"first":1e400,"rest":[]}}', error),
        ('list_overflow', '{"prefix":"prefix","value":{"first":1,"rest":[2,-1e400]}}', error),
        ('none_after_errors', '{"prefix":"after","value":null}', value({'prefix': 'after', 'value': None})),
    ]),
    write_suite('optional', 'export type Input = f64?\n\nexport type Output = f64?', [
        ('none', 'null', value(None)),
        ('finite', '1.5', value(1.5)),
        ('positive_overflow', '1e400', error),
        ('negative_overflow', '-1e400', error),
        ('none_after_errors', 'null', value(None)),
    ]),
    write_suite('projection', 'export type Input = { numerator: f64\n denominator: f64 }\n\nexport type Output = { positive: bool\n negative: bool\n nan: bool }', [
        ('finite_positive', '{"numerator":6,"denominator":2}', value({'positive': True, 'negative': False, 'nan': False})),
        ('input_positive_overflow', '{"numerator":1e400,"denominator":1}', value({'positive': True, 'negative': False, 'nan': False})),
        ('input_negative_overflow', '{"numerator":-1e400,"denominator":1}', value({'positive': False, 'negative': True, 'nan': False})),
        ('divide_positive_infinity', '{"numerator":1,"denominator":0}', value({'positive': True, 'negative': False, 'nan': False})),
        ('divide_negative_infinity', '{"numerator":-1,"denominator":0}', value({'positive': False, 'negative': True, 'nan': False})),
        ('divide_nan', '{"numerator":0,"denominator":0}', value({'positive': False, 'negative': False, 'nan': True})),
        ('divide_negative_zero', '{"numerator":0,"denominator":-1}', value({'positive': False, 'negative': False, 'nan': False})),
        ('finite_after_non_finite', '{"numerator":-6,"denominator":2}', value({'positive': False, 'negative': True, 'nan': False})),
    ], 'const result = in.numerator / in.denominator\n\n  return { positive: result > 0, negative: result < 0, nan: result != result }'),
]

(directory / '草稿清单.json').write_text(json.dumps(suites, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'suites': len(suites), 'cases': sum(suite['count'] for suite in suites)}, ensure_ascii=False))
