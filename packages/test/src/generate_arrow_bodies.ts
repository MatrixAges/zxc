import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/arrow_bodies.jsonl'))
const base = 'language/expressions/arrow/bodies'
const shapes = [
	{ name: 'single', expression: 'in.items.map(x => x)' },
	{ name: 'single_lf', expression: 'in.items.map(x =>\nx)' },
	{ name: 'paren', expression: 'in.items.map((x) => x)' },
	{ name: 'paren_lf', expression: 'in.items.map((x) =>\nx)' },
	{ name: 'single_cr', expression: 'in.items.map(x =>\rx)' },
	{ name: 'paren_cr', expression: 'in.items.map((x) =>\rx)' },
	{ name: 'single_crlf', expression: 'in.items.map(x =>\r\nx)' },
	{ name: 'paren_crlf', expression: 'in.items.map((x) =>\r\nx)' },
	{ name: 'increment', expression: 'in.items.map(a => a + 1)' },
	{ name: 'sum', expression: '[in.items.reduce((a, b) => a + b, in.seed)]' }
]
const values = [
	{ name: 'empty', items: [] },
	{ name: 'one', items: [1] },
	{ name: 'signed', items: [-7, 0, 43] },
	{ name: 'repeated', items: [1, 1, 1] },
	{ name: 'balanced', items: [65535, -65535] },
	{ name: 'four', items: [4] }
]
const cases = shapes.flatMap((shape, kind) =>
	values.map(value => ({
		id: `${base}/${shape.name}/${value.name}`,
		input: { kind, items: value.items, seed: 1 },
		expected: {
			value:
				shape.name === 'sum'
					? [value.items.reduce((sum, item) => sum + item, 1)]
					: shape.name === 'increment'
						? value.items.map(item => item + 1)
						: value.items
		}
	}))
)
const branches = shapes.map((shape, kind) => `    case ${kind}:\n      return ${shape.expression}`).join('\n')

writeOutput(
	`tests/${base}/cases.zx`,
	`export type Input = { kind: u64\n items: i64[]\n seed: i64 }\n\nexport type Output = i64[]\n\nexport default function (in: Input): Output {\n  switch (in.kind) {\n${branches}\n    default:\n      return []\n  }\n}\n`
)
writeCatalog(`tests/${base}/cases.jsonl`, cases)
writeCatalog(
	'upstream/reviews/language/expressions/arrow_bodies.jsonl',
	samples.map(sample => {
		const ids =
			sample.name === 'variations'
				? [`${base}/increment/one`, `${base}/sum/four`]
				: [`${base}/${sample.name}/one`]
		const selected = cases.filter(row => ids.includes(row.id))

		return {
			path: sample.path,
			sha256: sample.sha256,
			status: 'adapted',
			reason:
				sample.name === 'variations'
					? '仅适配a=>a+1的输入1返回2，以及(a,b)=>a+b的输入1、4返回5；分别用单元素map和以1为初值的单元素reduce调用一次。零参数、语句体和一等函数立即调用不在ZX契约内，未覆盖原文其余四项断言。'
					: '保持原文参数括号和箭头后换行形式，以单元素map调用identity并验证输入1返回1；不覆盖var绑定、一等函数调用或typeof function断言，因此仅为部分适配。',
			contract: 'packages/compiler/src/zx/analysis/transforms.zig',
			cases: ids,
			assertions: selected.map(row => ({ case: row.id, field: 'value', expected: row.expected.value }))
		}
	})
)
