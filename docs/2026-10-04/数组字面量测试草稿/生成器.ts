import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { group: string; path: string; sha256: string; literal: string; checks: number }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/array_literal.jsonl'))
const reviews = []
const frontend = []

for (const sample of samples) {
	const folder = sample.group === 'A1.1' ? 'empty' : sample.group === 'A1.3' ? 'dense' : 'nested'
	const prefix = `language/expressions/array_literal/${folder}`
	const cases: Array<string> = []
	const sparse = !['A1.1', 'A1.3', 'A2'].includes(sample.group)
	const runtime: Array<{ id: string; input: unknown; expected: { value?: number; error?: string } }> = []
	let source = ''

	if (sparse) {
		source = `export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const array: u64[] = ${sample.literal};\n\n  return array.length;\n}\n`
		const relative = sample.literal.startsWith('[,') ? 1 : sample.literal.indexOf(',,') + 1
		const start = source.indexOf(sample.literal) + relative
		const id = `language/types/array_literal/${sample.group}/elision`

		frontend.push({ id, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] })
		cases.push(id)
	} else {
		if (sample.group === 'A1.1') {
			source = `export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const array: u64[] = ${sample.literal};\n\n  return array.length;\n}\n`
			runtime.push({ id: `${prefix}/check_4`, input: 0, expected: { value: 0 } })
		} else if (sample.group === 'A1.3') {
			source = `export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const array: u64[] = ${sample.literal};\n\n  return in == 0 ? array.length : array[in - 1];\n}\n`
			for (const [check, input, value] of [[4, 0, 5], [5, 1, 1], [6, 2, 2], [7, 3, 3], [8, 4, 4], [9, 5, 5]]) runtime.push({ id: `${prefix}/check_${check}`, input, expected: { value } })
			runtime.push({ id: `${prefix}/extension/out_of_bounds`, input: 6, expected: { error: 'IndexOutOfBounds' } })
		} else {
			source = `export type Input = { kind: u64; row: u64; column: u64; };\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const array: u64[][] = ${sample.literal};\n\n  if (in.kind == 0) { return array.length; }\n  if (in.kind == 3) { return array[in.row][in.column]; }\n\n  const subarray = array[in.row];\n\n  return in.kind == 1 ? subarray.length : subarray[in.column];\n}\n`
			const values = [[4, 0, 0, 0, 3], [8, 1, 0, 0, 2], [9, 2, 0, 0, 1], [10, 2, 0, 1, 2], [14, 1, 1, 0, 1], [15, 2, 1, 0, 3], [19, 1, 2, 0, 0], [20, 3, 0, 0, 1], [21, 3, 0, 1, 2], [22, 3, 1, 0, 3]]
			for (const [check, kind, row, column, value] of values) runtime.push({ id: `${prefix}/check_${check}`, input: { kind, row, column }, expected: { value } })
			for (const [name, row, column] of [['short_row', 0, 2], ['empty_row', 2, 0], ['missing_row', 3, 0]] as const) runtime.push({ id: `${prefix}/extension/${name}`, input: { kind: 3, row, column }, expected: { error: 'IndexOutOfBounds' } })
		}

		writeOutput(`tests/language/expressions/array_literal/${folder}/cases.zx`, source)
		writeCatalog(`tests/language/expressions/array_literal/${folder}/cases.jsonl`, runtime)
		cases.push(...runtime.map(row => row.id))
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: 'adapted', reason: sparse ? '保留稀疏字面量，在ZX列表语法入口精确拒绝首个空位逗号。没有以零值/undefined替代空位，也不声称JS长度、原型或空位读取断言通过。' : '保留原数组字面量，以显式u64同质列表适配原1至5的精确数值子集，仅执行长度和索引检查；typeof、instanceof和原型方法比较不适用。嵌套情形保留子数组别名和直接双索引两种路径。另加ZX特有越界错误对照，不声称JS越界语义等价。', contract: 'packages/zx/IR契约.md#表达式与求值', cases })
}

writeCatalog('tests/language/types/array_literal/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/array_literal.jsonl', reviews)
