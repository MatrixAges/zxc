import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/call_spread_protocols.jsonl'))
const expressions = ['f(...in)', 'f(0, ...in)', 'f(...[],)', 'f(...[1, 2], 3)', 'f({...in})', 'f({a: 0, ...in})']

writeCatalog('tests/language/expressions/call_spread_protocols/cases.jsonl', expressions.map((expression, index) => {
	const source = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return ${expression}
}
`
	const start = source.indexOf('...')

	return {
		id: `language/expressions/call_spread_protocols/${index}`, source, phase: 'parse',
		diagnostic: index < 4 ? 'syntax' : null,
		...(index < 4 ? { span: [start, start + 3] } : {}),
	}
}))

writeCatalog('upstream/reviews/language/expressions/call_spread_protocols.jsonl', samples.map(sample => ({
	...sample, status: 'excluded', contract: 'packages/compiler/src/zx/frontend/parser_expressions.zig', cases: [],
})))
