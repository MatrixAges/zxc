import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/optional_chain_boundary.jsonl'))
const rejected = [
	{ name: 'member', expression: 'in?.value' },
	{ name: 'index', expression: 'in?.[0]' },
	{ name: 'call', expression: 'in?.()' },
	{ name: 'assignment', expression: 'in?.value = 3' },
	{ name: 'prefix', expression: '--in?.value' },
	{ name: 'postfix', expression: 'in?.value++' },
	{ name: 'decimal', expression: 'true ?.30 : false' },
	...['null', 'in'].flatMap(base => ['', 'fn'].flatMap(tail => ['', '\n  '].map((gap, index) => ({
		name: `template/${base}/${tail || 'direct'}/${index}`,
		expression: base + '?.' + tail + gap + '`hello`',
	})))),
]
const accepted = ['true ? 0.30 : false', 'in ? 3 : 4', 'in ? (3) : (4)', 'in ?? 3']
const rows = [
	...rejected.map(item => ({ ...item, rejected: true })),
	...accepted.map((expression, index) => ({ name: `control/${index}`, expression, rejected: false })),
].map(item => {
	const source = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return ${item.expression}
}
`
	const start = source.indexOf('?.') + 1

	return {
		id: `language/expressions/optional_chain_boundary/${item.name}`, source, phase: 'parse',
		diagnostic: item.rejected ? 'syntax' : null,
		...(item.rejected ? { span: [start, start + 1] } : {}),
	}
})

writeCatalog('tests/language/expressions/optional_chain_boundary/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/optional_chain_boundary.jsonl', samples.map(sample => ({
	...sample, status: 'excluded', contract: 'packages/compiler/src/zx/frontend/parser_expressions.zig', cases: [],
})))
