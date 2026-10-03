import { decode, encode } from './ieee.ts'
import Rational from './rational.ts'

export default function remainder(args: { left_bits: bigint; right_bits: bigint; width: number }): bigint | 'nan' {
	const { left_bits, right_bits, width } = args
	const left = decode(left_bits, width)
	const right = decode(right_bits, width)
	const negative = Boolean(left_bits >> BigInt(width - 1))

	if (left === 'nan' || right === 'nan' || left === 'inf') return 'nan'
	if (right instanceof Rational && right.numerator === 0n) return 'nan'
	if (right === 'inf' || left.numerator === 0n) return left_bits

	const numerator = left.numerator * right.denominator
	const divisor = left.denominator * right.numerator
	const quotient = numerator / divisor
	const magnitude = new Rational(numerator - quotient * divisor, left.denominator * right.denominator)

	return encode({ magnitude, negative, width })
}
