import { boundaries, hex } from './generate_division.ts'
import { decode } from './models/ieee.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

function equal(args: { left: bigint; right: bigint; width: number }): boolean {
	const { left, right, width } = args
	const magnitude_mask = (1n << BigInt(width - 1)) - 1n

	if (decode(left, width) === 'nan' || decode(right, width) === 'nan') return false

	return left === right || ((left & magnitude_mask) === 0n && (right & magnitude_mask) === 0n)
}

for (const width of [32, 64]) {
	const type = `f${width}`
	const prefix = `language/expressions/match/floating/${type}`
	const values = boundaries(width)
	const comparisons = []
	const selections = []

	for (const [left_name, left] of Object.entries(values)) {
		for (const [right_name, right] of Object.entries(values)) {
			comparisons.push({ id: `${prefix}/comparison/${left_name}/${right_name}`, left: hex(left, width), right: hex(right, width), expected: hex(equal({ left, right, width }) ? values.positive_one : values.positive_zero, width) })
		}
	}

	for (const [name, bits] of Object.entries(values)) {
		const expected = decode(bits, width) === 'nan' ? 'nan' : hex(bits, width)

		for (const [path, left, right] of [
			['equal_one', values.positive_one, values.positive_one],
			['opposite_zeros', values.positive_zero, values.negative_zero],
		] as const) {
			selections.push({ id: `${prefix}/selection/${path}/${name}`, left: hex(left, width), right: hex(right, width), third: hex(bits, width), expected })
		}

		selections.push({ id: `${prefix}/selection/nan_pattern/${name}`, left: hex(bits, width), right: hex(values.nan, width), third: hex(values.negative_one, width), expected })
	}

	writeOutput(`tests/${prefix}/comparison.zx`, `export type Input = { left: ${type}; right: ${type}; };\n\nexport type Output = ${type};\n\nexport default function (in: Input): Output {\n  return match in.left {\n    in.right => 1,\n    _ => 0,\n  };\n}\n`)
	writeCatalog(`tests/${prefix}/comparison.jsonl`, comparisons)
	writeOutput(`tests/${prefix}/selection.zx`, `export type Input = { left: ${type}; right: ${type}; third: ${type}; };\n\nexport type Output = ${type};\n\nexport default function (in: Input): Output {\n  return match in.left {\n    in.right => in.third,\n    _ => in.left,\n  };\n}\n`)
	writeCatalog(`tests/${prefix}/selection.jsonl`, selections)
}
