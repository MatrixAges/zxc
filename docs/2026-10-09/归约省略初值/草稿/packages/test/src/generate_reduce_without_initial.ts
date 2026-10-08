import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

const base = 'built_ins/list/callbacks/reduce/without_initial'

writeOutput(
    `tests/${base}/cases.zx`,
    `export type Input = string[]

export type Output = string

export default function (in: Input): Output {
    return in.reduce((previous, current) => current)
}
`
)

writeCatalog(`tests/${base}/cases.jsonl`, [
    {
        id: `${base}/singleton_string`,
        input: ['initialValue is not present'],
        expected: { value: 'initialValue is not present' }
    }
])

writeCatalog(
    'upstream/reviews/built_ins/array/reduce_without_initial.jsonl',
    readRows(resolve(package_dir, 'src/data/reduce_without_initial.jsonl'))
)
