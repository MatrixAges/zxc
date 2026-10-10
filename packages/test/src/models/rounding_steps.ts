import add from './add.ts'
import { divide, encode } from './ieee.ts'
import Rational from './rational.ts'
import subtract from './subtract.ts'

function integerBits(value: bigint): bigint {
    const negative = value < 0n

    return resultBits(encode({ magnitude: new Rational(negative ? -value : value), negative, width: 64 }))
}

function resultBits(value: bigint | 'nan'): bigint {
    if (value === 'nan') throw new Error('rounding step produced NaN')

    return value
}

export default function roundingSteps(input: bigint) {
    const x = integerBits(input)
    const one = integerBits(1n)
    const quotient = resultBits(divide({ left_bits: one, right_bits: integerBits(65536n), width: 64 }))
    const y = resultBits(subtract({ left_bits: one, right_bits: quotient, width: 64 }))
    const z = resultBits(add({ left_bits: x, right_bits: y, width: 64 }))
    const d = resultBits(subtract({ left_bits: z, right_bits: x, width: 64 }))

    return { x, quotient, y, z, d }
}
