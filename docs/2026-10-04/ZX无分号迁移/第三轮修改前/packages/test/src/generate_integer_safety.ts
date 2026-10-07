import { writeCatalog, writeOutput } from './shared/catalog.ts'

function cases(scalar: string) {
    const width = BigInt(scalar.slice(1))
    const signed = scalar.startsWith('i')
    const minimum = signed ? -(2n ** (width - 1n)) : 0n
    const maximum = 2n ** (width - BigInt(signed)) - 1n
    const examples: Array<[string, number, bigint, bigint, bigint | string]> = [
        ['add', 0, maximum, 0n, maximum],
        ['add', 0, minimum, 0n, minimum],
        ['add', 0, maximum, 1n, 'integer overflow'],
        ['subtract', 1, minimum, 1n, 'integer overflow'],
        ['subtract', 1, maximum, maximum, 0n],
        ['multiply', 2, maximum, 1n, maximum],
        ['multiply', 2, maximum, 2n, 'integer overflow'],
        ['divide', 3, 7n, 3n, 2n],
        ['divide', 3, 1n, 0n, 'division by zero'],
        ['remainder', 4, 7n, 3n, 1n],
        ['remainder', 4, 1n, 0n, 'division by zero']
    ]

    if (signed) {
        examples.push(
            ['multiply', 2, minimum, -1n, 'integer overflow'],
            ['divide', 3, minimum, -1n, 'integer overflow'],
            ['divide', 3, -7n, 3n, -2n],
            ['divide', 3, 7n, -3n, -2n],
            ['remainder', 4, -7n, 3n, -1n],
            ['remainder', 4, 7n, -3n, 1n],
            ['remainder', 4, minimum, -1n, 0n]
        )

        const boundaries = [
            minimum,
            minimum + 1n,
            minimum / 2n,
            -7n,
            -3n,
            -1n,
            0n,
            1n,
            3n,
            7n,
            maximum / 2n,
            maximum - 1n,
            maximum
        ]

        const unary_boundaries = [...boundaries]

        for (const value of [0x1fffffffffffff01n, -0x1fffffffffffff01n]) {
            if (value >= minimum && value <= maximum) unary_boundaries.push(value)
        }

        for (const left of unary_boundaries) {
            for (const [name, operation, count] of [
                ['negate', 5, 1],
                ['double_negate', 6, 2]
            ] as const) {
                let result = left
                let overflow = false

                for (let index = 0; index < count; index++) {
                    const next = -result
                    if (next < minimum || next > maximum) {
                        overflow = true
                        break
                    }

                    result = next
                }

                examples.push([name, operation, left, 0n, overflow ? 'integer overflow' : result])
            }
        }

        for (const left of boundaries) {
            for (const right of boundaries)
                examples.push([
                    'remainder',
                    4,
                    left,
                    right,
                    right === 0n ? 'division by zero' : left - (left / right) * right
                ])
        }
    }

    const seen = new Set<string>()
    const rows = []

    for (const [name, operation, left, right, result] of examples) {
        const key = `${operation}/${left}/${right}`
        if (seen.has(key)) continue
        seen.add(key)

        rows.push({
            id: `runtime/safety/integer/${scalar}/${name}/${left}/${right}`,
            arguments: [String(operation), String(left), String(right)],
            expected: typeof result === 'string' ? { panic: result } : { value: result }
        })
    }

    return rows
}

for (const scalar of ['u8', 'u16', 'u32', 'u64', 'i32', 'i64']) {
    const unary = scalar.startsWith('i') ? '    case 5: return -in.left;\n    case 6: return -(-in.left);\n' : ''
    const source = `export type Input = { operation: u8
 left: ${scalar}
 right: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  switch (in.operation) {
    case 0: return in.left + in.right
    case 1: return in.left - in.right
    case 2: return in.left * in.right
    case 3: return in.left / in.right
    case 4: return in.left % in.right
${unary}    default: return in.left
  }
}
`
    const base = `tests/runtime/safety/integer/${scalar}`

    writeCatalog(base + '.jsonl', cases(scalar))
    writeOutput(base + '.zx', source)
}
