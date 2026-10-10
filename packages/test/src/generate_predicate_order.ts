import type { Spec } from './models/predicate_order.ts'
import { resolve } from 'node:path'
import expectation from './models/predicate_order.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = Spec & { path: string; sha256: string; reason: string; original_calls: boolean }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/predicate_order.jsonl'))
const base = 'built_ins/list/predicates/order'

for (const sample of samples) {
    const { method, rule } = sample
    const directory = `${base}/${method}/${rule}`
    const context = rule === 'visited' ? ', host.context()' : ''
    const controls = rule === 'cursor' ? [{ ...sample, probe: { cursor: 1 }, name: 'mismatched_cursor' }] : []

    writeOutput(
        `tests/${directory}.zx`,
        `import host from "zig:host"\n\nexport type Input = { items: i64[] }\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n    return host.source(in.items).${method}((item, index, source) => host.visit({ item, index, source })${context})\n}\n`
    )
    writeCatalog(
        `tests/${directory}.jsonl`,
        [{ ...sample, name: 'upstream' }, ...controls].map(row => ({
            id: `${directory}/${row.name}`,
            method,
            rule,
            input: row.input,
            probe: row.probe,
            expected: expectation(row)
        }))
    )
}

writeCatalog(
    'upstream/reviews/built_ins/array/predicate_order.jsonl',
    samples.map(sample => {
        const id = `${base}/${sample.method}/${sample.rule}/upstream`
        const expected = expectation(sample)

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: sample.reason,
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [id],
            assertions: [
                { case: id, field: 'value', expected: expected.value },
                ...(sample.original_calls ? [{ case: id, field: 'calls', expected: expected.calls }] : [])
            ]
        }
    })
)
