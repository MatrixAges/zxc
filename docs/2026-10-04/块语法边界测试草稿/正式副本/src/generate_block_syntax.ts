import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; status: string; reason: string; case_name?: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/block_syntax.jsonl'))
const shapes = [
	{ name: 'missing_condition_else', body: '  if{};else{}', token: '{' },
	{ name: 'missing_condition_else_if', body: '  if{};else if{}', token: '{' },
	{ name: 'missing_condition_chain', body: '  if{};else if{};else{}', token: '{' },
	{ name: 'semicolon_before_else', body: '  if (in) {\n    return 1\n  };else {\n    return 2\n  }', token: ';' },
	{ name: 'semicolon_before_final_else', body: '  if (in) {\n    return 1\n  } else if (in) {\n    return 2\n  };else {\n    return 3\n  }', token: ';' },
]
const frontend = shapes.map(shape => {
	const source = `export type Input = bool\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n${shape.body}\n\n  return 0\n}\n`
	const start = source.indexOf(shape.token, source.indexOf('  if'))

	return { id: `language/statements/block_syntax/${shape.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] }
})

writeCatalog('tests/language/statements/block_syntax/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/block_syntax.jsonl', samples.map(sample => {
	const row = frontend.find(row => row.id.endsWith(`/${sample.case_name}`))

	return {
		path: sample.path, sha256: sample.sha256, status: sample.status, reason: sample.reason,
		contract: 'packages/compiler/src/zx/frontend/parser_statements.zig',
		cases: row ? [row.id] : [],
		...row ? { diagnostics: [{ case: row.id, phase: row.phase, code: row.diagnostic, span: row.span }] } : {},
	}
}))
