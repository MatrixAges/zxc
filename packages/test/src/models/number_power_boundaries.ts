import assert from 'node:assert/strict'
import { encode, powerOfTwo } from './ieee.ts'
import multiply from './multiply.ts'
import subtract from './subtract.ts'

export type Sample =
    | { kind: 'power'; left: number }
    | { kind: 'overflow'; left: number; right: number }
    | { kind: 'product' | 'maximum'; left: number; right: number; third: number }

function bits(value: number): bigint {
    const buffer = Buffer.alloc(8)

    buffer.writeDoubleBE(value)

    return buffer.readBigUInt64BE()
}

function power(exponent: number): bigint {
    assert(Number.isInteger(exponent) && exponent >= 0 && exponent <= 1024)

    const expected = encode({ magnitude: powerOfTwo(exponent), negative: false, width: 64 })

    assert.equal(expected, bits(Math.pow(2, exponent)))
    assert(typeof expected === 'bigint')

    return expected
}

export default function numberPowerBoundary(sample: Sample): string {
    const { kind, left } = sample

    if (kind === 'power') return power(left).toString(16).padStart(16, '0')

    let operand = bits(sample.right)
    let actual_operand = sample.right

    if (kind !== 'overflow') {
        operand = power(sample.right)
        actual_operand = Math.pow(2, sample.right)

        if (kind === 'maximum') {
            const reduced = subtract({ left_bits: operand, right_bits: bits(1), width: 64 })

            actual_operand -= 1
            assert.equal(reduced, bits(actual_operand))
            assert(typeof reduced === 'bigint')
            operand = reduced
        }
    }

    let expected = multiply({ left_bits: bits(left), right_bits: operand, width: 64 })
    let actual = left * actual_operand

    assert.equal(expected, bits(actual))
    assert(typeof expected === 'bigint')

    if (kind !== 'overflow') {
        expected = multiply({ left_bits: expected, right_bits: power(sample.third), width: 64 })
        actual *= Math.pow(2, sample.third)
        assert.equal(expected, bits(actual))
    }

    assert(typeof expected === 'bigint')

    return expected.toString(16).padStart(16, '0')
}
