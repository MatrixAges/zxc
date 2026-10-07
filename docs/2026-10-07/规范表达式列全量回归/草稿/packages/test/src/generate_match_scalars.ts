import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Value = { name: string; value: string | boolean | bigint | number }
const families: Array<{ name: string; type: string; values: Array<Value> }> = [
    {
        name: 'boolean',
        type: 'bool',
        values: [
            { name: 'false', value: false },
            { name: 'true', value: true }
        ]
    },
    {
        name: 'string',
        type: 'string',
        values: Object.entries({
            empty: '',
            ascii: 'a',
            nul_tail: 'a\0',
            nul_middle: 'a\0b',
            composed: 'é',
            decomposed: 'e\u0301',
            emoji: '😀',
            chinese: '中',
            undefined_text: 'undefined'
        }).map(([name, value]) => ({ name, value }))
    },
    { name: 'enum', type: 'u8', values: [0, 1, 2].map(value => ({ name: String(value), value })) }
]

for (const signed of [false, true]) {
    for (const width of signed ? [32, 64] : [8, 16, 32, 64]) {
        const type = `${signed ? 'i' : 'u'}${width}`
        const maximum = (1n << BigInt(width - (signed ? 1 : 0))) - 1n
        const minimum = signed ? -(1n << BigInt(width - 1)) : 0n

        families.push({
            name: type,
            type,
            values: [
                { name: 'minimum', value: minimum },
                { name: 'middle', value: signed ? 0n : 1n },
                { name: 'maximum', value: maximum }
            ]
        })
    }
}

for (const family of families) {
    const prefix = `language/expressions/match/scalars/${family.name}`
    const rows = []
    const enumeration = family.name === 'enum'
    const declarations = enumeration ? 'export enum State { First, Second, Third }\n\n' : ''
    const indent = enumeration ? '    ' : '  '
    const field_indent = enumeration ? '    ' : ' '
    const branch_indent = indent.repeat(2)
    const bindings = enumeration
        ? ['target', 'first', 'second']
              .map(
                  name =>
                      `    const ${name} = match {\n        in.${name} == 0 => State.First,\n        in.${name} == 1 => State.Second,\n        _ => State.Third\n    }`
              )
              .join('\n\n') + '\n\n'
        : ''
    const target = enumeration ? 'target' : 'in.target'
    const first = enumeration ? 'first' : 'in.first'
    const second = enumeration ? 'second' : 'in.second'

    for (const subject of family.values) {
        for (const first_value of family.values) {
            for (const second_value of family.values) {
                const same = (value: Value): boolean =>
                    family.type === 'string'
                        ? Buffer.from(subject.value as string).equals(Buffer.from(value.value as string))
                        : subject.value === value.value
                const result = same(first_value) ? 11 : same(second_value) ? 22 : 33

                rows.push({
                    id: `${prefix}/${subject.name}/${first_value.name}/${second_value.name}`,
                    input: { target: subject.value, first: first_value.value, second: second_value.value },
                    expected: { value: result }
                })
            }
        }
    }

    writeOutput(
        `tests/${prefix}.zx`,
        `${declarations}export type Input = { target: ${family.type}
${field_indent}first: ${family.type}
${field_indent}second: ${family.type} }

export type Output = u8

export default function (in: Input): Output {
${bindings}${indent}return match ${target} {\n${branch_indent}${first} => 11,\n${branch_indent}${second} => 22,
${branch_indent}_ => 33,
${indent}}
}
`
    )
    writeCatalog(`tests/${prefix}.jsonl`, rows)
}

const default_rows: Array<{ id: string; input: Json; expected: { value: Json } }> = [0, 1, 255].map(value => ({
    id: `language/expressions/match/default_only/${value}`,
    input: value,
    expected: { value }
}))

writeOutput(
    'tests/language/expressions/match/default_only.zx',
    'export type Input = u8\n\nexport type Output = u8\n\nexport default function (in: Input): Output {\n  return match { _ => in }\n}\n'
)
writeCatalog('tests/language/expressions/match/default_only.jsonl', default_rows)
writeOutput(
    'tests/language/expressions/match/nested.zx',
    'export type Input = { left: bool\n right: bool }\n\nexport type Output = u8\n\nexport default function (in: Input): Output {\n  return match in.left {\n    true => match in.right { true => 11, _ => 22 },\n    _ => match in.right { true => 33, _ => 44 },\n  }\n}\n'
)
writeCatalog(
    'tests/language/expressions/match/nested.jsonl',
    [false, true].flatMap(left =>
        [false, true].map(right => ({
            id: `language/expressions/match/nested/${left}/${right}`,
            input: { left, right },
            expected: { value: left ? (right ? 11 : 22) : right ? 33 : 44 }
        }))
    )
)

const cases = [
    ['unsupported_i8', '', 'i8', 'match in { _ => 11 }', 'analyze', 'name'],
    ['unsupported_i16', '', 'i16', 'match in { _ => 11 }', 'analyze', 'name'],
    [
        'enum_missing_default',
        'export enum State { First, Second }\n\n',
        'State',
        'match in { State.First => 11, State.Second => 22, }',
        'parse',
        'syntax'
    ],
    [
        'foreign_enum',
        'export enum State { First }\n\nexport enum Other { First }\n\n',
        'State',
        'match in { Other.First => 11, _ => 22 }',
        'analyze',
        'type_mismatch'
    ],
    [
        'enum_numeric_pattern',
        'export enum State { First }\n\n',
        'State',
        'match in { 0 => 11, _ => 22 }',
        'analyze',
        'type_mismatch'
    ],
    [
        'integer_width',
        '',
        '{ target: u8\n pattern: u16 }',
        'match in.target { in.pattern => 11, _ => 22 }',
        'analyze',
        'type_mismatch'
    ],
    [
        'integer_sign',
        '',
        '{ target: i32\n pattern: u32 }',
        'match in.target { in.pattern => 11, _ => 22 }',
        'analyze',
        'type_mismatch'
    ],
    ['boolean_numeric_pattern', '', 'bool', 'match in { 1 => 11, _ => 22 }', 'analyze', 'type_mismatch']
] as const

writeCatalog(
    'tests/language/expressions/match/scalar_types.jsonl',
    cases.map(([name, declarations, input, expression, phase, diagnostic]) => ({
        id: `language/expressions/match/types/${name}`,
        source: `${declarations}export type Input = ${input}

export type Output = u8

export default function (in: Input): Output {
  return ${expression}
}
`,
        phase,
        diagnostic
    }))
)
