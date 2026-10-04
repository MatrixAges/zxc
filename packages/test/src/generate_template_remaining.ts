import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_remaining.jsonl'))
const endings = { lf: '\n', cr: '\r', crlf: '\r\n', ls: '\u2028', ps: '\u2029' }
const rows = []

for (const [name, ending] of Object.entries(endings)) {
	for (const context of ['direct', 'nested']) {
		const literal = '`A\\' + ending + 'B`'
		const expression = context === 'direct' ? literal : '`前${' + literal + '}后`'
		const source = `export type Input = void\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`
		const start = Buffer.byteLength(source.slice(0, source.indexOf('\\')))

		rows.push({
			id: `language/lexical/template_continuations/${name}/${context}`,
			source, phase: 'parse', diagnostic: 'lexical', span: [start, start + 2],
		})
	}
}

writeCatalog('tests/language/lexical/template_continuations/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/template_remaining.jsonl', samples.map(sample => ({
	path: sample.path, sha256: sample.sha256, status: 'excluded', reason: sample.reason,
	contract: sample.name.endsWith('-method') || sample.name.endsWith('-eval') ? 'packages/core/IR契约.md' : 'packages/compiler/src/zx/frontend/template.zig',
	cases: [],
})))
