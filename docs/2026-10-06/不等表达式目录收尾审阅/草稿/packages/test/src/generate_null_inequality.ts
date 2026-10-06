import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const groups: Array<{ name: string; type: string; value: Json }> = [
	{ name: 'string', type: 'string', value: 'null' },
	{ name: 'empty_object', type: '{}', value: {} }
]

for (const group of groups) {
	const base = `tests/language/expressions/comparison/null_inequality/${group.name}`
	const rows = [null, group.value].map((input, index) => ({
		id: `language/expressions/comparison/null_inequality/${group.name}/${index === 0 ? 'none' : 'value'}`,
		input,
		expected: { value: { left_different: input !== null, right_different: input !== null } }
	}))

	writeCatalog(base + '.jsonl', rows)
	writeOutput(
		base + '.zx',
		`export type Value = ${group.type}

export type Input = Value?

export type Output = { left_different: bool
 right_different: bool }

export default function (in: Input): Output {
  return { left_different: null != in, right_different: in != null }
}
`
	)
}
