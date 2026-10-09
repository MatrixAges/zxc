import type { Probe, Spec } from './models/map_trace.ts'
import { resolve } from 'node:path'
import expectation from './models/map_trace.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = Spec & { name: string; path: string; sha256: string; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/map_trace.jsonl'))
const base = 'built_ins/list/callbacks/map/trace'
const inputs = [
    { name: 'empty', input: [] },
    { name: 'zero', input: [0] },
    { name: 'singleton', input: [11] },
    { name: 'pair', input: [11, 9] },
    { name: 'ordered', input: [0, 1, 2, 3, 4, 5] },
    { name: 'reversed', input: [5, 4, 3, 2, 1, 0] },
    { name: 'repeated', input: [7, 7, 7, 7] },
    { name: 'signed', input: [-11, 0, 11, -1] },
    { name: 'growth_257', input: Array.from({ length: 257 }, (_, index) => index % 17) },
    { name: 'growth_1024', input: Array.from({ length: 1024 }, (_, index) => index % 31) }
]

for (const rule of ['cursor', 'violations'] as const) {
    const rows: Array<Spec & { name: string }> = samples.filter(sample => sample.probe.rule === rule)

    for (const sample of inputs) {
        const length = sample.input.length
        const cursors = rule === 'cursor' && length > 0 ? [...new Set([0, 1, 2, length + 1])] : [0]
        const failures = length > 0 ? [...new Set([0, 1, Math.ceil(length / 2), length, length + 1])] : [0]

        for (const cursor of cursors) {
            for (const failure of failures) {
                const probe: Probe = { rule, cursor, failure }

                rows.push({ name: `${sample.name}/cursor_${cursor}/failure_${failure}`, input: sample.input, probe })
            }
        }
    }

    writeOutput(
        `tests/${base}/${rule}.zx`,
        'import host from "zig:host"\n\nexport type Input = i64[]\n\nexport type Output = bool[]\n\nexport default function (in: Input): Output {\n    return host.source(in).map((item, index, source) => host.visit({ item, index, source }))\n}\n'
    )
    writeCatalog(
        `tests/${base}/${rule}.jsonl`,
        rows.map(row => ({
            id: `${base}/${rule}/${row.name}`,
            input: row.input,
            probe: row.probe,
            expected: expectation(row)
        }))
    )
}

writeCatalog(
    'upstream/reviews/built_ins/array/map_trace.jsonl',
    samples.map(sample => {
        const row = { id: `${base}/${sample.probe.rule}/${sample.name}`, expected: expectation(sample) }

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
