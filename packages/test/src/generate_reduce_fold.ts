import type { Spec } from './models/reduce_fold.ts'
import type { Json } from './shared/json.ts'
import { resolve } from 'node:path'
import expectation from './models/reduce_fold.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; spec: Spec; reason: string }
type Named = { name: string; spec: Spec }
type Suite = { name: string; input: string; output: string; expression: string; rows: Array<Named> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/reduce_fold.jsonl'))
const base = 'built_ins/list/callbacks/reduce/fold'
const text_inputs = [
    { name: 'empty', items: [] },
    { name: 'single_empty', items: [''] },
    { name: 'singleton', items: ['a'] },
    { name: 'original_order', items: ['1', '2', '3', '4', '5'] },
    { name: 'reversed', items: ['5', '4', '3', '2', '1'] },
    { name: 'repeated', items: ['ab', 'ab', 'ab'] },
    { name: 'empty_elements', items: ['', 'a', '', 'b', ''] },
    { name: 'unicode', items: ['清', '新', '🌿', 'e\u0301'] },
    { name: 'nul', items: ['a\0', 'b', '\0c'] },
    { name: 'delimiters', items: ['ab', 'c', 'de'] },
    { name: 'growth_257', items: Array.from({ length: 257 }, (_, index) => String.fromCharCode(65 + (index % 26))) },
    { name: 'growth_1024', items: Array.from({ length: 1024 }, (_, index) => `[${index}]`) }
]
const numeric_inputs = [
    { name: 'empty', items: [] },
    { name: 'zero', items: [0] },
    { name: 'singleton', items: [1] },
    { name: 'original_items', items: [1, 2, 3, 4, 5] },
    { name: 'reversed', items: [5, 4, 3, 2, 1] },
    { name: 'repeated', items: [11, 11, 11] },
    { name: 'signed', items: [-11, 0, 11, -1] },
    { name: 'alternating', items: [1, -1, 1, -1] },
    { name: 'boundary', items: [-65535, 65535, 0] },
    { name: 'uneven', items: [17, -4, 99, 0, -33] },
    { name: 'growth_257', items: Array.from({ length: 257 }, (_, index) => (index % 17) - 8) },
    { name: 'growth_1024', items: Array.from({ length: 1024 }, (_, index) => (index % 31) - 15) }
]
const suites: Array<Suite> = []

for (const seeded of [false, true]) {
    const mode = seeded ? 'seeded' : 'unseeded'
    const argument = seeded ? 'in.items' : 'in'
    const initial = seeded ? ', in.seed' : ''

    suites.push({
        name: `concat/${mode}`,
        input: seeded ? '{ items: string[], seed: string }' : 'string[]',
        output: 'string',
        expression: `${argument}.reduce((previous, current) => \`\${previous}\${current}\`${initial})`,
        rows: (seeded ? ['', '0', 'prefix', '🌿', '\0'] : ['']).flatMap(seed =>
            text_inputs.map(input => ({
                name: `${input.name}/seed_${Buffer.from(seed).toString('hex') || 'empty'}`,
                spec: { operation: 'concat' as const, seeded, items: input.items, seed }
            }))
        )
    })
    suites.push({
        name: `sum/${mode}`,
        input: seeded ? '{ items: i64[], seed: i64 }' : 'i64[]',
        output: 'i64',
        expression: `${argument}.reduce((previous, current) => previous + current${initial})`,
        rows: (seeded ? [-7, 0, 1, 11, 65535] : [0]).flatMap(seed =>
            numeric_inputs.map(input => ({
                name: `${input.name}/seed_${seed}`,
                spec: { operation: 'sum' as const, seeded, items: input.items, seed }
            }))
        )
    })
}

suites.push({
    name: 'constant/unseeded',
    input: '{ items: i64[], returned: i64 }',
    output: '{ value: i64, items: i64[] }',
    expression: '{ value: in.items.reduce((previous, current) => in.returned), items: in.items }',
    rows: [-7, 0, 1, 11, 65535].flatMap(returned =>
        numeric_inputs.map(input => ({
            name: `${input.name}/returned_${returned}`,
            spec: { operation: 'constant' as const, items: input.items, returned }
        }))
    )
})

for (const sample of samples) {
    const name =
        sample.spec.operation +
        '/' +
        (sample.spec.operation === 'constant' || !sample.spec.seeded ? 'unseeded' : 'seeded')

    suites.find(suite => suite.name === name)!.rows.unshift(sample)
}

const originals = new Map<string, { id: string; expected: ReturnType<typeof expectation> }>()

for (const suite of suites) {
    writeOutput(
        `tests/${base}/${suite.name}.zx`,
        `export type Input = ${suite.input}\n\nexport type Output = ${suite.output}\n\nexport default function (in: Input): Output {\n    return ${suite.expression}\n}\n`
    )
    const rows = suite.rows.map(({ name, spec }) => {
        const input =
            spec.operation === 'constant'
                ? { items: spec.items, returned: spec.returned }
                : spec.seeded
                  ? { items: spec.items, seed: spec.seed }
                  : spec.items
        const row = { id: `${base}/${suite.name}/${name}`, input, expected: expectation(spec) }

        originals.set(name, row)

        return row
    })

    writeCatalog(`tests/${base}/${suite.name}.jsonl`, rows)
}

writeCatalog(
    'upstream/reviews/built_ins/array/reduce_fold.jsonl',
    samples.map(sample => {
        const row = originals.get(sample.name)!

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
