import assert from 'node:assert/strict'
import { divide } from './models/ieee.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const prefix = 'language/types/number/signed_zero/division'
const sign = 1n << 63n
const magnitude = sign - 1n

function bits(value: number): bigint {
    const buffer = Buffer.alloc(8)

    buffer.writeDoubleBE(value)

    return buffer.readBigUInt64BE()
}

function expected(input: { numerator: number; divisor: number }): boolean {
    const left_bits = bits(input.numerator)
    const right_bits = bits(input.divisor)
    const positive = divide({ left_bits, right_bits, width: 64 })
    const negative = divide({ left_bits, right_bits: right_bits ^ sign, width: 64 })
    const unequal =
        positive === 'nan' ||
        negative === 'nan' ||
        (positive !== negative && ((positive & magnitude) !== 0n || (negative & magnitude) !== 0n))

    assert.equal(unequal, input.numerator / input.divisor !== input.numerator / -input.divisor)

    return unequal
}

writeOutput(
    `tests/${prefix}.zx`,
    `export type Input = { numerator: f64, divisor: f64 }

export type Output = bool

export default function (in: Input): Output {
  const p_zero = in.divisor
  const n_zero = -p_zero
  const positive = in.numerator / p_zero
  const negative = in.numerator / n_zero

  return positive != negative
}
`
)
writeCatalog(
    `tests/${prefix}.jsonl`,
    [
        { name: 'original', numerator: 1, divisor: 0 },
        { name: 'zero_numerator_control', numerator: 0, divisor: 1 }
    ].map(({ name, ...input }) => ({ id: `${prefix}/${name}`, input, expected: { value: expected(input) } }))
)
