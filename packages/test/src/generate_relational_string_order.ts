import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { family: string; group: string; path: string; sha256: string; check: number; expression: string; expected: boolean }
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string>; diagnostics: Array<{ case: string; phase: string; code: string }> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/relational_string_order.jsonl'))
const rows = []
const reviews = new Map<string, Review>()

for (const sample of samples) {
	if (!reviews.has(sample.path)) reviews.set(sample.path, { path: sample.path, sha256: sample.sha256, status: 'adapted', reason: '逐项保留字符串比较原式及单引号、Unicode转义。ZX在单引号或Unicode转义处lexical拒绝，其余关系排序或前置字符串拼接在type_mismatch拒绝。含码点转义项另加真实UTF8变体验证类型边界；不宣称JS UTF16字典序结果等价。', contract: 'packages/core/IR契约.md#表达式与求值', cases: [], diagnostics: [] })

	const review = reviews.get(sample.path)!
	const variants: Array<[string, string]> = [['original', sample.expression]]

	if (sample.expression.includes('\\u{')) {
		const expression = sample.expression.replace(/\\u(?:\{([\da-f]+)\}|([\da-f]{4}))/gi, (match: string, braced: string | undefined, fixed: string | undefined) => String.fromCodePoint(Number.parseInt(braced ?? fixed!, 16)))

		variants.push(['utf8', expression])
	}

	for (const [variant, expression] of variants) {
		const source = `export type Input = void

export type Output = bool

export default function (in: Input): Output {
  const x = "x"

  return ${expression}
}
`
		const token = source.includes('\\u') ? '\\u' : source.includes("'") ? "'" : null
		const phase = token ? 'parse' : 'analyze'
		const diagnostic = token ? 'lexical' : 'type_mismatch'
		const start = token ? Buffer.byteLength(source.slice(0, source.indexOf(token))) : 0
		const id = `language/types/relational_string_order/${sample.family}/${sample.group}/${sample.check}/${variant}`

		rows.push({ id, source, phase, diagnostic, ...(token ? { span: [start, start + token.length] } : {}) })

		review.cases.push(id)
		review.diagnostics.push({ case: id, phase, code: diagnostic })
	}
}

for (const family of new Set(samples.map(sample => sample.family))) {
	const prefix = `language/types/relational_string_order/${family}/`

	writeCatalog(`tests/${prefix}cases.jsonl`, rows.filter(row => row.id.startsWith(prefix)))
}

writeCatalog('upstream/reviews/language/expressions/relational_string_order.jsonl', [...reviews.values()])
