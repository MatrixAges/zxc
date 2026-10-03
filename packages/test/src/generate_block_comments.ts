import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Case = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const program =
	'export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return 7;\n}\n'
const fragments = {
	nested: '/*\nvar\n\n/* x */\n= 1;\n*/\n',
	extra_close: '/* var*/\nx*/\n',
	line_open: '// var /*\nx*/\n'
}
const rows: Array<Case> = []

for (const [name, fragment] of Object.entries(fragments)) {
	for (const context of ['module', 'interpolation']) {
		const prefix =
			'export type Input = void;\n\nexport type Output = string;\n\nexport default function (in: Input): Output {\n  return `value=${'
		const source = context === 'module' ? fragment + program : prefix + fragment + '7}`;\n}\n'
		const marker = name === 'nested' ? '=' : context === 'module' ? 'x*/' : '*/'
		const offset =
			name === 'nested'
				? fragment.indexOf(marker)
				: context === 'module'
					? fragment.lastIndexOf(marker)
					: fragment.lastIndexOf(marker) + 1
		const start = (context === 'module' ? 0 : prefix.length) + offset
		rows.push({
			id: `language/lexical/comments/block/${name}/${context}`,
			source,
			phase: 'parse',
			diagnostic: context === 'module' ? 'contract' : 'syntax',
			span: [start, start + 1]
		})
	}
}

for (const context of ['module', 'interpolation']) {
	const fragment = '/* outer /* inner */'
	const source =
		context === 'module'
			? fragment + '\n' + program
			: 'export type Input = void;\n\nexport type Output = string;\n\nexport default function (in: Input): Output {\n  return `value=${' +
				fragment +
				'7}`;\n}\n'
	rows.push({
		id: `language/lexical/comments/block/non_nested/${context}`,
		source,
		phase: 'analyze',
		diagnostic: null
	})
}

writeCatalog('tests/language/lexical/comments/block/structure.jsonl', rows)
writeCatalog(
	'tests/language/lexical/comments/block/unicode.jsonl',
	['line', 'block'].map(mode => ({
		id: `language/lexical/comments/unicode/${mode}_bmp`,
		unicode_comments: { mode, first: 0, last: 0xffff },
		expected: {
			invalid_utf8: 'lexical',
			terminated: 'contract',
			ignored: 'analyze',
			terminators: mode === 'line' ? [10, 13] : []
		}
	}))
)

const strings = ['/*var y = 0*/', '/*var y = 0', '//var y = 0', '*/', '/* // */']
const runtime_rows = strings.map((value, index) => ({
	id: `language/lexical/comments/block/string/${index}`,
	input: index,
	expected: { value }
}))
const branches = strings.map((value, index) => `    case ${index}: return ${JSON.stringify(value)};\n`).join('')

writeCatalog('tests/language/lexical/comments/block/strings.jsonl', runtime_rows)
writeOutput(
	'tests/language/lexical/comments/block/strings.zx',
	'export type Input = u64;\n\nexport type Output = string;\n\nexport default function (in: Input): Output {\n  switch (in) {\n' +
		branches +
		'    default: return "";\n  }\n}\n'
)
