import type { Operation, Row, Spec } from './models/reduce_floating.ts'
import assert from 'node:assert/strict'
import expectation from './models/reduce_floating.ts'
import inputs from './reduce_floating/inputs.ts'
import nodeReference from './reduce_floating/node_reference.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const operators = { add: '+', subtract: '-', multiply: '*', divide: '/' }
const base = 'built_ins/list/callbacks/reduce/floating'

for (const width of [32, 64] as const) {
    for (const operation of Object.keys(operators) as Array<Operation>) {
        for (const seeded of [false, true]) {
            const spec: Spec = { width, operation, seeded }
            const group = `${base}/f${width}/${operation}/${seeded ? 'seeded' : 'unseeded'}`
            const rows: Array<Row> = inputs(spec).map(({ name, input }) => {
                const expected = expectation({ spec, input })

                assert.deepEqual(expected, nodeReference({ spec, input }), group + '/' + name)

                return { id: group + '/' + name, input, expected }
            })

            assert.equal(new Set(rows.map(row => row.id)).size, rows.length)
            writeCatalog('tests/' + group + '.jsonl', rows)
            writeOutput(
                'tests/' + group + '.zx',
                `export type Input = { items: f${width}[], seed: f${width} }

export type Output = f${width}

export default function (in: Input): Output {
    return in.items.reduce((previous, current) => previous ${operators[operation]} current${seeded ? ', in.seed' : ''})
}
`
            )
        }
    }
}
