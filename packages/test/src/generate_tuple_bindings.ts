import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'language/statements/tuple_bindings'
const scalar_rows = [
	{ name: 'original_values', a: 1, b: 2, c: 3 },
	{ name: 'reverse_values', a: 3, b: 2, c: 1 },
	{ name: 'signs', a: -7, b: 0, c: 19 },
	{ name: 'repeated', a: 5, b: 5, c: 5 },
	{ name: 'large', a: 2147483647, b: -2147483648, c: 65536 }
]
const mixed_rows = [
	{ name: 'empty', value: 0, enabled: false, text: '' },
	{ name: 'ascii', value: 17, enabled: true, text: 'middle' },
	{ name: 'unicode', value: -19, enabled: false, text: '甲😀乙' },
	{ name: 'nul', value: 31, enabled: true, text: 'a\0b' }
]

writeOutput(
	`tests/${base}/scalar.zx`,
	`export type Input = { a: i64, b: i64, c: i64 }

export type Output = { x: i64, y: i64, z: i64, reverse: i64[] }

export default function (in: Input): Output {
  const values: [i64, i64, i64] = [in.a, in.b, in.c]

  const [x, y, z] = values

  return {x, y, z, reverse: [z, y, x]}
}
`
)

writeCatalog(
	`tests/${base}/scalar.jsonl`,
	scalar_rows.map(({ name, a, b, c }) => ({
		id: `${base}/scalar/${name}`,
		input: { a, b, c },
		expected: { value: { x: a, y: b, z: c, reverse: [c, b, a] } }
	}))
)

for (const discard of [false, true]) {
	const mode = discard ? 'discard' : 'mixed'
	const output = discard ? '{ value: i64, text: string }' : '{ value: i64, enabled: bool, text: string }'
	const binding = discard ? 'value, _, text' : 'value, enabled, text'
	const result = discard ? 'value, text' : 'value, enabled, text'

	writeOutput(
		`tests/${base}/${mode}.zx`,
		`export type Input = { value: i64, enabled: bool, text: string }

export type Output = ${output}

export default function (in: Input): Output {
  const values: [i64, bool, string] = [in.value, in.enabled, in.text]

  const [${binding}] = values

  return {${result}}
}
`
	)

	writeCatalog(
		`tests/${base}/${mode}.jsonl`,
		mixed_rows.map(({ name, ...input }) => ({
			id: `${base}/${mode}/${name}`,
			input,
			expected: { value: discard ? { value: input.value, text: input.text } : input }
		}))
	)
}
