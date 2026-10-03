import { decode, encode } from './ieee.ts'
import Rational from './rational.ts'

export default function add(args: { left_bits: bigint; right_bits: bigint; width: number }): bigint | 'nan' {
	const { left_bits, right_bits, width } = args
	const left = decode(left_bits, width)
	const right = decode(right_bits, width)
	const left_negative = Boolean(left_bits >> BigInt(width - 1))
	const right_negative = Boolean(right_bits >> BigInt(width - 1))

	if (left === 'nan' || right === 'nan') return 'nan'
	if (left === 'inf' && right === 'inf' && left_negative !== right_negative) return 'nan'
	if (left === 'inf' || right === 'inf')
		return encode({ magnitude: 'inf', negative: left === 'inf' ? left_negative : right_negative, width })

	const numerator =
		left.numerator * right.denominator * (left_negative ? -1n : 1n) +
		right.numerator * left.denominator * (right_negative ? -1n : 1n)
	const negative = numerator < 0n || (numerator === 0n && left_negative && right_negative)
	const magnitude = new Rational(numerator < 0n ? -numerator : numerator, left.denominator * right.denominator)

	return encode({ magnitude, negative, width })
}
