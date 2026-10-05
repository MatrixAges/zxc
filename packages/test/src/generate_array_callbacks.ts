import type { Json } from './shared/json.ts'
import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Row = { name: string; input: Json; expected: { value?: Json; error?: string } }

function writeSuite(args: { name: string; input: string; output: string; expression: string; rows: Array<Row> }): void {
	const { name, input, output, expression, rows } = args
	const base = `built_ins/list/callbacks/${name}`

	writeOutput(
		`tests/${base}/cases.zx`,
		`export type Input = ${input}\n\nexport type Output = ${output}\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`
	)
	writeCatalog(
		`tests/${base}/cases.jsonl`,
		rows.map(({ name, ...row }) => ({ id: `${base}/${name}`, ...row }))
	)
}

const mapping = [
	{ name: 'original_length', input: [12, 11] },
	{ name: 'original_values', input: [11, 9] },
	{ name: 'empty', input: [] },
	{ name: 'at_threshold', input: [10] },
	{ name: 'above_threshold', input: [11] },
	{ name: 'mixed', input: [-1, 0, 10, 11, 12] },
	{ name: 'repeated', input: [12, 12, 9] }
]

writeSuite({
	name: 'map/predicate',
	input: 'i64[]',
	output: 'bool[]',
	expression: 'in.map(item => item > 10)',
	rows: mapping.map(row => ({ ...row, expected: { value: row.input.map(item => item > 10) } }))
})

const filtering = [
	{ name: 'original_single_parameter', input: [12], value: [12] },
	{ name: 'empty', input: [], value: [] },
	{ name: 'all_rejected', input: [-1, 0, 9, 10], value: [] },
	{ name: 'all_retained', input: [12, 11, 13], value: [12, 11, 13] },
	{ name: 'threshold', input: [10, 11], value: [11] },
	{ name: 'mixed_order', input: [12, 9, 11, 10, 13], value: [12, 11, 13] },
	{ name: 'reverse_order', input: [13, 10, 11, 9, 12], value: [13, 11, 12] },
	{ name: 'repeated', input: [11, 9, 11, 12, 11], value: [11, 11, 12, 11] },
	{ name: 'negative_boundary', input: [-11, -10, 10, 11], value: [11] }
]

writeSuite({
	name: 'filter/predicate',
	input: 'i64[]',
	output: 'i64[]',
	expression: 'in.filter(val => val > 10)',
	rows: filtering.map(({ name, input, value }) => ({ name, input, expected: { value } }))
})

const empty = [
	{ name: 'original_no_callback', items: [], seed: 3 },
	{ name: 'original_seed', items: [], seed: 1 },
	{ name: 'zero_seed', items: [], seed: 0 },
	{ name: 'negative_seed', items: [], seed: -2 },
	{ name: 'nonempty_success', items: [[2], [5]], seed: 3 },
	{ name: 'nonempty_failure', items: [[]], seed: 3 },
	{ name: 'later_failure', items: [[2], []], seed: 3 },
	{ name: 'zero_element', items: [[0]], seed: 3 },
	{ name: 'first_field', items: [[0, 9]], seed: 3 }
]

writeSuite({
	name: 'reduce/empty',
	input: '{ items: i64[][], seed: i64 }',
	output: 'i64',
	expression: 'in.items.reduce((sum, row) => sum + row[0], in.seed)',
	rows: empty.map(({ name, ...input }) => ({
		name,
		input,
		expected: input.items.some(row => row.length === 0)
			? { error: 'IndexOutOfBounds' }
			: { value: input.items.reduce((sum, row) => sum + row[0], input.seed) }
	}))
})

const ordered = [
	{ name: 'original_order', items: ['1', '2', '3', '4', '5'], seed: '0' },
	{ name: 'reversed', items: ['5', '4', '3', '2', '1'], seed: '0' },
	{ name: 'empty', items: [], seed: 'seed' },
	{ name: 'empty_element', items: ['a', '', 'b'], seed: '0' },
	{ name: 'unicode', items: ['中', '🌿'], seed: '' },
	{ name: 'repeated', items: ['1', '1', '2'], seed: '0' },
	{ name: 'all_empty', items: ['', ''], seed: 'prefix' }
]

writeSuite({
	name: 'reduce/order',
	input: '{ items: string[], seed: string }',
	output: 'string',
	expression: 'in.items.reduce((sum, item) => `${sum}${item}`, in.seed)',
	rows: ordered.map(({ name, ...input }) => ({
		name,
		input,
		expected: { value: input.items.reduce((sum, item) => sum + item, input.seed) }
	}))
})

const arguments_cases = [
	{ name: 'original_arguments', items: [11], seed: 1 },
	{ name: 'wrong_seed', items: [11], seed: 2 },
	{ name: 'wrong_item', items: [9], seed: 1 },
	{ name: 'at_threshold', items: [10], seed: 1 },
	{ name: 'empty', items: [], seed: 1 },
	{ name: 'next_accumulator', items: [11, 12], seed: 1 }
]

writeSuite({
	name: 'reduce/arguments',
	input: '{ items: i64[], seed: i64 }',
	output: 'i64',
	expression: 'in.items.reduce((previous, current) => current > 10 && previous == 1 ? 2 : 0, in.seed)',
	rows: arguments_cases.map(({ name, ...input }) => ({
		name,
		input,
		expected: {
			value: input.items.reduce((previous, current) => (current > 10 && previous === 1 ? 2 : 0), input.seed)
		}
	}))
})

writeCatalog(
	'upstream/reviews/built_ins/array/callbacks.jsonl',
	readRows(resolve(package_dir, 'src/data/array_callbacks.jsonl'))
)
