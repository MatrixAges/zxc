import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = {
    name: 'increment' | 'square' | 'object_key'
    path: string
    sha256: string
    parameter: string
    expression: string
    value: string
    expected: number
}

const samples = readRows<Sample>(resolve(package_dir, 'src/data/arrow_returns.jsonl'))
const base = 'language/expressions/arrow/returns'
const numbers = [-1024, -99, -7, -1, 0, 1, 2, 3, 4, 17, 127, 257, 65535]
const named = new Map([
    [1, 'one'],
    [3, 'three']
])
const values = [
    { name: 'empty', items: [] },
    ...numbers.map(item => ({ name: named.get(item) ?? `value_${item}`, items: [item] })),
    { name: 'signed', items: [-7, 0, 43] },
    { name: 'repeated', items: [1, 1, 1] },
    { name: 'boundary', items: [65535, -65535] },
    { name: 'mixed', items: [-1024, 257, -1, 3] }
]

function expectedValue(name: Sample['name'], item: number): number {
    if (name === 'increment') return item + 1
    if (name === 'square') return item * item

    return item
}

for (const sample of samples) {
    const mapped = `in.items.map(${sample.parameter} => ${sample.expression})`
    const body =
        sample.name === 'object_key'
            ? `    const cells = ${mapped}\n\n    return cells.map(cell => cell.key)`
            : `    return ${mapped}`

    writeOutput(
        `tests/${base}/${sample.name}/cases.zx`,
        `export type Input = { items: i64[] }

export type Output = i64[]

export default function (in: Input): Output {
${body}
}
`
    )
    writeCatalog(
        `tests/${base}/${sample.name}/cases.jsonl`,
        values.map(value => ({
            id: `${base}/${sample.name}/${value.name}`,
            input: { items: value.items },
            expected: { value: value.items.map(item => expectedValue(sample.name, item)) }
        }))
    )
}

writeCatalog(
    'upstream/reviews/language/expressions/arrow_returns.jsonl',
    samples.map(sample => {
        const id = `${base}/${sample.name}/${sample.value}`

        return {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: `通过单元素 map 将原 lambda 调用一次，保持原参数、表达式 body 与唯一运行时值断言；${sample.name === 'object_key' ? '记录返回在随后字段投影中读取 key。' : '数值结果按原断言验证。'}var 与一等函数调用宿主改为 ZX inline callback，因此属于适配，未声称原 JavaScript 文件直接运行于 zxc。`,
            contract: 'packages/compiler/src/zx/analysis/transforms.zig',
            cases: [id],
            assertions: [{ case: id, field: 'value', expected: [sample.expected] }]
        }
    })
)
