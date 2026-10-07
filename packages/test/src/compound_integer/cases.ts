import type { Operation } from './evaluate.ts'
import type { Target } from './source.ts'
import evaluate from './evaluate.ts'

export type Case = { id: string; arguments: Array<string>; expected: { status: number; stderr: string } }

export default function cases(args: { scalar: string; target: Target }): Array<Case> {
    const { scalar, target } = args
    const signed = scalar.startsWith('i')
    const width = BigInt(scalar.slice(1))
    const minimum = signed ? -(1n << (width - 1n)) : 0n
    const maximum = (1n << (width - BigInt(signed))) - 1n
    const boundaries = signed
        ? [minimum, minimum + 1n, minimum / 2n, -7n, -3n, -1n, 0n, 1n, 3n, 7n, maximum / 2n, maximum - 1n, maximum]
        : [0n, 1n, 2n, 3n, 7n, maximum / 2n, maximum / 2n + 1n, maximum - 1n, maximum]

    if (width === 64n) {
        boundaries.push((1n << 53n) + 1n)
        if (signed) boundaries.push(-((1n << 53n) + 1n))
    }

    const rows: Array<Case> = []
    const operations: Array<Operation> = ['add', 'subtract', 'multiply', 'divide', 'remainder']

    function add(options: {
        operation: Operation
        left: bigint
        right: bigint
        rounds: number
        selected?: number
        empty?: boolean
    }) {
        const { operation, left, right, rounds, selected = 0, empty = false } = options
        const originals = empty ? [] : [left, 3n, 9n]
        const values = [...originals]
        let value = target === 'list' ? values[selected] : left
        let outcome: string | null = null
        let status = 0

        for (let round = 0; round < rounds; round++) {
            if (target === 'list' && selected >= values.length) {
                outcome = 'ZX_ERROR=IndexOutOfBounds\n'
                break
            }

            const result = evaluate({ operation, left: value, right, minimum, maximum })

            if (typeof result === 'string') {
                outcome = `ZX_PANIC=${result}\n`
                status = 86
                break
            }

            value = result
            if (target === 'list') values[selected] = value
        }

        if (outcome === null) {
            outcome = `ZX_RESULT=${target === 'scalar' ? value : left},${target === 'nested' ? value : left},${rounds}\n`
            outcome += values
                .map((updated, index) => `ZX_VALUE=${updated},${originals[index]},${originals[index]}\n`)
                .join('')
        }

        outcome += `ZX_REQUEST=${operations.indexOf(operation)},${left},${right},${rounds},${selected},${empty ? 0 : 3},1\n`
        outcome += `ZX_INPUT=7,${left},3,9,11\n`
        rows.push({
            id: `runtime/safety/compound_integer/${scalar}/${target}/${operation}/${left}/${right}/${rounds}/${selected}/${empty}`,
            arguments: [operations.indexOf(operation), left, right, rounds, selected, empty].map(String),
            expected: { status, stderr: outcome }
        })
    }

    for (const operation of operations) {
        for (const left of boundaries) {
            for (const right of boundaries) {
                for (const rounds of [1, 2]) add({ operation, left, right, rounds })

                const first = evaluate({ operation, left, right, minimum, maximum })
                if (typeof first === 'string') add({ operation, left, right, rounds: 0 })
            }
        }

        add({ operation, left: minimum, right: 1n, rounds: 2, selected: 2 })
        add({ operation, left: maximum, right: 0n, rounds: 0, empty: true })

        if (target === 'list') {
            add({ operation, left: maximum, right: 0n, rounds: 1, selected: 3 })
            add({ operation, left: maximum, right: 0n, rounds: 1, empty: true })
            add({ operation, left: maximum, right: 1n, rounds: 1, selected: 3 })
        }
    }

    return rows
}
