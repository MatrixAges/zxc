import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/switch_environment.jsonl'))
const shapes = [
	{ name: 'default_const_escape', token: 'x', body: '  switch (in) {\n    default:\n      const x = 1\n  }\n\n  return x' },
	{ name: 'empty_default_unbound', token: 'f', body: '  switch (in) {\n    default:\n  }\n\n  return f' },
]
const frontend = shapes.map(shape => {
	const source = `export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n${shape.body}\n}\n`
	const start = source.lastIndexOf(shape.token)

	return { id: `language/statements/switch_environment/${shape.name}`, source, phase: 'analyze', diagnostic: 'name', span: [start, start + 1] }
})

writeCatalog('tests/language/statements/switch_environment/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/switch_environment.jsonl', samples.map((sample, index) => ({
	...sample,
	status: index < 2 ? 'adapted' : 'excluded',
	contract: 'packages/compiler/src/zx/analysis/switch.zig',
	cases: index < 2 ? [frontend[index].id] : [],
	...index < 2 ? { diagnostics: [{ case: frontend[index].id, phase: 'analyze', code: 'name', span: frontend[index].span }] } : {},
})))
