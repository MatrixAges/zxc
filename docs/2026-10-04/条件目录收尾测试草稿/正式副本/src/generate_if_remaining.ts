import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; statement: string; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/if_remaining.jsonl'))
const frontend = []
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []
	const variants = sample.statement ? [sample.statement] : []

	if (/^if \((true|false)\) ; else/.test(sample.statement)) variants.push(sample.statement.replace(') ; else', ') {} else'))

	for (const [index, statement] of variants.entries()) {
		const source = `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  ${statement}\n\n  return 1;\n}\n`
		const remainder = index === 0 ? statement.slice(statement.indexOf(')') + 1).trimStart() : statement.slice(statement.indexOf('else') + 4).trimStart()
		const token = remainder.match(/^(?:[A-Za-z_][A-Za-z_0-9]*|;)/)![0]
		const start = source.indexOf(token, index === 0 ? source.indexOf('  if') + statement.indexOf(')') + 3 : source.indexOf('else') + 4)
		const id = `language/statements/if_remaining/${sample.path.split('/').at(-1)!.replace('.js', '')}/${index === 0 ? 'original' : 'else_only'}`

		frontend.push({ id, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + token.length] })
		cases.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: cases.length ? 'adapted' : 'excluded', reason: sample.reason, contract: 'packages/core/IR契约.md#表达式与求值', cases })
}

writeCatalog('tests/language/statements/if_remaining/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/if_remaining.jsonl', reviews)
