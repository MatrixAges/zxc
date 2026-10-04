import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; statement: string; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/if_declarations.jsonl'))
const frontend = []
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []
	const variants = sample.statement ? [sample.statement] : []

	if (sample.statement.startsWith('if (false) ; else')) variants.push(sample.statement.replace('if (false) ; else', 'if (false) {} else'))

	for (const [index, statement] of variants.entries()) {
		const source = `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  ${statement}\n\n  return 1;\n}\n`
		const name = sample.path.split('/').at(-1)!.replace('.js', '')
		const token = index === 1 ? statement.includes('const') ? 'const' : 'let' : statement.startsWith('if (false) ;') || name === 'empty-statement' ? ';' : statement.includes('const') ? 'const' : 'let'
		const start = source.indexOf(token, source.indexOf('  if'))
		const id = `language/statements/if_declarations/${name}/${index === 0 ? 'original' : 'else_only'}`

		frontend.push({ id, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + token.length] })
		cases.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: cases.length ? 'adapted' : 'excluded', reason: sample.reason, contract: 'packages/core/IR契约.md#表达式与求值', cases })
}

const blocks = [
	'if (true) { const x: u64? = null; } else { const y: u64? = null; }',
	'if (true) { const x: u64? = null; } else {}',
	'if (true) { const x: u64? = null; }',
	'if (false) {} else { const x: u64? = null; }',
	'if (true) {}',
]

for (const [index, statement] of blocks.entries()) frontend.push({ id: `language/statements/if_declarations/block/${index}`, source: `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  ${statement}\n\n  return 1;\n}\n`, phase: 'analyze', diagnostic: null })

writeCatalog('tests/language/statements/if_declarations/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/if_declarations.jsonl', reviews)
