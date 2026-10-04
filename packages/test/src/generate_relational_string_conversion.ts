import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { family: string; group: string; path: string; sha256: string; check: number; expression: string; expected: string }
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string>; diagnostics: Array<{ case: string; phase: string; code: string }> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/relational_string_conversion.jsonl'))
const rows = []
const reviews = new Map<string, Review>()

for (const sample of samples) {
	const excluded = sample.group === 'T1.2'

	if (!reviews.has(sample.path)) reviews.set(sample.path, {
		path: sample.path,
		sha256: sample.sha256,
		status: excluded ? 'excluded' : 'adapted',
		reason: excluded ? '逐项审阅四个Object/Function比较与显式toString结果一致性断言。ZX没有对象/函数动态ToPrimitive和toString协议；以固定字符串或普通函数调用替代会丢失原测试含义，因此不制造通过用例。原左右表达式保存在种子中。' : '逐项保留六个原始字符串比较表达式。三项new String包装对象在解析期syntax拒绝，三个原始字符串比较在分析期type_mismatch拒绝。验证的是ZX静态边界，不证明JS字典序或拆箱结果等价。',
		contract: 'packages/core/IR契约.md#表达式与求值',
		cases: [],
		diagnostics: [],
	})

	if (excluded) continue

	const syntax = sample.expression.includes('new ')
	const phase = syntax ? 'parse' : 'analyze'
	const diagnostic = syntax ? 'syntax' : 'type_mismatch'
	const id = `language/types/relational_string_conversion/${sample.family}/${sample.check}`
	const review = reviews.get(sample.path)!

	rows.push({ id, source: `export type Input = void

export type Output = bool

export default function (in: Input): Output {
  return ${sample.expression}
}
`, phase, diagnostic })
	review.cases.push(id)
	review.diagnostics.push({ case: id, phase, code: diagnostic })
}

for (const family of new Set(samples.map(sample => sample.family))) {
	const prefix = `language/types/relational_string_conversion/${family}/`

	writeCatalog(`tests/${prefix}cases.jsonl`, rows.filter(row => row.id.startsWith(prefix)))
}

writeCatalog('upstream/reviews/language/expressions/relational_string_conversion.jsonl', [...reviews.values()])
