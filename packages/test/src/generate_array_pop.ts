import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

const base = 'built_ins/list/pop/after_removal'
const rows = [
	{ name: 'original_empty', items: [], count: 0, removed: [], rest: [], popped: null },
	{ name: 'original_cleared', items: [1, 2, 3], count: 3, removed: [1, 2, 3], rest: [], popped: null },
	{ name: 'single', items: [12], count: 0, removed: [], rest: [], popped: 12 },
	{ name: 'unchanged', items: [1, 2, 3], count: 0, removed: [], rest: [1, 2], popped: 3 },
	{ name: 'partial', items: [12, 11, 10, 9], count: 2, removed: [12, 11], rest: [10], popped: 9 },
	{ name: 'repeated', items: [2, 2, 2], count: 1, removed: [2], rest: [2], popped: 2 },
	{ name: 'reverse', items: [3, 2, 1], count: 1, removed: [3], rest: [2], popped: 1 },
	{ name: 'zero_value', items: [-1, 0], count: 1, removed: [-1], rest: [], popped: 0 }
]

writeOutput(
	`tests/${base}/cases.zx`,
	`export type Input = { items: i64[], count: u64 }

export type Output = { removed: i64[], rest: i64[], popped: i64? }

export default function (in: Input): Output {
  const owned = in.items.map(item => item)

  const [trimmed, removed] = owned.splice(0, in.count, [])
  const [rest, popped] = trimmed.pop()

  return { removed, rest, popped }
}
`
)

writeCatalog(
	`tests/${base}/cases.jsonl`,
	rows.map(({ name, items, count, ...value }) => ({
		id: `${base}/${name}`,
		input: { items, count },
		expected: { value }
	}))
)

writeCatalog(
	'upstream/reviews/built_ins/array/pop_empty.jsonl',
	readRows(resolve(package_dir, 'src/data/array_pop.jsonl'))
)
