import { boundaries, hex } from './generate_division.ts'
import { decode, encode } from './models/ieee.ts'
import Rational from './models/rational.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const operators = { less: '<', less_equal: '<=', greater: '>', greater_equal: '>=', equal: '==', not_equal: '!=' }

function orderedValue(bits: bigint, width: number): [number, Rational] | null {
	const value = decode(bits, width)
	const negative = Boolean(bits >> BigInt(width - 1))

	if (value === 'nan') return null
	if (value === 'inf') return [negative ? -1 : 1, new Rational(0n)]

	return [0, negative ? value.negate() : value]
}

function expected(args: { left: bigint; right: bigint; width: number }): Record<string, boolean> {
	const { left, right, width } = args
	const left_value = orderedValue(left, width)
	const right_value = orderedValue(right, width)

	if (left_value === null || right_value === null)
		return Object.fromEntries(Object.keys(operators).map(name => [name, name === 'not_equal']))

	const comparison = left_value[0] - right_value[0] || left_value[1].compare(right_value[1])

	return {
		less: comparison < 0,
		less_equal: comparison <= 0,
		greater: comparison > 0,
		greater_equal: comparison >= 0,
		equal: comparison === 0,
		not_equal: comparison !== 0
	}
}

function makeCase(args: { identifier: string; left: bigint; right: bigint; width: number }) {
	const { identifier, left, right, width } = args

	return {
		id: `language/expressions/comparison/f${width}/${identifier}`,
		left: hex(left, width),
		right: hex(right, width),
		expected: expected({ left, right, width })
	}
}

for (const width of [32, 64]) {
	const scalar = `f${width}`
	const rows = []
	const values = boundaries(width)

	for (const [left_name, left] of Object.entries(values)) {
		for (const [right_name, right] of Object.entries(values))
			rows.push(makeCase({ identifier: `${left_name}/${right_name}`, left, right, width }))
	}

	if (width === 64) {
		for (const text of ['13', '-13', '1.3', '-1.3']) {
			const bits = encode({
				magnitude: Rational.decimal(text.replace('-', '')),
				negative: text.startsWith('-'),
				width
			}) as bigint
			rows.push(makeCase({ identifier: `upstream_equal/${text}/same`, left: bits, right: bits, width }))
		}

		const near_one = encode({ magnitude: Rational.decimal('0.999999999999'), negative: false, width }) as bigint
		rows.push(
			makeCase({ identifier: 'upstream_equal/one/near_one', left: values.positive_one, right: near_one, width })
		)
	}

	const fields = Object.keys(operators)
		.map(name => `${name}: bool;`)
		.join(' ')
	const results = Object.entries(operators)
		.map(([name, operator]) => `${name}: in.left ${operator} in.right`)
		.join(', ')
	const source = `export type Input = { left: ${scalar}; right: ${scalar}; };\n\nexport type Output = { ${fields} };\n\nexport default function (in: Input): Output {\n  return { ${results} };\n}\n`
	const root = 'tests/language/expressions/comparison/'

	writeCatalog(root + scalar + '.jsonl', rows)
	writeOutput(root + scalar + '.zx', source)

	if (width === 64) {
		const negated = makeCase({
			identifier: 'negated/positive_infinity/negative_infinity',
			left: values.positive_infinity,
			right: values.negative_infinity,
			width
		})
		negated.expected = expected({
			left: values.positive_infinity,
			right: values.negative_infinity ^ (1n << BigInt(width - 1)),
			width
		})

		writeCatalog(root + 'f64_negated.jsonl', [negated])
		writeOutput(root + 'f64_negated.zx', source.replaceAll('in.right', '-in.right'))
	}
}
