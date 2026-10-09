import type { Spec } from './models/map_projection.ts'
import { resolve } from 'node:path'
import cases from './map_projection/cases.ts'
import expectation from './models/map_projection.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; spec: Spec; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/map_projection.jsonl'))
const base = 'built_ins/list/callbacks/map/projection'
const programs = {
    source_value: {
        fields: 'threshold: i64',
        type: 'bool',
        expression: 'item > in.threshold && source[index] == item'
    },
    indices: { fields: '', type: 'u64', expression: 'index' },
    length: { fields: '', type: 'u64', expression: 'source.length' },
    rotate: { fields: '', type: 'i64', expression: 'source[index + 1 == source.length ? 0 : index + 1]' },
    records: {
        fields: 'first: i64',
        type: '{ item: i64, index: u64, length: u64, previous: i64 }',
        expression: '({ item, index, length: source.length, previous: index == 0 ? in.first : source[index - 1] })'
    }
}

for (const operation of Object.keys(programs) as Array<Spec['operation']>) {
    const program = programs[operation]
    const rows = [...samples.filter(sample => sample.spec.operation === operation), ...cases(operation)]

    writeOutput(
        `tests/${base}/${operation}.zx`,
        `export type Input = { items: i64[]${program.fields ? `, ${program.fields}` : ''} }\n\nexport type Output = { mapped: ${program.type}[], items: i64[] }\n\nexport default function (in: Input): Output {\n    return { mapped: in.items.map((item, index, source) => ${program.expression}), items: in.items }\n}\n`
    )
    writeCatalog(
        `tests/${base}/${operation}.jsonl`,
        rows.map(row => ({
            id: `${base}/${operation}/${row.name}`,
            input: row.spec.input,
            expected: expectation(row.spec)
        }))
    )
}

writeCatalog(
    'upstream/reviews/built_ins/array/map_projection.jsonl',
    samples.map(sample => {
        const row = { id: `${base}/${sample.spec.operation}/${sample.name}`, expected: expectation(sample.spec) }

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: sample.reason,
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [row.id],
            assertions: [{ case: row.id, field: 'value', expected: row.expected.value }]
        }
    })
)
