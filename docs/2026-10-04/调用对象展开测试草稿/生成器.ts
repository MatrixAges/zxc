import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; group: string | null; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/call_object_spread.jsonl'))
const base = 'language/expressions/call_object_spread'
const inputs = [{ a: 2, b: 3, c: 4, d: 5 }, { a: -7, b: 9, c: 0, d: -1 }, { a: 1, b: 7, c: 1, d: 7 }]
const reviews = []

for (const sample of samples) {
	const group = sample.group
	const cases = []

	if (group) {
		const fields = group === 'merge' ? ['a', 'b', 'c', 'd'] : ['a', 'b']
		const shape = fields.map(field => `${field}: i64`).join(', ')
		const result = fields.map(field => `${field}: in.${field}`).join(', ')
		const declarations = '  const o = { a: in.a, b: in.b }\n' + (group === 'merge' ? '  const o2 = { c: in.c, d: in.d }\n' : '')
		const expression = group === 'merge' ? '{...o, ...o2}' : '{a: 1, b: 7, ...o}'
		const path = `tests/${base}/${group}`

		writeOutput(`${path}/observe.zx`, `export type Input = { ${shape} }

export type Output = { ${shape} }

export default function (in: Input): Output {
  return { ${result} }
}
`)
		writeOutput(`${path}/cases.zx`, `import observe from "./observe.zx"

export type Input = { a: i64, b: i64, c: i64, d: i64 }

export type Output = { ${shape} }

export default function (in: Input): Output {
${declarations}
  return observe(${expression})
}
`)

		for (const [index, input] of inputs.entries()) {
			cases.push({ id: `${base}/${group}/${index}`, input, expected: { value: Object.fromEntries(fields.map(field => [field, input[field as keyof typeof input]])) } })
		}

		writeCatalog(`${path}/cases.jsonl`, cases)
	}

	reviews.push({
		path: sample.path, sha256: sample.sha256, reason: sample.reason, status: group ? 'adapted' : 'excluded',
		contract: 'packages/core/IR契约.md', cases: cases.length ? [cases[0].id] : [],
		...(cases.length ? { assertions: [{ case: cases[0].id, field: 'value', expected: cases[0].expected.value }] } : {}),
	})
}

writeCatalog('upstream/reviews/language/expressions/call_object_spread.jsonl', reviews)
