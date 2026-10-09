import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Method = 'map' | 'filter' | 'every' | 'some'
type Original = { method: Method; path: string; sha256: string }

const originals = readRows<Original>(resolve(package_dir, 'src/data/callback_arguments.jsonl'))
const samples = [
    { name: 'empty', input: [] },
    { name: 'singleton', input: [11] },
    { name: 'pair', input: [11, 12] },
    { name: 'original_parameters', input: Array.from({ length: 10 }, (_, index) => index) },
    { name: 'descending', input: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] },
    { name: 'unrelated', input: [99, -8, 44, 0, 12, 12, -5, 7, 1, 900] },
    { name: 'repeated', input: [11, 11, 11] },
    { name: 'signed', input: [-1, 0, 1, -900, 900] }
]

for (const length of [2, 3, 4, 5, 7, 8, 15, 16, 17, 31, 32, 33, 64, 65, 127, 128, 257]) {
    samples.push({
        name: `growth_${length}`,
        input: Array.from({ length }, (_, index) => (index % 23) - 11)
    })
}

for (const method of ['map', 'filter', 'every', 'some'] as const) {
    const base = `built_ins/list/callbacks/${method}/arguments/cases`
    const rows = samples.map(sample => {
        function predicate(item: number, index: number, source: Array<number>): boolean {
            return method === 'some' ? source[index] !== item : source[index] === item
        }

        const value =
            method === 'map'
                ? sample.input.map(predicate)
                : method === 'filter'
                  ? sample.input.filter(predicate)
                  : method === 'every'
                    ? sample.input.every(predicate)
                    : sample.input.some(predicate)

        return { id: `${base}/${sample.name}`, input: sample.input, expected: { value } }
    })
    const output_type = method === 'map' ? 'bool[]' : method === 'filter' ? 'i64[]' : 'bool'
    const operator = method === 'some' ? '!=' : '=='

    writeOutput(
        `tests/${base}.zx`,
        `export type Input = i64[]\n\nexport type Output = ${output_type}\n\nexport default function (in: Input): Output {\n    return in.${method}((item, index, source) => source[index] ${operator} item)\n}\n`
    )
    writeCatalog(`tests/${base}.jsonl`, rows)
}

writeCatalog(
    'upstream/reviews/built_ins/array/callback_arguments.jsonl',
    originals.map(original => {
        const id = `built_ins/list/callbacks/${original.method}/arguments/cases/original_parameters`
        const expected = original.method === 'every'

        return {
            path: original.path,
            sha256: original.sha256,
            status: 'adapted',
            reason: 'Preserve the original dense numeric array and compare each callback item with source[index]; every returns true and some returns false.',
            contract: 'packages/core/IR契约.md#所有权与集合回调',
            cases: [id],
            assertions: [{ case: id, field: 'value', expected }]
        }
    })
)
