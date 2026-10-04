import assert from 'node:assert/strict'
import { boundaries, hex } from './generate_division.ts'
import { encode } from './models/ieee.ts'
import multiply from './models/multiply.ts'
import Rational from './models/rational.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

for (const width of [32, 64]) {
	const scalar = `f${width}`
	const values = boundaries(width)

	for (const [name, decimal] of Object.entries({ point_one: '0.1', point_five_one: '0.51' })) {
		for (const negative of [false, true]) {
			values[`${negative ? 'negative' : 'positive'}_${name}`] = encode({
				magnitude: Rational.decimal(decimal),
				negative,
				width
			}) as bigint
		}
	}

	const rows = []

	for (const [left_name, left_bits] of Object.entries(values)) {
		for (const [right_name, right_bits] of Object.entries(values)) {
			const expected = multiply({ left_bits, right_bits, width })
			const buffer = Buffer.alloc(8)
			const readNumber = (bits: bigint): number => {
				if (width === 32) {
					buffer.writeUInt32LE(Number(bits))
					return buffer.readFloatLE()
				}

				buffer.writeBigUInt64LE(bits)
				return buffer.readDoubleLE()
			}
			const product = readNumber(left_bits) * readNumber(right_bits)

			if (Number.isNaN(product)) assert.equal(expected, 'nan')
			else if (width === 32) {
				buffer.writeFloatLE(product)
				assert.equal(expected, BigInt(buffer.readUInt32LE()))
			} else {
				buffer.writeDoubleLE(product)
				assert.equal(expected, buffer.readBigUInt64LE())
			}

			rows.push({
				id: `language/expressions/multiplication/${scalar}/${left_name}/${right_name}`,
				left: hex(left_bits, width),
				right: hex(right_bits, width),
				expected: hex(expected, width)
			})
		}
	}

	const base = `tests/language/expressions/multiplication/${scalar}`

	writeCatalog(base + '.jsonl', rows)
	writeOutput(
		base + '.zx',
		`export type Input = { left: ${scalar}
 right: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  return in.left * in.right
}
`
	)
}
