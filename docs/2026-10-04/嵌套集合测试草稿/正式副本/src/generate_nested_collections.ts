import { writeCatalog, writeOutput } from './shared/catalog.ts'

const inputs: Array<{ name: string; input: Array<Array<number>> }> = [
	{ name: 'empty_outer', input: [] },
	{ name: 'empty_inner', input: [[]] },
	{ name: 'two_empty_rows', input: [[], []] },
	{ name: 'single_zero', input: [[0]] },
	{ name: 'mixed_signs', input: [[-2, 0, 3]] },
	{ name: 'empty_middle', input: [[1, 2], [], [-3, 4]] },
	{ name: 'varied_rows', input: [[2], [3, 4]] },
]
const shapes = [
	{ name: 'nested_map', output: 'i64[][]', expression: 'in.map(row => row.map(item => item + 1))' },
	{ name: 'nested_initial', output: 'i64[]', expression: 'in.map(row => row.reduce((sum, item) => sum + item, row[0]))' },
	{ name: 'restored_row', output: 'i64[]', expression: 'in.map(row => row.reduce((sum, item) => sum + item, 0) + row[0])' },
]

for (const shape of shapes) {
	const path = `tests/built_ins/list/nested/${shape.name}`
	const rows = inputs.map(({ name, input }) => {
		const expected = shape.name === 'nested_map'
			? { value: input.map(row => row.map(item => item + 1)) }
			: input.some(row => row.length === 0)
				? { error: 'IndexOutOfBounds' }
				: { value: input.map(row => row.reduce((sum, item) => sum + item, 0) + row[0]) }

		return { id: `built_ins/list/nested/${shape.name}/${name}`, input, expected }
	})

	writeOutput(`${path}.zx`, `export type Input = i64[][]\n\nexport type Output = ${shape.output}\n\nexport default function (in: Input): Output {\n  return ${shape.expression}\n}\n`)
	writeCatalog(`${path}.jsonl`, rows)
}
