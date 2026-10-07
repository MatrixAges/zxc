import type { Json } from './shared/json.ts'
import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Input = { items: Array<number>; threshold?: number; limit?: number }
type Sample = {
    name: string
    kind: string
    path: string
    sha256: string
    input: Input
    reason: string
    native?: { case: string; expected: Record<string, Json> }
}

const samples = readRows<Sample>(resolve(package_dir, 'src/data/every_observers.jsonl'))
const base = 'built_ins/list/callbacks/every'
const inputs = [
    { name: 'empty', items: [] },
    { name: 'zero', items: [0] },
    { name: 'one', items: [11] },
    { name: 'pair', items: [11, 9] },
    { name: 'ordered', items: [11, 12, 13] },
    { name: 'reversed', items: [13, 12, 11] },
    { name: 'first_false', items: [9, 11, 12] },
    { name: 'last_false', items: [11, 12, 9] },
    { name: 'repeated', items: [11, 11, 11] },
    { name: 'signed', items: [-11, 0, 11, -1] },
    { name: 'growth_257', items: Array.from({ length: 257 }, (_, index) => index % 17) },
    { name: 'growth_1024', items: Array.from({ length: 1024 }, (_, index) => index % 31) }
]

function expectedValue(kind: string, input: Input) {
    const visited: Array<number> = []
    const result = input.items.every((value, index) => {
        visited.push(value)

        if (kind === 'value') return value > input.threshold!
        if (kind === 'index') return index <= input.limit!

        return true
    })

    return {
        result,
        calls: visited.length,
        visited,
        ...('threshold' in input ? { threshold: input.threshold } : {}),
        ...('limit' in input ? { limit: input.limit } : {})
    }
}

for (const kind of ['value', 'index', 'all']) {
    const field = kind === 'value' ? 'threshold' : kind === 'index' ? 'limit' : null
    const type = kind === 'value' ? 'i64' : 'u64'
    const extra = field ? `, ${field}: ${type}` : ''
    const initial = field ? `, ${field}: in.${field}` : ''
    const retained = field ? `, ${field}: state.${field}` : ''
    const predicate =
        kind === 'value' ? 'item > state.threshold' : kind === 'index' ? 'state.calls <= state.limit' : 'true'
    const path = `${base}/${kind}/cases`

    writeOutput(
        `tests/${path}.zx`,
        `export type Input = { items: i64[]${extra} }

export type Output = { result: bool, calls: u64, visited: i64[]${extra} }

export default function (in: Input): Output {
    const initial: Output = { result: true, calls: 0, visited: []${initial} }

    return in.items.reduce((state, item) => state.result ? {
        result: ${predicate}, calls: state.calls + 1, visited: state.visited.push(item)[0]${retained}
    } : state, initial)
}
`
    )
    const limits = kind === 'value' ? [-1, 0, 10, 11, 65535] : kind === 'index' ? [0, 1, 5, 9, 17] : [0]
    const rows = [
        ...samples.filter(sample => sample.kind === kind).map(sample => ({ name: sample.name, input: sample.input })),
        ...limits.flatMap(limit =>
            inputs.map(input => ({
                name: field ? `${input.name}_${field}_${limit}` : input.name,
                input: { items: input.items, ...(field ? { [field]: limit } : {}) }
            }))
        )
    ]

    writeCatalog(
        `tests/${path}.jsonl`,
        rows.map(row => ({
            id: `${base}/${kind}/${row.name}`,
            input: row.input,
            expected: { value: expectedValue(kind, row.input) }
        }))
    )
}

writeOutput(
    `tests/${base}/rows/cases.zx`,
    `export type Input = { items: i64[][], threshold: i64 }

export type Output = { result: bool, calls: u64, visited: i64[], threshold: i64 }

export default function (in: Input): Output {
    const initial: Output = { result: true, calls: 0, visited: [], threshold: in.threshold }

    return in.items.reduce((state, item) => state.result ? {
        result: item[0] > state.threshold, calls: state.calls + 1,
        visited: state.visited.push(item[0])[0], threshold: state.threshold
    } : state, initial)
}
`
)

const rows = [
    { name: 'empty', items: [], visited: [], result: true },
    { name: 'true', items: [[11]], visited: [11], result: true },
    { name: 'false', items: [[9]], visited: [9], result: false },
    { name: 'first_failure', items: [[]], error: 'IndexOutOfBounds' },
    { name: 'later_failure', items: [[11], []], error: 'IndexOutOfBounds' },
    { name: 'stopped_before_empty', items: [[9], []], visited: [9], result: false },
    { name: 'stopped_after_true', items: [[11], [9], []], visited: [11, 9], result: false },
    { name: 'all_true', items: [[11], [12], [13]], visited: [11, 12, 13], result: true }
]

writeCatalog(
    `tests/${base}/rows/cases.jsonl`,
    rows.map(row => ({
        id: `${base}/rows/${row.name}`,
        input: { items: row.items, threshold: 10 },
        expected: row.error
            ? { error: row.error }
            : { value: { result: row.result, calls: row.visited!.length, visited: row.visited, threshold: 10 } }
    }))
)

writeCatalog(
    'upstream/reviews/built_ins/array/every_observers.jsonl',
    samples.map(sample => {
        const id = `${base}/${sample.kind}/${sample.name}`

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: sample.reason,
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [id, ...(sample.native ? [sample.native.case] : [])],
            assertions: [
                { case: id, field: 'value', expected: expectedValue(sample.kind, sample.input) },
                ...Object.entries(sample.native?.expected ?? {}).map(([field, expected]) => ({
                    case: sample.native!.case,
                    field,
                    expected
                }))
            ]
        }
    })
)
