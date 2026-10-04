import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; check: number; expression: string; declaration: string; expected: number | string }
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/unary_plus_boundary.jsonl'))
const rows = []
const reviews = new Map<string, Review>()

for (const sample of samples) {
	const group = sample.path.split('/').at(-1)!.replace('.js', '')
	const id = `language/types/unary_plus_boundary/${group}/${sample.check}`
	const declaration = sample.declaration ? `  ${sample.declaration}\n\n` : ''
	const source = `export type Input = void;\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n${declaration}  return ${sample.expression};\n}\n`
	const rejected = [...sample.expression].find(character => character.charCodeAt(0) > 127)
	const offset = rejected ? source.indexOf(rejected) : source.indexOf('+', source.indexOf('return '))
	const start = Buffer.byteLength(source.slice(0, offset))

	rows.push({ id, source, phase: 'parse', diagnostic: rejected ? 'lexical' : 'syntax', span: [start, start + 1] })

	if (!reviews.has(sample.path)) reviews.set(sample.path, {
		path: sample.path,
		sha256: sample.sha256,
		status: 'adapted',
		reason: '保留原一元正号表达式并验证ZX当前不支持该语法的精确诊断；ASCII空白场景定位正号，NBSP和Unicode行段分隔符先触发lexical。var适配为静态const，对象属性改用静态对象声明；未绑定名称仍保留，但parse拒绝不等价于JS ReferenceError。原文错误消息笔误不替代实际表达式与断言预期，不声称原JS取值或转换语义已实现。',
		contract: 'packages/zx/IR契约.md#表达式与求值',
		cases: [],
	})

	reviews.get(sample.path)!.cases.push(id)
}

writeCatalog('tests/language/types/unary_plus_boundary/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/unary_plus_boundary.jsonl', [...reviews.values()])
