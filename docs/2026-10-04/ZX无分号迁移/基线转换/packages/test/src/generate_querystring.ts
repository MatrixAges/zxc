import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'
import parseCases from './querystring/parse_cases.ts'
import percentCases from './querystring/percent_cases.ts'

type Row = { id: string; input: Json; expected: { value: Json } }

function writeSuite(args: { operation: string; input: string; output: string; rows: Array<Row> }): void {
    const { operation, input, output, rows } = args
    const base = `tests/standard/querystring/${operation.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`)}/cases`

    writeCatalog(base + '.jsonl', rows)
    writeOutput(
        base + '.zx',
        `import query from "std:querystring"
import type { Entry, ParseOptions, StringifyOptions } from "std:querystring"

export type Input = ${input}

export type Output = ${output}

export default function (in: Input): Output {
  return query.${operation}(in)
}
`
    )
}

const percent = percentCases()

for (const operation of ['escape', 'unescape'] as const) {
    const rows = percent[operation].map(row => ({
        id: `standard/querystring/${operation}/${row.name}`,
        input: row.input,
        expected: { value: row.value }
    }))

    writeSuite({ operation, input: 'string', output: 'string', rows })
}

const parsed = parseCases()

for (const operation of ['parse', 'parseWith'] as const) {
    const rows = parsed
        .filter(
            row =>
                operation === 'parseWith' ||
                (row.separator === undefined && row.assignment === undefined && row.max_keys === undefined)
        )
        .map(row => ({
            id: `standard/querystring/${operation}/${row.name}`,
            input:
                operation === 'parse'
                    ? row.query
                    : {
                          query: row.query,
                          separator: row.separator ?? '&',
                          assignment: row.assignment ?? '=',
                          max_keys: row.max_keys ?? 1000
                      },
            expected: { value: row.entries }
        }))

    writeSuite({ operation, input: operation === 'parse' ? 'string' : 'ParseOptions', output: 'Entry[]', rows })
}

const entries_cases = [
    { name: 'empty', entries: [] },
    { name: 'empty_key_value', entries: [{ key: '', value: '' }] },
    {
        name: 'interleaved_duplicates',
        entries: [
            { key: 'a', value: '1' },
            { key: 'b', value: '2' },
            { key: 'a', value: '3' }
        ]
    },
    {
        name: 'numeric_order',
        entries: [
            { key: '10', value: 'a' },
            { key: '2', value: 'b' }
        ]
    },
    { name: 'unicode', entries: [{ key: '中文', value: '🌱' }] },
    { name: 'delimiters', entries: [{ key: 'a&b=c', value: '+ %' }] },
    { name: 'nul', entries: [{ key: '\0', value: 'a\0b' }] },
    {
        name: 'prototype_names',
        entries: [
            { key: '__proto__', value: 'own' },
            { key: 'constructor', value: 'value' }
        ]
    }
]

for (const operation of ['stringify', 'stringifyWith'] as const) {
    const delimiters =
        operation === 'stringify'
            ? [['&', '=']]
            : [
                  ['&', '='],
                  [';', ':'],
                  ['||', '=>'],
                  ['分', '值'],
                  ['', '']
              ]
    const rows = entries_cases.flatMap(row =>
        delimiters.map(([separator, assignment], index) => ({
            id: `standard/querystring/${operation}/${row.name}/delimiter_${index}`,
            input: operation === 'stringify' ? row.entries : { entries: row.entries, separator, assignment },
            expected: {
                value: row.entries
                    .map(
                        entry =>
                            `${encodeURIComponent(entry.key)}${assignment || '='}${encodeURIComponent(entry.value)}`
                    )
                    .join(separator || '&')
            }
        }))
    )

    writeSuite({ operation, input: operation === 'stringify' ? 'Entry[]' : 'StringifyOptions', output: 'string', rows })
}
