import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { family: string; left: string; right: string; operator: string; group: string; path: string; sha256: string; check: number; expression: string; expected: boolean }
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string>; diagnostics: Array<{ case: string; phase: string; code: string }>; observations: Array<{ case: string; field: string; expected: boolean }> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/relational_conversion.jsonl'))
const rows = []
const reviews = new Map<string, Review>()

for (const sample of samples) {
	const { expression } = sample
	const syntax = sample.left.startsWith('new ') || sample.right.startsWith('new ')
	const diagnostic = syntax ? 'syntax' : expression.includes('undefined') && !expression.startsWith('null') ? 'name' : /^\d+$/.test(sample.left) && /^\d+$/.test(sample.right) ? null : 'type_mismatch'
	const phase = syntax ? 'parse' : 'analyze'
	const id = `language/types/relational_conversion/${sample.family}/${sample.group}/${sample.check}`

	rows.push({ id, source: `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return ${expression};\n}\n`, phase, diagnostic })

	if (!reviews.has(sample.path)) reviews.set(sample.path, { path: sample.path, sha256: sample.sha256, status: 'adapted', reason: '逐项保留原始关系比较表达式。new包装对象在语法期拒绝；Boolean/String/Null不隐式转Number，类型分析拒绝；undefined按未定义名称拒绝（左侧null先触发类型错误）。这些诊断证明ZX静态边界，不证明原ToPrimitive/ToNumber行为等价。数值成功项另外关联已有运行用例核对结果。', contract: 'packages/zx/IR契约.md#数值', cases: [], diagnostics: [], observations: [] })

	const review = reviews.get(sample.path)!

	review.cases.push(id)

	if (diagnostic) review.diagnostics.push({ case: id, phase, code: diagnostic })
	else {
		const control = `language/expressions/comparison/whitespace/${sample.family}/tab/left/1`

		review.cases.push(control)
		review.observations.push({ case: control, field: 'value', expected: sample.expected })
	}
}

for (const family of new Set(samples.map(sample => sample.family))) {
	const prefix = `language/types/relational_conversion/${family}/`

	writeCatalog(`tests/${prefix}cases.jsonl`, rows.filter(row => row.id.startsWith(prefix)))
}

writeCatalog('upstream/reviews/language/expressions/relational_conversion.jsonl', [...reviews.values()])
