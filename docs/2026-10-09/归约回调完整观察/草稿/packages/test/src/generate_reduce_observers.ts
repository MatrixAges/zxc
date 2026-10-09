import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = {
    name: string
    path: string
    sha256: string
    items: Array<number>
    seed: number
    reason: string
}

const samples = readRows<Sample>(resolve(package_dir, 'src/data/reduce_observers.jsonl'))
const base = 'built_ins/list/callbacks/reduce/observers'
const inputs = [
    { name: 'empty', items: [] },
    { name: 'zero', items: [0] },
    { name: 'one', items: [11] },
    { name: 'pair', items: [11, 12] },
    { name: 'ordered', items: [11, 12, 13] },
    { name: 'reversed', items: [13, 12, 11] },
    { name: 'repeated', items: [11, 11, 11] },
    { name: 'signed', items: [-11, 0, 11, -1] },
    { name: 'alternating', items: [1, -1, 1, -1] },
    { name: 'boundary', items: [-65535, 65535, 0] },
    { name: 'growth_257', items: Array.from({ length: 257 }, (_, index) => (index % 17) - 8) },
    { name: 'growth_1024', items: Array.from({ length: 1024 }, (_, index) => (index % 31) - 15) }
]

function expectedValue(input: { items: Array<number>; seed: number }) {
    const visits: Array<{
        previous: number
        current: number
        index: number
        source_value: number
        source_length: number
    }> = []
    const value = input.items.reduce((previous, current, index, source) => {
        visits.push({ previous, current, index, source_value: source[index], source_length: source.length })

        return current
    }, input.seed)

    return { value, visits }
}

writeOutput(
    `tests/${base}/cases.zx`,
    `export type Input = { items: i64[], seed: i64 }

export type Output = { value: i64, visits: { previous: i64, current: i64, index: u64, source_value: i64, source_length: u64 }[] }

export default function (in: Input): Output {
    const initial: Output = { value: in.seed, visits: [] }

    return in.items.reduce((state, item, index, source) => ({
        value: item,
        visits: state.visits.push({ previous: state.value, current: item, index, source_value: source[index], source_length: source.length })[0]
    }), initial)
}
`
)

const rows = [
    ...samples.map(sample => ({ name: sample.name, items: sample.items, seed: sample.seed })),
    ...[-7, 0, 1, 11, 65535].flatMap(seed =>
        inputs.map(input => ({
            ...input,
            name: `${input.name}_seed_${seed}`,
            seed
        }))
    )
].map(({ name, ...input }) => ({
    id: `${base}/${name}`,
    input,
    expected: { value: expectedValue(input) }
}))

writeCatalog(`tests/${base}/cases.jsonl`, rows)
writeCatalog(
    'upstream/reviews/built_ins/array/reduce_observers.jsonl',
    samples.map(sample => {
        const id = `${base}/${sample.name}`

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: sample.reason,
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [id],
            assertions: [{ case: id, field: 'value', expected: expectedValue(sample) }]
        }
    })
)
