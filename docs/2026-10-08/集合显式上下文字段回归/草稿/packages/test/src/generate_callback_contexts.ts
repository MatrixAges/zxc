import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Context = { res: boolean }

function readContext(this: Context): boolean {
    return this.res
}

const inputs = [
    { name: 'empty', items: [] },
    { name: 'single', items: [1] },
    { name: 'zero', items: [0] },
    { name: 'signed', items: [-11, 0, 11] },
    { name: 'repeated', items: [1, 1, 1] },
    { name: 'ordered', items: [1, 3, 2] },
    { name: 'reversed', items: [2, 3, 1] },
    ...[17, 65, 257].map(length => ({
        name: `growth_${length}`,
        items: Array.from({ length }, (_, index) => (index % 23) - 11)
    }))
]

for (const method of ['map', 'filter', 'every', 'some'] as const) {
    const base = `built_ins/list/callbacks/${method}/context`
    const output = method === 'map' ? 'bool[]' : method === 'filter' ? 'i64[]' : 'bool'

    const rows = [false, true].flatMap(res =>
        inputs.map(({ name, items }) => {
            const context = { res }

            const value =
                method === 'map'
                    ? items.map(readContext, context)
                    : method === 'filter'
                      ? items.filter(readContext, context)
                      : method === 'every'
                        ? items.every(readContext, context)
                        : items.some(readContext, context)

            return {
                id: `${base}/context_${res}/${name}`,
                input: { items, context },
                expected: { value }
            }
        })
    )

    writeOutput(
        `tests/${base}/cases.zx`,
        `export type Input = { items: i64[], context: { res: bool } }\n\nexport type Output = ${output}\n\nexport default function (in: Input): Output {\n  return in.items.${method}((item, context) => context.res, in.context)\n}\n`
    )

    writeCatalog(`tests/${base}/cases.jsonl`, rows)
}

writeCatalog(
    'upstream/reviews/built_ins/array/callback_contexts.jsonl',
    readRows(resolve(package_dir, 'src/data/callback_contexts.jsonl'))
)
