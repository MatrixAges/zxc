import { boundaries, hex } from './generate_division.ts'
import { divide } from './models/ieee.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const left_names = ['positive', 'negative'].flatMap(sign =>
	['zero', 'min_subnormal', 'max_finite'].map(value => `${sign}_${value}`)
)
left_names.push('positive_one', 'positive_infinity', 'nan')
const right_names = ['positive_point_nine', 'negative_point_nine', 'positive_two', 'positive_zero']

for (const width of [32, 64]) {
	const scalar = `f${width}`
	const values = boundaries(width)

	for (const [group, expression] of [
		['right', 'in.left / (in.left / in.right)'],
		['left', '(in.left / in.left) / in.right']
	]) {
		const rows = []

		for (const left_name of left_names) {
			for (const right_name of right_names) {
				const left = values[left_name]
				const right = values[right_name]
				const inner = divide({ left_bits: left, right_bits: group === 'right' ? right : left, width })
				const expected =
					inner === 'nan'
						? 'nan'
						: group === 'right'
							? divide({ left_bits: left, right_bits: inner, width })
							: divide({ left_bits: inner, right_bits: right, width })

				rows.push({
					id: `language/expressions/division/grouping/${scalar}/${group}/${left_name}/${right_name}`,
					left: hex(left, width),
					right: hex(right, width),
					expected: hex(expected, width)
				})
			}
		}

		const base = `tests/language/expressions/division/grouping/${scalar}/${group}`
		writeCatalog(base + '.jsonl', rows)
		writeOutput(
			base + '.zx',
			`export type Input = { left: ${scalar}
 right: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  return ${expression}
}
`
		)
	}
}
