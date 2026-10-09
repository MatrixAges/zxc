import type { Spec } from './models/filter_selection.ts'
import { resolve } from 'node:path'
import cases from './filter_selection/cases.ts'
import expectation from './models/filter_selection.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; spec: Spec; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/filter_selection.jsonl'))
const base = 'built_ins/list/callbacks/filter/selection'
const programs = {
    length: { fields: 'expected_length: u64', predicate: 'source.length == in.expected_length' },
    position: {
        fields: 'selected_index: u64, selected_value: i64',
        predicate: 'index == in.selected_index && item == in.selected_value'
    },
    source_value: { fields: 'threshold: i64', predicate: 'item > in.threshold && source[index] == item' },
    stride: { fields: 'period: u64, phase: u64', predicate: 'index % in.period == in.phase && source[index] == item' },
    neighbors: { fields: 'first: bool', predicate: 'index == 0 ? in.first : item > source[index - 1]' }
}

for (const operation of Object.keys(programs) as Array<Spec['operation']>) {
    const program = programs[operation]
    const rows = [...samples.filter(sample => sample.spec.operation === operation), ...cases(operation)]

    writeOutput(
        `tests/${base}/${operation}.zx`,
        `export type Input = { items: i64[], ${program.fields} }\n\nexport type Output = { selected: i64[], items: i64[] }\n\nexport default function (in: Input): Output {\n    return { selected: in.items.filter((item, index, source) => ${program.predicate}), items: in.items }\n}\n`
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
    'upstream/reviews/built_ins/array/filter_selection.jsonl',
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
