import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; stage: string; expression: string | null; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/array_spread_errors.jsonl'))
const rows = []
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []

	if (sample.expression !== null) {
		const source = `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const values = ${sample.expression};\n\n  return values.length;\n}\n`
		const name = sample.stage === 'object_name'
		const token = name ? 'unresolvableReference' : '...'
		const start = source.indexOf(token)
		const id = `language/types/array_spread_errors/${sample.path.split('/').at(-1)!.replace('.js', '')}`

		rows.push({ id, source, phase: name ? 'analyze' : 'parse', diagnostic: name ? 'name' : 'syntax', span: [start, start + token.length] })
		cases.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: sample.expression === null ? 'excluded' : 'adapted', reason: sample.reason, contract: 'packages/zx/IR契约.md#表达式与求值', cases })
}

writeCatalog('tests/language/types/array_spread_errors/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/array_spread_errors.jsonl', reviews)
