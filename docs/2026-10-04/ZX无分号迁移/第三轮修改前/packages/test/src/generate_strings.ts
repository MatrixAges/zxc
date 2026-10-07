import type { Json } from './shared/json.ts'
import { createHash } from 'node:crypto'
import { product, range, writeCatalog, writeOutput } from './shared/catalog.ts'
import writeOwnedStrings from './owned_strings.ts'

const strings = [
    '',
    'a',
    'A',
    'ab',
    'a\0b',
    '\0',
    '\n',
    '\r',
    '\t',
    '"',
    '\\',
    '中文',
    '🌱',
    'é',
    'e\u0301',
    '\u0301',
    '\ufeff',
    '\ue000',
    '\u{10000}',
    '👩\u200d💻',
    '\u2028',
    '\u2029'
]
const literals = [
    '',
    'ascii',
    '"quoted"',
    '\\',
    '\n',
    '\r',
    '\t',
    'a\n\r\tb',
    '中文',
    '🌱',
    'e\u0301',
    'é',
    '${literal}',
    '`tick`',
    '\u2028'
]

function wrap(args: { fields: string; output: string; body: string }): string {
    const { fields, output, body } = args

    return `export type Input = { ${fields} }

export type Output = ${output}

export default function (in: Input): Output {
${body}\n}\n`
}

function programs(): Record<string, string> {
    const values = wrap({
        fields: 'left: string; right: string;',
        output: '{ bytes: u64\n same: bool\n different: bool\n joined: string\n wrapped: string }',
        body: '  return { bytes: in.left.length, same: in.left == in.right, different: in.left != in.right, joined: `${in.left}${in.right}`, wrapped: `[${in.left}][${in.right}]` }\n'
    })
    const optional = wrap({
        fields: 'left: string?; right: string?;',
        output: '{ same: bool\n different: bool\n chosen: string }',
        body: '  return { same: in.left == in.right, different: in.left != in.right, chosen: in.left ?? (in.right ?? "") }\n'
    })
    const reduce = wrap({
        fields: 'items: string[]; seed: string;',
        output: 'string',
        body: '  return in.items.reduce((sum, item) => `${sum}${item}`, in.seed)\n'
    })
    const branches = literals.map((value, index) => `    case ${index}: return ${JSON.stringify(value)};\n`).join('')
    const literal_source =
        'export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in) {\n' +
        branches +
        '    default: return "";\n  }\n}\n'

    return { values, optional, sort: '', concat_reverse: '', reduce, literals: literal_source }
}

function* cases(name: string): Generator<[Json, Json]> {
    if (name === 'values' || name === 'optional') {
        const values = name === 'values' ? strings : [null, ...strings]

        for (const [left, right] of product(values, 2)) {
            const output: Record<string, Json> = { same: left === right, different: left !== right }

            if (name === 'values') {
                output.bytes = Buffer.byteLength(left!)
                output.joined = left! + right!
                output.wrapped = `[${left}][${right}]`
            } else output.chosen = left ?? right ?? ''

            yield [{ left, right }, output]
        }

        return
    }

    if (name === 'literals') {
        yield* literals.entries()

        return
    }

    const arrays = range(4).flatMap(length => product(['', 'a', 'Z', '中'], length))

    if (name === 'sort')
        arrays.push(Array.from('zyxwvutsrqponMLKJIHGFEDCBA'), ['\u{10000}', '\ue000'], ['é', 'e\u0301', '\0'])

    for (const items of arrays) {
        if (name === 'sort')
            yield [{ items }, items.toSorted((left, right) => Buffer.compare(Buffer.from(left), Buffer.from(right)))]
        else if (name === 'concat_reverse') {
            for (const other of [[], [''], ['🌱', '\0'], ['é', 'e\u0301']])
                yield [{ items, other }, [...items, ...other].reverse()]
        } else if (name === 'reduce') {
            for (const seed of ['', 'start-', '初始']) yield [{ items, seed }, seed + items.join('')]
        }
    }

    if (name === 'reduce') yield [{ items: [], seed: 'initialValue is present' }, 'initialValue is present']
}

function identityText(value: Json): string {
    if (Array.isArray(value)) return '[' + value.map(identityText).join(', ') + ']'
    if (value !== null && typeof value === 'object')
        return (
            '{' +
            Object.keys(value)
                .sort()
                .map(key => JSON.stringify(key) + ': ' + identityText(value[key]))
                .join(', ') +
            '}'
        )

    return JSON.stringify(value)
}

for (const [name, source] of Object.entries(programs())) {
    const rows = []

    for (const [data, value] of cases(name)) {
        const case_id = createHash('sha256').update(identityText(data)).digest('hex').slice(0, 16)
        rows.push({ id: `built_ins/string/${name}/${case_id}`, input: data, expected: { value } })
    }

    if (name === 'sort' || name === 'concat_reverse') {
        writeOwnedStrings({
            name,
            rows: rows.map(row => ({ ...row, input: row.input as Record<string, Array<string>> }))
        })
    } else {
        const base = `tests/built_ins/string/${name}/cases`

        writeCatalog(base + '.jsonl', rows)
        writeOutput(base + '.zx', source)
    }
}
