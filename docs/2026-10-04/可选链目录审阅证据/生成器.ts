import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/optional_chain_remaining.jsonl'))
const expressions = ['in?.a.b', '(in?.a).b', 'in.a?.b', 'in?.a?.b', 'in[0]?.a', 'in()?.a', 'in?.a[0]', 'in?.a()']

writeCatalog('tests/language/expressions/optional_chain_remaining/cases.jsonl', expressions.map((expression, index) => {
	const source = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return ${expression}
}
`
	const start = source.indexOf('?.') + 1

	return { id: `language/expressions/optional_chain_remaining/${index}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] }
}))

writeCatalog('upstream/reviews/language/expressions/optional_chain_remaining.jsonl', samples.map(sample => ({
	...sample, status: 'excluded', contract: 'packages/compiler/src/zx/frontend/parser_expressions.zig', cases: [],
})))
