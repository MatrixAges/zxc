import { writeCatalog, writeOutput } from './shared/catalog.ts'

const inputs = {
	bool: [
		[true, true],
		[false, false],
		[true, false],
		[false, true]
	],
	string_upstream: [
		[' ', ' '],
		[' ', ''],
		['string', 'string'],
		[' string', 'string '],
		['1.0', '1'],
		['0xff', '255']
	]
}

for (const [name, pairs] of Object.entries(inputs)) {
	const scalar = name === 'bool' ? 'bool' : 'string'
	const base = `tests/language/expressions/comparison/${name}`
	const rows = pairs.map(([left, right], index) => ({
		id: `language/expressions/comparison/${name}/${index}`,
		input: { left, right },
		expected: { value: { same: left === right, different: left !== right } }
	}))

	writeCatalog(base + '.jsonl', rows)
	writeOutput(
		base + '.zx',
		`export type Input = { left: ${scalar}
 right: ${scalar} }

export type Output = { same: bool
 different: bool }

export default function (in: Input): Output {
  return { same: in.left == in.right, different: in.left != in.right }
}
`
	)
}
