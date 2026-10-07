import type { Case, Operation, Stage } from './cases.ts'
import { maximum, minimum } from './cases.ts'

function calculate(args: { operation: Operation; left: bigint; right: bigint }): bigint | string {
    const { operation, left, right } = args

    if ((operation === 'divide' || operation === 'remainder') && right === 0n) return 'division by zero'

    const value =
        operation === 'add'
            ? left + right
            : operation === 'subtract'
              ? left - right
              : operation === 'multiply'
                ? left * right
                : operation === 'divide'
                  ? left / right
                  : left % right

    return value < minimum || value > maximum ? 'integer overflow' : value
}

export default function expected(args: { row: Case; operation: Operation; nested: boolean }) {
    const { row, operation, nested } = args
    const events: Array<string> = []
    const stages: Array<Stage> = nested
        ? ['source', 'container', 'index', 'value', 'after']
        : ['source', 'index', 'value', 'after']
    const originals = row.empty ? [] : [row.left, 3n, 9n]
    const values = [...originals]
    let outcome = `ZX_RESULT=${row.outer},0\n`
    let status = 0

    outer: for (let round = 0; round < row.outer * row.inner; round++) {
        for (const stage of stages) {
            const payload =
                stage === 'source'
                    ? BigInt(values.length)
                    : stage === 'container'
                      ? BigInt(!row.enabled)
                      : stage === 'index'
                        ? BigInt(row.selected)
                        : stage === 'value'
                          ? row.right
                          : BigInt(round % row.inner)
            const sample = stage === 'source' ? (values[row.selected] ?? 0n) : 0n

            events.push(`ZX_EVENT=${stage},${payload},${sample}\n`)

            if (row.failure === stage && row.occurrence === round + 1) {
                outcome = `ZX_ERROR=${stage[0].toUpperCase() + stage.slice(1)}Failure\n`
                break outer
            }

            if ((stage === 'container' && !row.enabled) || (stage === 'index' && row.selected >= values.length)) {
                outcome = 'ZX_ERROR=IndexOutOfBounds\n'
                break outer
            }

            if (stage === 'value') {
                const value = calculate({ operation, left: values[row.selected], right: row.right })

                if (typeof value === 'string') {
                    outcome = `ZX_PANIC=${value}\n`
                    status = 86
                    break outer
                }

                values[row.selected] = value
            }
        }
    }

    const result = outcome.startsWith('ZX_RESULT')
        ? values.map((value, index) => `ZX_VALUE=${value},${originals[index]},${originals[index]}\n`).join('')
        : ''
    const input = `ZX_INPUT=-1234567,${row.left},3,9,7654321\n`

    return { status, stderr: outcome + result + events.join('') + input }
}
