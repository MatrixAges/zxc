import Rational from './rational.ts'

type Magnitude = Rational | 'nan' | 'inf'

export function powerOfTwo(exponent: number): Rational {
	return exponent >= 0 ? new Rational(2n ** BigInt(exponent)) : new Rational(1n, 2n ** BigInt(-exponent))
}

export function decode(bits: bigint, width: number): Magnitude {
	const fraction_bits = width === 32 ? 23 : 52
	const exponent_bits = width - fraction_bits - 1
	const bias = (1 << (exponent_bits - 1)) - 1
	const exponent = Number((bits >> BigInt(fraction_bits)) & ((1n << BigInt(exponent_bits)) - 1n))
	const fraction = bits & ((1n << BigInt(fraction_bits)) - 1n)

	if (exponent === (1 << exponent_bits) - 1) return fraction ? 'nan' : 'inf'

	const significand = exponent === 0 ? fraction : fraction + (1n << BigInt(fraction_bits))
	const scale = powerOfTwo(Math.max(exponent, 1) - bias - fraction_bits)

	return new Rational(significand * scale.numerator, scale.denominator)
}

export function encode(args: { magnitude: Magnitude; negative: boolean; width: number }): bigint | 'nan' {
	const { magnitude, negative, width } = args
	const fraction_bits = width === 32 ? 23 : 52
	const exponent_bits = width - fraction_bits - 1
	const bias = (1 << (exponent_bits - 1)) - 1
	const sign = BigInt(negative) << BigInt(width - 1)

	if (magnitude === 'nan') return 'nan'
	if (magnitude === 'inf') return sign | (((1n << BigInt(exponent_bits)) - 1n) << BigInt(fraction_bits))
	if (magnitude.numerator === 0n) return sign

	let exponent = magnitude.numerator.toString(2).length - magnitude.denominator.toString(2).length

	if (magnitude.compare(powerOfTwo(exponent)) < 0) exponent--

	const scale = Math.max(exponent, 1 - bias) - fraction_bits
	const units = magnitude.divide(powerOfTwo(scale))
	let rounded = units.numerator / units.denominator
	const remainder = units.numerator % units.denominator

	if (remainder * 2n > units.denominator || (remainder * 2n === units.denominator && rounded % 2n !== 0n)) rounded++
	if (exponent < 1 - bias) return sign | rounded

	if (rounded === 1n << BigInt(fraction_bits + 1)) {
		rounded >>= 1n
		exponent++
	}

	if (exponent > bias) return encode({ magnitude: 'inf', negative, width })

	return sign | (BigInt(exponent + bias) << BigInt(fraction_bits)) | (rounded - (1n << BigInt(fraction_bits)))
}

export function divide(args: { left_bits: bigint; right_bits: bigint; width: number }): bigint | 'nan' {
	const { left_bits, right_bits, width } = args
	const left = decode(left_bits, width)
	const right = decode(right_bits, width)
	const negative = Boolean((left_bits ^ right_bits) >> BigInt(width - 1))
	const left_zero = left instanceof Rational && left.numerator === 0n
	const right_zero = right instanceof Rational && right.numerator === 0n

	if (left === 'nan' || right === 'nan' || (left === 'inf' && right === 'inf') || (left_zero && right_zero))
		return 'nan'
	if (left === 'inf' || right_zero) return encode({ magnitude: 'inf', negative, width })
	if (right === 'inf') return encode({ magnitude: new Rational(0n), negative, width })

	return encode({ magnitude: left.divide(right), negative, width })
}
