import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'tests/built_ins/list/reverse/projections/rab_values'

const values = [
	{ name: 'rab_initial', input: [0, 2, 4, 6], expected: [6, 4, 2, 0] },
	{ name: 'rab_shrunk', input: [0, 2, 4], expected: [4, 2, 0] }
]

writeCatalog(
	base + '.jsonl',
	values.map(value => ({
		id: `built_ins/list/reverse/projections/${value.name}`,
		input: { items: value.input },
		expected: { value: value.expected }
	}))
)

writeOutput(
	base + '.zx',
	`export type Input = { items: i64[] }

export type Output = i64[]

export default function (in: Input): Output {
  const owned = in.items.map(item => item)

  const [next, _] = owned.reverse()

  return next
}
`
)
