import assert from 'node:assert/strict'
import { boundaries, hex } from './generate_division.ts'
import add from './models/add.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const triples = {
    cancellation_overflow: ['negative_max_finite', 'positive_max_finite', 'positive_max_finite'],
    rounding: ['positive_one', 'negative_one', 'positive_min_subnormal'],
    zeros: ['negative_zero', 'negative_zero', 'positive_zero'],
    subnormal: ['positive_min_subnormal', 'positive_min_subnormal', 'negative_min_subnormal'],
    infinities: ['negative_infinity', 'positive_infinity', 'positive_one'],
    nan: ['positive_one', 'nan', 'negative_one']
}
const expressions = {
    default: 'in.left + in.right + in.third',
    left: '(in.left + in.right) + in.third',
    right: 'in.left + (in.right + in.third)'
}

for (const width of [32, 64]) {
    const scalar = `f${width}`
    const values = boundaries(width)

    for (const [group, expression] of Object.entries(expressions)) {
        const rows = []

        for (const [name, [a, b, c]] of Object.entries(triples)) {
            const left = values[a]
            const right = values[b]
            const third = values[c]
            const inner = add({
                left_bits: group === 'right' ? right : left,
                right_bits: group === 'right' ? third : right,
                width
            })
            const expected =
                inner === 'nan'
                    ? 'nan'
                    : add({
                          left_bits: group === 'right' ? left : inner,
                          right_bits: group === 'right' ? inner : third,
                          width
                      })
            const buffer = Buffer.alloc(8)
            const readNumber = (bits: bigint): number => {
                if (width === 32) {
                    buffer.writeUInt32LE(Number(bits))
                    return buffer.readFloatLE()
                }

                buffer.writeBigUInt64LE(bits)
                return buffer.readDoubleLE()
            }
            const sum = (a: number, b: number): number => (width === 32 ? Math.fround(a + b) : a + b)
            const node_value =
                group === 'right'
                    ? sum(readNumber(left), sum(readNumber(right), readNumber(third)))
                    : sum(sum(readNumber(left), readNumber(right)), readNumber(third))

            if (Number.isNaN(node_value)) assert.equal(expected, 'nan')
            else {
                if (width === 32) buffer.writeFloatLE(node_value)
                else buffer.writeDoubleLE(node_value)

                assert.equal(expected, width === 32 ? BigInt(buffer.readUInt32LE()) : buffer.readBigUInt64LE())
            }

            rows.push({
                id: `language/expressions/addition/grouping/${scalar}/${group}/${name}`,
                left: hex(left, width),
                right: hex(right, width),
                third: hex(third, width),
                expected: hex(expected, width)
            })
        }

        const base = `tests/language/expressions/addition/grouping/${scalar}/${group}`

        writeCatalog(base + '.jsonl', rows)
        writeOutput(
            base + '.zx',
            `export type Input = { left: ${scalar}
 right: ${scalar}
 third: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  return ${expression}
}
`
        )
    }
}

const source =
    'export type Input = { prefix: string\n left: u64\n right: u64 }\n\nexport type Output = { left: string\n right: string }\n\nexport default function (in: Input): Output {\n  const text = `${in.prefix}${in.left}`\n\n  return { left: `${text}${in.right}`, right: `${in.prefix}${in.left + in.right}` }\n}\n'
const inputs = [
    { prefix: '1', left: 1, right: 1 },
    { prefix: '值', left: 2, right: 3 },
    { prefix: '', left: 0, right: 0 },
    { prefix: '0', left: 10, right: 2 }
]
const rows = inputs.map((input, index) => ({
    id: `language/expressions/addition/grouping/strings/${index}`,
    input,
    expected: {
        value: {
            left: `${input.prefix}${input.left}${input.right}`,
            right: `${input.prefix}${input.left + input.right}`
        }
    }
}))

writeCatalog('tests/language/expressions/addition/grouping/strings.jsonl', rows)
writeOutput('tests/language/expressions/addition/grouping/strings.zx', source)
