import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; expression: string; declaration: string; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/object_computed.jsonl'))
const frontend = []
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []
	const variants = sample.expression ? [sample.expression] : []

	if (sample.expression.includes("'")) variants.push(sample.expression.replace(/'([12])'/g, '"$1"'))

	for (const [index, expression] of variants.entries()) {
		const name = sample.path.split('/').at(-1)!.replace('cpn-obj-lit-computed-property-name-from-', '').replace('.js', '')
		const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n${sample.declaration}  const object = ${expression};\n\n  return true;\n}\n`
		const token = expression.includes("'") ? "'" : '['
		const start = source.indexOf(token, source.indexOf('const object'))
		const id = `language/types/object_computed/${name}/${index === 0 ? 'original' : 'double_quote'}`

		frontend.push({ id, source, phase: 'parse', diagnostic: token === "'" ? 'lexical' : 'syntax', span: [start, start + 1] })
		cases.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: cases.length ? 'adapted' : 'excluded', reason: sample.reason, contract: 'packages/zx/IR契约.md#表达式与求值', cases })
}

writeCatalog('tests/language/types/object_computed/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/object_computed.jsonl', reviews)
