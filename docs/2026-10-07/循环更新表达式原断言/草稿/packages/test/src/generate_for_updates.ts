import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Mode = 'increment' | 'multiply' | 'divide' | 'decrement' | 'square'
type State = { i: number; j: number; limit: number; step: number }
type Row = { id: string; input: State; expected: { value: State } }

const base = 'language/statements/iteration/update'
const sources: Record<Mode, string> = {
    increment: 'state.i += state.step',
    multiply: 'state.i *= state.step',
    divide: 'state.i = state.i / state.step',
    decrement: 'state.i -= state.step',
    square: 'state.i *= state.i'
}
const original: Record<Mode, State> = {
    increment: { i: 0, j: 0, limit: 10, step: 1 },
    multiply: { i: 1, j: 0, limit: 10, step: 2 },
    divide: { i: 16, j: 0, limit: 1, step: 2 },
    decrement: { i: 10, j: 0, limit: 1, step: 1 },
    square: { i: 2, j: 0, limit: 10, step: 0 }
}
const controls: Record<Mode, Array<State>> = {
    increment: [
        { i: 0, j: 3, limit: 0, step: 1 },
        { i: 12, j: 1, limit: 10, step: 2 },
        { i: -3, j: 0, limit: 2, step: 0.5 },
        { i: 1, j: 0, limit: 9, step: 3 },
        { i: 0.5, j: 2, limit: 1, step: 0.25 },
        { i: 0, j: 0, limit: 257, step: 1 }
    ],
    multiply: [
        { i: 1, j: 3, limit: 1, step: 2 },
        { i: 12, j: 1, limit: 10, step: 2 },
        { i: 1, j: 0, limit: 100, step: 3 },
        { i: 0.5, j: 0, limit: 4, step: 2 },
        { i: 2, j: 2, limit: 9, step: 2.5 },
        { i: 1, j: 0, limit: 4096, step: 2 }
    ],
    divide: [
        { i: 1, j: 3, limit: 1, step: 2 },
        { i: 0.5, j: 1, limit: 1, step: 2 },
        { i: 9, j: 0, limit: 1, step: 3 },
        { i: 12, j: 0, limit: 2, step: 2 },
        { i: 0.5, j: 2, limit: 0.125, step: 2 },
        { i: 4096, j: 0, limit: 1, step: 2 }
    ],
    decrement: [
        { i: 1, j: 3, limit: 1, step: 1 },
        { i: 0, j: 1, limit: 1, step: 2 },
        { i: 3, j: 0, limit: -2, step: 0.5 },
        { i: 9, j: 0, limit: 1, step: 3 },
        { i: 1, j: 2, limit: 0.5, step: 0.25 },
        { i: 257, j: 0, limit: 0, step: 1 }
    ],
    square: [
        { i: 2, j: 3, limit: 2, step: 0 },
        { i: 12, j: 1, limit: 10, step: 0 },
        { i: 2, j: 0, limit: 16, step: 0 },
        { i: 4, j: 0, limit: 64, step: 0 },
        { i: 1.5, j: 2, limit: 5, step: 0 },
        { i: 2, j: 0, limit: 257, step: 0 }
    ]
}

function expectation(args: { mode: Mode; input: State }): State {
    const { mode, input } = args
    const result = { ...input }
    const ascending = mode !== 'divide' && mode !== 'decrement'

    for (; ascending ? result.i < result.limit : result.i > result.limit;) {
        result.j++

        if (mode === 'increment') result.i += result.step
        if (mode === 'multiply') result.i *= result.step
        if (mode === 'divide') result.i = result.i / result.step
        if (mode === 'decrement') result.i -= result.step
        if (mode === 'square') result.i *= result.i
    }

    return result
}

const original_rows: Array<Row> = []

for (const mode of Object.keys(sources) as Array<Mode>) {
    const original_row: Row = {
        id: `${base}/${mode}/original`,
        input: original[mode],
        expected: { value: expectation({ mode, input: original[mode] }) }
    }
    const rows = [
        original_row,
        ...controls[mode].map((input, index) => ({
            id: `${base}/${mode}/control_${index}`,
            input,
            expected: { value: expectation({ mode, input }) }
        }))
    ]
    const relation = mode === 'divide' || mode === 'decrement' ? '>' : '<'

    original_rows.push(original_row)
    writeCatalog(`tests/${base}/${mode}.jsonl`, rows)
    writeOutput(
        `tests/${base}/${mode}.zx`,
        `export type Input = { i: f64, j: f64, limit: f64, step: f64 }\n\nexport type Output = Input\n\nexport default function (in: Input): Output {\n    return loop(in, {\n        while: state => state.i ${relation} state.limit,\n        next: state => {\n            state.j += 1\n            ${sources[mode]}\n        }\n    })\n}\n`
    )
}

writeCatalog('upstream/reviews/language/statements/for_numeric_updates.jsonl', [
    {
        path: 'test/language/statements/for/S12.6.3_A14.js',
        sha256: '20af24357eea8455e30ecd0399d8236d0cbe50bee374049411d6b305ee0389e1',
        status: 'adapted',
        reason: '完整保留五组实际循环和九项原最终 i/j 断言，以 f64 保留 Number 数值。原 for/var 映射为显式 loop next 状态；被丢弃的 ++/-- 更新对应 step=1 的 +=/-=，不证明更新表达式返回值或 var 环境。首组空体的 j 是额外迭代计数观察，其他 j 与原 body 计数相同；参数保持为增强检查。',
        contract: 'docs/2026-10-06/顺序遍历与状态迭代设计.md',
        cases: original_rows.map(row => row.id),
        assertions: original_rows.map(row => ({ case: row.id, field: 'value', expected: row.expected.value }))
    }
])
