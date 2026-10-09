import type { Failure, Input, Mode, Row } from './models/reduce_trace.ts'
import type { Json } from './shared/json.ts'
import { resolve } from 'node:path'
import expectation from './models/reduce_trace.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; mode: Mode; path: string; sha256: string; input: Input; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/reduce_trace.jsonl'))
const base = 'built_ins/list/callbacks/reduce/trace'
const inputs = [
    { name: 'empty', items: [] },
    { name: 'singleton', items: [11] },
    { name: 'zero', items: [0] },
    { name: 'first_pair', items: [11, 9] },
    { name: 'ascending', items: [0, 1, 2, 3] },
    { name: 'descending', items: [3, 2, 1, 0] },
    { name: 'repeated', items: [11, 11, 11] },
    { name: 'signed', items: [-11, 0, 11, -1] },
    { name: 'alternating', items: [1, -1, 1, -1] },
    { name: 'boundary', items: [-65535, 65535, 0] },
    { name: 'growth_257', items: Array.from({ length: 257 }, (_, index) => (index % 17) - 8) },
    { name: 'growth_1024', items: Array.from({ length: 1024 }, (_, index) => (index % 31) - 15) }
]
const originals = new Map<string, Row>()

for (const mode of ['seeded', 'unseeded'] as const) {
    const rows: Array<Row> = []

    function append(args: { name: string; input: Input; failure?: Failure; fail_at?: number }): Row {
        const { name, input, failure = 'none', fail_at = 0 } = args
        const row = {
            id: `${base}/${mode}/${name}`,
            input,
            failure,
            fail_at,
            expected: expectation({ mode, input, failure, fail_at })
        }

        rows.push(row)

        return row
    }

    for (const sample of samples.filter(sample => sample.mode === mode)) originals.set(sample.path, append(sample))

    for (const seed of mode === 'seeded' ? [-7, 0, 1, 11, 65535] : [17]) {
        for (const input of inputs) append({ name: `${input.name}/seed_${seed}`, input: { items: input.items, seed } })
    }

    for (const input of inputs) {
        const available = Math.max(0, input.items.length - (mode === 'unseeded' ? 1 : 0))

        for (const failure of ['source', 'seed'] as const)
            append({ name: `${input.name}/${failure}_failure`, input: { items: input.items, seed: 17 }, failure })

        for (const fail_at of new Set([1, 2, available, available + 1].filter(value => value > 0)))
            append({
                name: `${input.name}/callback_failure_${fail_at}`,
                input: { items: input.items, seed: 17 },
                failure: 'callback',
                fail_at
            })
    }

    const initial = mode === 'seeded' ? ', host.seed(in.seed)' : ''

    writeOutput(
        `tests/${base}/${mode}.zx`,
        `import host from "zig:host"\n\nexport type Input = { items: i64[], seed: i64 }\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n    return host.source(in.items).reduce((previous, current, index, source) =>\n        host.visit({ previous, current, index, source })${initial})\n}\n`
    )
    writeCatalog(`tests/${base}/${mode}.jsonl`, rows)
}

writeCatalog(
    'upstream/reviews/built_ins/array/reduce_trace.jsonl',
    samples.map(sample => {
        const row = originals.get(sample.path)!

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: sample.reason,
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [row.id],
            assertions: Object.entries<Json>(row.expected).map(([field, expected]) => ({
                case: row.id,
                field,
                expected
            }))
        }
    })
)
