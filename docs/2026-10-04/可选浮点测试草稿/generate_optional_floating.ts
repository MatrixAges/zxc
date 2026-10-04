import { boundaries } from './generate_division.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

function equalValues(args: { left: bigint | null; right: bigint | null; width: number }): boolean {
	const { left, right, width } = args

	if (left === null || right === null) return left === right

	const fraction_bits = BigInt(width === 32 ? 23 : 52)
	const sign = 1n << BigInt(width - 1)
	const infinity = ((1n << (BigInt(width) - fraction_bits - 1n)) - 1n) << fraction_bits
	const left_magnitude = left & (sign - 1n)
	const right_magnitude = right & (sign - 1n)

	if (left_magnitude > infinity || right_magnitude > infinity) return false
	if (left_magnitude === 0n && right_magnitude === 0n) return true

	return left === right
}

for (const width of [32, 64]) {
	const scalar = `f${width}`
	const original = boundaries(width)
	const sign = 1n << BigInt(width - 1)
	const values: Record<string, bigint | null> = {
		...original,
		none: null,
		negative_nan: original.nan | sign,
		positive_signaling_nan: original.positive_infinity | 1n,
		negative_signaling_nan: original.negative_infinity | 1n,
	}
	const rows = []

	for (const [left_name, left] of Object.entries(values)) {
		for (const [right_name, right] of Object.entries(values)) {
			const equal = equalValues({ left, right, width })

			rows.push({
				id: `language/expressions/comparison/optional_bits/${scalar}/${left_name}/${right_name}`,
				input: { left, right },
				expected: { value: { equal, different: !equal, left_none: left === null, right_none: right === null, none_left: left === null, none_right: right === null } },
			})
		}
	}

	const base = `tests/language/expressions/comparison/optional_bits/${scalar}`

	writeCatalog(base + '.jsonl', rows)
	writeOutput(base + '.zx', `export type Input = { left: ${scalar}?; right: ${scalar}?; };\n\nexport type Output = { equal: bool; different: bool; left_none: bool; right_none: bool; none_left: bool; none_right: bool; };\n\nexport default function (in: Input): Output {\n  return { equal: in.left == in.right, different: in.left != in.right, left_none: in.left == null, right_none: in.right == null, none_left: null == in.left, none_right: null == in.right };\n}\n`)
}
