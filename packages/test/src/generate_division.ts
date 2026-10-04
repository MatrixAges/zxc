import { divide, encode } from './models/ieee.ts'
import Rational from './models/rational.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

export function boundaries(width: number): Record<string, bigint> {
	const fraction_bits = BigInt(width === 32 ? 23 : 52)
	const exponent_bits = BigInt(width) - fraction_bits - 1n
	const bias = (1n << (exponent_bits - 1n)) - 1n
	const infinity = ((1n << exponent_bits) - 1n) << fraction_bits
	const values: Record<string, bigint> = {
		zero: 0n,
		min_subnormal: 1n,
		next_subnormal: 2n,
		max_subnormal: (1n << fraction_bits) - 1n,
		min_normal: 1n << fraction_bits,
		next_normal: (1n << fraction_bits) + 1n,
		half: (bias - 1n) << fraction_bits,
		below_one: (bias << fraction_bits) - 1n,
		one: bias << fraction_bits,
		above_one: (bias << fraction_bits) + 1n,
		two: (bias + 1n) << fraction_bits,
		max_finite: infinity - 1n,
		infinity
	}

	for (const [name, text] of Object.entries({
		point_nine: '0.9',
		one_point_one: '1.1',
		one_point_nine: '1.9',
		two_point_one: '2.1'
	})) {
		values[name] = encode({ magnitude: Rational.decimal(text), negative: false, width }) as bigint
	}

	const signed: Record<string, bigint> = {}

	for (const [name, bits] of Object.entries(values)) {
		signed['positive_' + name] = bits
		signed['negative_' + name] = bits | (1n << BigInt(width - 1))
	}

	signed.nan = infinity | (1n << (fraction_bits - 1n))

	return signed
}

export function hex(bits: bigint | 'nan', width: number): string {
	return bits === 'nan' ? bits : bits.toString(16).padStart(width / 4, '0')
}

function main(): void {
	for (const width of [32, 64]) {
		const scalar = `f${width}`
		const base = `tests/language/expressions/division/${scalar}`
		const values = boundaries(width)
		const rows = []

		for (const [left_name, left] of Object.entries(values)) {
			for (const [right_name, right] of Object.entries(values)) {
				rows.push({
					id: `language/expressions/division/${scalar}/${left_name}/${right_name}`,
					left: hex(left, width),
					right: hex(right, width),
					expected: hex(divide({ left_bits: left, right_bits: right, width }), width)
				})
			}
		}

		writeCatalog(base + '.jsonl', rows)
		writeOutput(
			base + '.zx',
			`export type Input = { left: ${scalar}
 right: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  return in.left / in.right
}
`
		)
	}
}

if (import.meta.main) main()
