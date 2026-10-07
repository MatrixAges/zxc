import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const groups = [
    {
        name: 'integer',
        type: 'i64',
        header: '',
        setup: '',
        subject: 'in',
        cases: 'case -1: return 1\n    case 0: return 2\n    case 1: return 3\n    default: return 9\n',
        values: [-1, 0, 1, 2],
        expected: [1, 2, 3, 9]
    },
    {
        name: 'string',
        type: 'string',
        header: '',
        setup: '',
        subject: 'in',
        cases: 'case "": return 0\n    case "a": return 1\n    case "\\n": return 2\n    case "\\t": return 3\n    case "汉": return 4\n    default: return 9\n',
        values: ['', 'a', '\n', '\t', '汉', 'missing'],
        expected: [0, 1, 2, 3, 4, 9]
    },
    {
        name: 'boolean',
        type: 'bool',
        header: '',
        setup: '',
        subject: 'in',
        cases: 'case true: return 1\n    case false: return 2\n',
        values: [true, false],
        expected: [1, 2]
    },
    {
        name: 'enumeration',
        type: 'u8',
        header: 'export enum State { First, Second, Third }\n\n',
        setup: '    const value = match {\n        in == 0 => State.First,\n        in == 1 => State.Second,\n        _ => State.Third\n    }\n\n',
        subject: 'value',
        cases: 'case State.First: return 1\n    case State.Second: return 2\n    case State.Third: return 3\n',
        values: [0, 1, 2, 255],
        expected: [1, 2, 3, 3]
    }
]

for (const group of groups) {
    const path = `tests/language/statements/switch/scalars/${group.name}`
    const indent = group.setup ? '    ' : '  '
    const case_indent = indent.repeat(2)
    const cases = group.cases.replaceAll('\n    ', `\n${case_indent}`)

    writeOutput(
        `${path}.zx`,
        `${group.header}export type Input = ${group.type}

export type Output = u64

export default function (in: Input): Output {
${group.setup}${indent}switch (${group.subject}) {\n${case_indent}${cases}\n${indent}}\n}\n`
    )
    writeCatalog(
        `${path}.jsonl`,
        group.values.map((input, index) => ({
            id: `language/statements/switch/scalars/${group.name}/${index}`,
            input,
            expected: { value: group.expected[index] }
        }))
    )
}

const duplicates = [
    { name: 'signed_zero', type: 'i64', first: '0', last: '-0' },
    { name: 'leading_zero', type: 'u64', first: '1', last: '01' },
    { name: 'separator', type: 'u64', first: '1000', last: '1_000' },
    { name: 'string', type: 'string', first: '"a"', last: '("a")' },
    { name: 'escaped_string', type: 'string', first: '"\\n"', last: '("\\n")' },
    { name: 'boolean', type: 'bool', first: 'true', last: '(true)' },
    { name: 'enumeration', type: 'State', first: 'State.First', last: '(State.First)' }
]
const frontend: Array<Frontend> = duplicates.map(sample => ({
    id: `language/statements/switch_scalars/duplicate/${sample.name}`,
    source: `export enum State { First, Second, Third }\n\nexport type Input = ${sample.type}

export type Output = u64

export default function (in: Input): Output {
  switch (in) {
    case ${sample.first}: return 1
    case ${sample.last}: return 2
    default: return 3
  }
}
`,
    phase: 'analyze',
    diagnostic: 'name'
}))

for (const type of ['bool', 'State'])
    for (const fallback of [false, true])
        frontend.push({
            id: `language/statements/switch_scalars/exhaustive/${type}/${fallback}`,
            source: `export enum State { First, Second, Third }\n\nexport type Input = ${type}

export type Output = u64

export default function (in: Input): Output {
  switch (in) {
    case ${type === 'bool' ? 'true' : 'State.First'}: return 1
${fallback ? '    default: return 2\n' : ''}  }\n}\n`,
            phase: 'analyze',
            diagnostic: fallback ? null : 'return_path'
        })

writeCatalog('tests/language/statements/switch_scalars/cases.jsonl', frontend)
