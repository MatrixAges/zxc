import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import sourceProgram from './state_updates/source.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Floating = { id: string; left: string; right: string; expected: string }
type Original = {
    name: string
    operator: string
    cases: Array<{ id: string; left: number; right: number; expected: number; assign_first: boolean }>
}

const operations = [
    { name: 'assign', model: 'addition', operator: '=' },
    { name: 'add', model: 'addition', operator: '+=' },
    { name: 'subtract', model: 'subtraction', operator: '-=' },
    { name: 'multiply', model: 'multiplication', operator: '*=' },
    { name: 'divide', model: 'division', operator: '/=' },
    { name: 'remainder', model: 'modulus', operator: '%=' }
]

for (const width of [32, 64]) {
    for (const operation of operations) {
        const model = `language/expressions/${operation.model}`
        const path = `language/statements/state_updates/${operation.name}/f${width}`
        const rows = readRows<Floating>(resolve(package_dir, `tests/${model}/f${width}.jsonl`)).map(row => {
            const expected = operation.name === 'assign' ? row.right : row.expected

            return {
                ...row,
                id: row.id.replace(model, `language/statements/state_updates/${operation.name}`),
                expected
            }
        })

        writeCatalog(`tests/${path}.jsonl`, rows)
        writeOutput(
            `tests/${path}.zx`,
            sourceProgram({ operator: operation.operator, scalar: `f${width}`, initialized: false })
        )
    }
}

const originals = JSON.parse(
    readFileSync(resolve(package_dir, 'src/data/state_update_upstream.json'), 'utf8')
) as Array<Original>

for (const original of originals) {
    const base = `tests/language/statements/state_updates/upstream/${original.name}`
    const rows = original.cases.map(row => ({
        id: `language/statements/state_updates/upstream/${row.id}`,
        input: { left: row.left, right: row.right, assign_first: row.assign_first },
        expected: { value: { initialized: row.left, scalar: row.expected, field: row.expected, element: row.expected } }
    }))

    writeCatalog(base + '.jsonl', rows)
    writeOutput(base + '.zx', sourceProgram({ operator: original.operator, scalar: 'f64', initialized: true }))
}
