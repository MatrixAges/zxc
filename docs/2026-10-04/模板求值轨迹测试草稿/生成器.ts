import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_order.jsonl'))
const shapes = [
	{ name: 'order', expression: '`a${readLeft(in.fail_left) - 2}b${readRight(in.fail_right) - 2}c${readLeft(in.fail_left)}d`', value: 'a0b1c2d' },
	{ name: 'first', expression: '`${readLeft(in.fail_left)}${readRight(in.fail_right)}`', value: '23' },
	{ name: 'middle', expression: '`${0}${readLeft(in.fail_left)}${readRight(in.fail_right)}`', value: '023' },
	{ name: 'later', expression: '`${0}${1}${readLeft(in.fail_left)}${readRight(in.fail_right)}`', value: '0123' },
]
const reviews = shapes.map((shape, index) => {
	const path = `tests/runtime/evaluation_order/template/${shape.name}`
	const rows = [false, true].flatMap(fail_left => [false, true].map(fail_right => {
		const trace = fail_left ? 'L' : fail_right || shape.name !== 'order' ? 'LR' : 'LRL'
		const error = fail_left ? 'LeftFailure' : fail_right ? 'RightFailure' : null

		return { id: `template_order/${shape.name}/${fail_left}/${fail_right}`, input: { fail_left, fail_right }, expected: error ? { trace, error } : { trace, value: shape.value } }
	}))

	writeOutput(`${path}.zx`, `import readLeft from "lib:probe-left"\nimport readRight from "lib:probe-right"\n\nexport type Input = { fail_left: bool, fail_right: bool }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${shape.expression}\n}\n`)
	writeCatalog(`${path}.jsonl`, rows)

	return {
		...samples[index], status: 'adapted',
		reason: index === 0 ? '保留普通模板a0b1c2d与从左到右求值；用原生L/R/L调用替代自增，直接观察轨迹及提前失败，不声称tagged调用和i++兼容。' : '保留首/中/后插值位置的异常传播，用LeftFailure原生调用替代JS立即函数抛Test262Error；增加后续R调用证明失败停止，以及成功对照，不声称异常对象协议等价。',
		contract: 'packages/core/IR契约.md#表达式与求值',
		cases: rows.map(row => row.id),
		assertions: rows.flatMap(row => [{ case: row.id, field: 'trace', expected: row.expected.trace }, { case: row.id, field: row.expected.error ? 'error' : 'value', expected: row.expected.error ?? row.expected.value }]),
	}
})

writeCatalog('upstream/reviews/language/expressions/template_order.jsonl', reviews)
