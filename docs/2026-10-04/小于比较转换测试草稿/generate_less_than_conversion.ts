import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { group: string; path: string; sha256: string; check: number; expression: string; expected: boolean }
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string>; diagnostics: Array<{ case: string; phase: string; code: string }>; observations: Array<{ case: string; field: string; expected: boolean }> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/less_than_conversion.jsonl'))
const rows = []
const reviews = new Map<string, Review>()

for (const sample of samples) {
	const { expression } = sample
	const syntax = expression.includes('new ')
	const diagnostic = syntax ? 'syntax' : expression.includes('undefined') && !expression.startsWith('null') ? 'name' : expression === '1 < 1' ? null : 'type_mismatch'
	const phase = syntax ? 'parse' : 'analyze'
	const id = `language/types/less_than_conversion/${sample.group}/${sample.check}`

	rows.push({ id, source: `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return ${expression};\n}\n`, phase, diagnostic })

	if (!reviews.has(sample.path)) reviews.set(sample.path, { path: sample.path, sha256: sample.sha256, status: 'adapted', reason: '逐项保留原始小于比较表达式。new包装对象在语法期拒绝；Boolean/String/Null不隐式转Number，类型分析拒绝；undefined按未定义名称拒绝（左侧null先触发类型错误）。这些诊断证明ZX静态边界，不证明原ToPrimitive/ToNumber行为等价。数值成功项另外关联已有运行用例核对结果。', contract: 'packages/zx/IR契约.md#数值', cases: [], diagnostics: [], observations: [] })

	const review = reviews.get(sample.path)!

	review.cases.push(id)

	if (diagnostic) review.diagnostics.push({ case: id, phase, code: diagnostic })
	else {
		const control = 'language/expressions/comparison/whitespace/less/tab/left/1'

		review.cases.push(control)
		review.observations.push({ case: control, field: 'value', expected: sample.expected })
	}
}

writeCatalog('tests/language/types/less_than_conversion/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/less_than_conversion.jsonl', [...reviews.values()])
