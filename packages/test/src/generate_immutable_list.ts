import type { Input, Operation, Row } from './immutable_list/cases.ts'
import expectation from './immutable_list/cases.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'built_ins/list/immutable'
const samples = [
    [],
    [0],
    [-7],
    [7],
    [0, 1, 2],
    [2, 0, 1],
    [1, 1, 1],
    [-11, 0, 11],
    [2, -2, 2, -2],
    [-65535, 65535, 0],
    Array.from({ length: 257 }, (_, index) => (index % 17) - 8),
    Array.from({ length: 1024 }, (_, index) => (index % 31) - 15)
]
const originals = [
    {
        operation: 'reverse',
        method: 'toReversed',
        sha256: '869667ec1490c4376aaae40e1ff47d60b8992ed6b38ecea22351b06d4d02f868'
    },
    {
        operation: 'sort',
        method: 'toSorted',
        sha256: '4c934e51f80bae86d5b1534b748711e202c0070e4b6332e1a0ffb629ebbc3dc8'
    },
    {
        operation: 'splice',
        method: 'toSpliced',
        sha256: '3af4b93ea0e7a906f359b575db715ab05bcd987c98f8b3731a07237f1f44dc97'
    },
    { operation: 'with', method: 'with', sha256: '162db523043aba54c7c9da9c6a875a4db6e930d16a3777d5c07d46311dfa2b5f' }
] as const
const reviews = []

for (const original of originals) {
    const operation: Operation = original.operation
    const rows: Array<Row> = []

    function append(args: { name: string; input: Input; later: Input }): void {
        const { name, input, later } = args

        const value = expectation(operation, input)
        const following = expectation(operation, later)

        rows.push({
            id: `${base}/${operation}/${name}`,
            input,
            later,
            check: 'values',
            expected: {
                value,
                later: following,
                unchanged: true,
                new_storage: value.length > 0,
                later_new_storage: following.length > 0
            }
        })
    }

    const items = operation === 'sort' || operation === 'splice' ? [2, 0, 1] : [0, 1, 2]
    const input = { items, index: operation === 'with' ? 1 : 0, count: 0, replacement: [-1], value: 3 }
    const later = { ...input, count: operation === 'splice' ? 1 : 0, value: operation === 'with' ? 1 : 3 }

    append({ name: 'original', input, later })

    for (const [sample, items] of samples.entries()) {
        const positions = [...new Set([0, Math.floor(items.length / 2), items.length])]

        if (operation === 'with' && !items.length) continue

        for (const index of operation === 'reverse' || operation === 'sort'
            ? [0]
            : positions.filter(index => operation !== 'with' || index < items.length)) {
            const counts = operation === 'splice' ? [...new Set([0, items.length - index])] : [0]
            const replacements = operation === 'splice' ? [[], [-1], [3, 0, -3]] : [[]]
            const values = operation === 'with' ? [...new Set([-7, 0, 7, items[index]])] : [0]

            for (const count of counts)
                for (const replacement of replacements)
                    for (const value of values) {
                        const input = { items, index, count, replacement, value }
                        const later = {
                            ...input,
                            count: operation === 'splice' ? Math.min(1, items.length - index) : count,
                            value: operation === 'with' ? items[index] : value
                        }

                        append({
                            name: `sample_${sample}/index_${index}/count_${count}/insert_${replacement.join('_') || 'empty'}/value_${value}`,
                            input,
                            later
                        })
                    }
        }
    }

    rows.push({ ...rows[0], id: `${base}/${operation}/allocation_failures`, check: 'allocations' })
    writeCatalog(`tests/${base}/${operation}.jsonl`, rows)

    const expression =
        operation === 'with'
            ? 'in.items.with(in.index, in.value)'
            : `in.items.${operation}(${operation === 'splice' ? 'in.index, in.count, in.replacement' : ''})[0]`

    writeOutput(
        `tests/${base}/${operation}.zx`,
        `export type Input = { items: i64[], index: u64, count: u64, replacement: i64[], value: i64 }

export type Output = i64[]

export default function (in: Input): Output {
    return ${expression}
}
`
    )

    reviews.push({
        path: `test/built-ins/Array/prototype/${original.method}/immutable.js`,
        sha256: original.sha256,
        status: 'adapted',
        reason: '完整保留首次真实调用并丢弃结果后的原输入检查、重复调用的新结果身份；splice 第三次删除一个元素，with 第三次替换为原值。映射 ZX 不可变列表操作，仅原文密集整数输入，不扩展 JavaScript 对象、洞或默认字典序契约。',
        contract: 'packages/core/IR契约.md#所有权与集合回调',
        cases: [rows[0].id],
        assertions: [
            'unchanged',
            'new_storage',
            ...(operation === 'splice' || operation === 'with' ? ['later_new_storage'] : [])
        ].map(field => ({ case: rows[0].id, field, expected: true }))
    })
}

writeCatalog('upstream/reviews/built_ins/array/immutable_list.jsonl', reviews)
