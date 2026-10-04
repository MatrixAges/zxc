import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { family: string; group: string; path: string; sha256: string; check: number; initial: number | null; expression: string; expected: string }
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string>; diagnostics: Array<{ case: string; phase: string; code: string }> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/relational_assignment.jsonl'))
const rows = []
const reviews = new Map<string, Review>()

for (const sample of samples) {
	const excluded = sample.group.startsWith('A2.3')

	if (!reviews.has(sample.path)) reviews.set(sample.path, {
		path: sample.path,
		sha256: sample.sha256,
		status: excluded ? 'excluded' : 'adapted',
		reason: excluded ? '原左右对象valueOf分别throw x/y，检查左侧转换先发生并只传播x。ZX没有动态ToNumber/valueOf协议，普通native调用抛错不能证明隐式转换顺序，故不创建替代通过用例。' : '保留原表达式及已声明x的初始数值；var适配为ZX const。赋值表达式在parse阶段syntax拒绝，精确定位=。这不等价于JS左右赋值求值、ReferenceError优先级或noStrict隐式全局，不声称这些运行语义通过。',
		contract: 'packages/zx/IR契约.md#表达式与求值',
		cases: [],
		diagnostics: [],
	})

	if (excluded) continue

	const declaration = sample.initial === null ? '' : `  const x: f64 = ${sample.initial};\n\n`
	const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n${declaration}  return ${sample.expression};\n}\n`
	const start = source.indexOf(' = ', source.indexOf('return ')) + 1
	const id = `language/types/relational_assignment/${sample.family}/${sample.group}/${sample.check}`
	const review = reviews.get(sample.path)!

	rows.push({ id, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] })

	review.cases.push(id)
	review.diagnostics.push({ case: id, phase: 'parse', code: 'syntax' })
}

writeCatalog('tests/language/types/relational_assignment/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/relational_assignment.jsonl', [...reviews.values()])
