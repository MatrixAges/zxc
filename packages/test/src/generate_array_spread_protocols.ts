import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; kind: string; reason: string; expression: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/array_spread_protocols.jsonl'))
const frontend = []
const reviews = []
const runtime = [1, 2, 3, 4].map((value, input) => ({ id: `language/expressions/object_construction/copy_prefix/${input}`, input, expected: { value } }))

for (const sample of samples) {
	const cases: Array<string> = []

	if (sample.kind === 'copy') cases.push(...runtime.map(row => row.id))
	else if (sample.kind !== 'excluded') {
		const declaration = sample.path.endsWith('spread-mult-expr.js') ? '  const source: u64[] = [3, 4, 5]\n\n' : ''
		const source = `export type Input = void

export type Output = u64

export default function (in: Input): Output {
${declaration}  const values = ${sample.expression}

  return values.length
}
`
		const token = sample.kind === 'array' ? '...' : sample.kind
		const start = source.indexOf(token, source.indexOf('const values'))
		const id = `language/types/array_spread_protocols/${sample.path.split('/').at(-1)!.replace('.js', '')}`

		frontend.push({ id, source, phase: sample.kind === 'array' ? 'parse' : 'analyze', diagnostic: sample.kind === 'array' ? 'syntax' : sample.kind === 'null' ? 'type_mismatch' : 'name', span: [start, start + token.length] })
		cases.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: sample.kind === 'excluded' ? 'excluded' : 'adapted', reason: sample.reason, contract: 'packages/core/IR契约.md#表达式与求值', cases })
}

writeOutput('tests/language/expressions/object_construction/copy_prefix.zx', 'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const o = { c: 3, d: 4 }\n  const values = [{a: 1, b: 2, ...o}]\n  const value = values[0]\n  const fields: u64[] = [value.a, value.b, value.c, value.d]\n\n  return fields[in]\n}\n')
writeCatalog('tests/language/expressions/object_construction/copy_prefix.jsonl', runtime)
writeCatalog('tests/language/types/array_spread_protocols/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/array_spread_protocols.jsonl', reviews)
