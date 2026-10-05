import type { Json } from './shared/json.ts'
import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Row = { name: string; input: Json; expected: { value?: Json; error?: string } }

function writeSuite(args: { name: string; input: string; output: string; body: string; rows: Array<Row> }): void {
	const { name, input, output, body, rows } = args
	const base = `built_ins/list/callbacks/for_each/${name}`

	writeOutput(
		`tests/${base}/cases.zx`,
		`export type Input = ${input}\n\nexport type Output = ${output}\n\nexport default function (in: Input): Output {\n  ${body}\n}\n`
	)
	writeCatalog(
		`tests/${base}/cases.jsonl`,
		rows.map(({ name, ...row }) => ({ id: `${base}/${name}`, ...row }))
	)
}

const preserving = [
	{ name: 'original', input: [1, 2, 3, 4, 5] },
	{ name: 'empty', input: [] },
	{ name: 'single_zero', input: [0] },
	{ name: 'repeated', input: [2, 2, 0, 2] },
	{ name: 'large_exact_integer', input: [0, Number.MAX_SAFE_INTEGER, 0] },
	{ name: 'unsorted', input: [9, 0, 4, 1] },
	{ name: 'long', input: Array.from({ length: 257 }, (_, index) => index % 7) }
]

writeSuite({
	name: 'preserve',
	input: 'u64[]',
	output: 'u64[]',
	body: 'in.forEach(item => true)\n\n  return in',
	rows: preserving.map(row => ({ ...row, expected: { value: row.input } }))
})

const empty = [
	{ name: 'original_empty', input: [] },
	{ name: 'nonempty_success', input: [[3]] },
	{ name: 'first_failure', input: [[]] },
	{ name: 'later_failure', input: [[2], []] },
	{ name: 'two_populated', input: [[2], [4]] },
	{ name: 'zero_element', input: [[0]] },
	{
		name: 'unused_columns',
		input: [
			[0, 99],
			[4, 17]
		]
	},
	{ name: 'last_failure', input: [[1], [2], []] },
	{ name: 'repeated', input: [[2], [2], [2]] }
]

writeSuite({
	name: 'empty',
	input: 'u64[][]',
	output: 'u64',
	body: 'in.forEach(row => row[0])\n\n  return in.length',
	rows: empty.map(row => ({
		...row,
		expected: row.input.some(item => item.length === 0)
			? { error: 'IndexOutOfBounds' }
			: { value: row.input.length }
	}))
})

writeCatalog(
	'upstream/reviews/built_ins/array/for_each.jsonl',
	readRows(resolve(package_dir, 'src/data/for_each.jsonl'))
)
