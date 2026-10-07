import assert from 'node:assert/strict'
import { boundaries, hex } from './generate_division.ts'
import add from './models/add.ts'
import { divide, encode, powerOfTwo } from './models/ieee.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

for (const width of [32, 64]) {
    const scalar = `f${width}`
    const values = boundaries(width)
    const reciprocal = divide({ left_bits: values.positive_one, right_bits: values.positive_max_finite, width })

    assert.notEqual(reciprocal, 'nan')

    values.positive_reciprocal_max = reciprocal as bigint
    values.negative_reciprocal_max = (reciprocal as bigint) | (1n << BigInt(width - 1))

    for (const negative of [false, true]) {
        values[`${negative ? 'negative' : 'positive'}_half_ulp_one`] = encode({
            magnitude: powerOfTwo(width === 32 ? -24 : -53),
            negative,
            width
        }) as bigint
    }

    const rows = []

    for (const [left_name, left_bits] of Object.entries(values)) {
        for (const [right_name, right_bits] of Object.entries(values)) {
            const expected = add({ left_bits, right_bits, width })
            const buffer = Buffer.alloc(8)
            const readNumber = (bits: bigint): number => {
                if (width === 32) {
                    buffer.writeUInt32LE(Number(bits))
                    return buffer.readFloatLE()
                }

                buffer.writeBigUInt64LE(bits)
                return buffer.readDoubleLE()
            }
            const sum = readNumber(left_bits) + readNumber(right_bits)

            if (Number.isNaN(sum)) assert.equal(expected, 'nan')
            else if (width === 32) {
                buffer.writeFloatLE(sum)
                assert.equal(expected, BigInt(buffer.readUInt32LE()))
            } else {
                buffer.writeDoubleLE(sum)
                assert.equal(expected, buffer.readBigUInt64LE())
            }

            rows.push({
                id: `language/expressions/addition/${scalar}/${left_name}/${right_name}`,
                left: hex(left_bits, width),
                right: hex(right_bits, width),
                expected: hex(expected, width)
            })
        }
    }

    const base = `tests/language/expressions/addition/${scalar}`

    writeCatalog(base + '.jsonl', rows)
    writeOutput(
        base + '.zx',
        `export type Input = { left: ${scalar}
 right: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  return in.left + in.right
}
`
    )
}
