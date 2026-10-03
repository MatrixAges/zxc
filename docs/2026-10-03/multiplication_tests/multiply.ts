import { decode, encode } from './ieee.ts'
import Rational from './rational.ts'

export default function multiply(args: { left_bits: bigint; right_bits: bigint; width: number }): bigint | 'nan' {
	const { left_bits, right_bits, width } = args
	const left = decode(left_bits, width)
	const right = decode(right_bits, width)
	const negative = Boolean((left_bits ^ right_bits) >> BigInt(width - 1))
	const left_zero = left instanceof Rational && left.numerator === 0n
	const right_zero = right instanceof Rational && right.numerator === 0n

	if (left === 'nan' || right === 'nan' || (left === 'inf' && right_zero) || (right === 'inf' && left_zero))
		return 'nan'
	if (left === 'inf' || right === 'inf') return encode({ magnitude: 'inf', negative, width })

	const magnitude = new Rational(left.numerator * right.numerator, left.denominator * right.denominator)

	return encode({ magnitude, negative, width })
}
