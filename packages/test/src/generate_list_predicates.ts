import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Row = { name: string; input: Json; expected: { value?: Json; error?: string } }

function writeSuite(args: { name: string; input: string; expression: string; rows: Array<Row> }) {
    const { name, input, expression, rows } = args
    const path = `built_ins/list/predicates/${name}/cases`

    writeOutput(
        `tests/${path}.zx`,
        `export type Input = ${input}

export type Output = bool

export default function (in: Input): Output {
    return ${expression}
}
`
    )
    writeCatalog(
        `tests/${path}.jsonl`,
        rows.map(({ name, ...row }) => ({ id: `${path}/${name}`, ...row }))
    )
}

const inputs = [
    { name: 'empty', input: [] },
    { name: 'zero', input: [0] },
    { name: 'one', input: [1] },
    { name: 'negative', input: [-1] },
    { name: 'original_threshold', input: [11, 9] },
    { name: 'first_false', input: [0, 1, 2] },
    { name: 'last_false', input: [1, 2, 0] },
    { name: 'all_true', input: [11, 12, 13] },
    { name: 'all_false', input: [-1, 0, -2] },
    { name: 'repeated', input: [11, 11, 11] },
    { name: 'growth_257', input: Array.from({ length: 257 }, (_, index) => (index % 17) - 8) },
    { name: 'growth_4096', input: Array.from({ length: 4096 }, (_, index) => (index % 31) - 15) }
]

for (const method of ['every', 'some'] as const) {
    for (const threshold of [0, 10]) {
        writeSuite({
            name: `${method}/greater_${threshold}`,
            input: 'i64[]',
            expression: `in.${method}(item => item > ${threshold})`,
            rows: inputs.map(row => ({ ...row, expected: { value: row.input[method](item => item > threshold) } }))
        })
    }

    for (const result of [false, true]) {
        writeSuite({
            name: `${method}/constant_${result}`,
            input: 'i64[]',
            expression: `in.${method}(item => ${result})`,
            rows: inputs.map(row => ({ ...row, expected: { value: row.input[method](() => result) } }))
        })
    }
}

const nested = [
    { name: 'empty', input: [] },
    { name: 'empty_row', input: [[]] },
    { name: 'one_true', input: [[1]] },
    { name: 'one_false', input: [[0]] },
    {
        name: 'both_true',
        input: [
            [0, 1],
            [-1, 2]
        ]
    },
    { name: 'later_empty', input: [[1], []] },
    { name: 'false_then_true', input: [[0], [1]] },
    { name: 'repeated', input: [[1], [1], [1]] }
]

writeSuite({
    name: 'nested',
    input: 'i64[][]',
    expression: 'in.every(row => row.some(item => item > 0))',
    rows: nested.map(row => ({ ...row, expected: { value: row.input.every(items => items.some(item => item > 0)) } }))
})

const rows = [
    { name: 'empty', input: [] },
    { name: 'first_failure', input: [[]] },
    { name: 'true', input: [[1]] },
    { name: 'false', input: [[0]] },
    { name: 'true_then_empty', input: [[1], []] },
    { name: 'false_then_empty', input: [[0], []] },
    { name: 'true_false_empty', input: [[1], [0], []] },
    { name: 'false_true_empty', input: [[0], [1], []] }
]

for (const method of ['every', 'some'] as const) {
    writeSuite({
        name: `${method}/bounds`,
        input: 'i64[][]',
        expression: `in.${method}(row => row[0] > 0)`,
        rows: rows.map(row => {
            let expected: Row['expected']

            try {
                expected = {
                    value: row.input[method](items => {
                        if (!items.length) throw new RangeError('IndexOutOfBounds')

                        return items[0] > 0
                    })
                }
            } catch (error) {
                if (!(error instanceof RangeError)) throw error

                expected = { error: 'IndexOutOfBounds' }
            }

            return { ...row, expected }
        })
    })
}
