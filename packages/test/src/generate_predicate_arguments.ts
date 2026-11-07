import type { Method, Spec } from './models/predicate_arguments.ts'
import { resolve } from 'node:path'
import expectation from './models/predicate_arguments.ts'
import cases from './predicate_arguments/cases.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = Spec & { name: string; path: string; sha256: string; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/predicate_arguments.jsonl'))
const base = 'built_ins/list/predicates/arguments'

for (const method of ['every', 'some'] as Array<Method>) {
    for (const operation of ['source_value', 'position'] as const) {
        const fields =
            operation === 'source_value' ? '    threshold: i64' : '    selected_index: u64,\n    selected_value: i64'
        const selected =
            operation === 'source_value'
                ? '        const selected = item > in.threshold'
                : `        const selected = (
            - index ${method === 'some' ? '==' : '!='} in.selected_index
            - ${method === 'some' ? 'and' : 'or'} item == in.selected_value
        )`
        const rows = [
            ...samples.filter(sample => sample.method === method && sample.operation === operation),
            ...cases({ method, operation })
        ]

        writeOutput(
            `tests/${base}/${method}/${operation}.zx`,
            `import host from "zig:host"

export type Input = {
    items: i64[],
${fields}
}

export type Output = bool

export default function (in: Input): Output {
    return host.source(in.items).${method}((item, index, source) => {
        const visited = host.visit({
            item,
            index,
            source
        })

${selected}

        return (
            - visited
            - and selected
            - and source[index] == item
        )
    })
}
`
        )
        writeCatalog(
            `tests/${base}/${method}/${operation}.jsonl`,
            rows.map(row => ({
                id: `${base}/${method}/${operation}/${row.name}`,
                method,
                operation,
                input: row.input,
                probe: row.probe,
                expected: expectation(row)
            }))
        )
    }
}

writeCatalog(
    'upstream/reviews/built_ins/array/predicate_arguments.jsonl',
    samples.map(sample => {
        const row = { id: `${base}/${sample.method}/${sample.operation}/${sample.name}`, expected: expectation(sample) }

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: sample.reason,
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [row.id],
            assertions: Object.entries(row.expected).map(([field, expected]) => ({ case: row.id, field, expected }))
        }
    })
)
