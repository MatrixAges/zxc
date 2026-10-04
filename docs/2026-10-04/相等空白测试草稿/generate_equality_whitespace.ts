import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const whitespace: Record<string, string> = {
	tab: '\t', vertical_tab: '\v', form_feed: '\f', space: ' ', nbsp: '\u00a0',
	line_feed: '\n', carriage_return: '\r', line_separator: '\u2028', paragraph_separator: '\u2029',
}

whitespace.combined = Object.values(whitespace).join('')

const frontend: Array<Frontend> = []

for (const [name, operator] of [['equal', '=='], ['not_equal', '!=']]) {
	const runtime = []
	const branches: Array<string> = []

	for (const [gap_name, gap] of Object.entries(whitespace)) {
		const rejected = [...gap].find(character => character.charCodeAt(0) > 127)

		for (const position of ['left', 'right', 'both']) {
			const left_gap = position === 'right' ? ' ' : gap
			const right_gap = position === 'left' ? ' ' : gap

			for (const scalar of ['number', 'mixed']) {
				const left = scalar === 'number' ? '1' : 'true'
				const expression = `${left}${left_gap}${operator}${right_gap}1`
				const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return ${expression};\n}\n`
				const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0

				frontend.push({
					id: `language/types/equality_whitespace/${name}/${gap_name}/${position}/${scalar}`,
					source,
					phase: rejected ? 'parse' : 'analyze',
					diagnostic: rejected ? 'lexical' : scalar === 'mixed' ? 'type_mismatch' : null,
					...(rejected ? { span: [start, start + 1] } : {}),
				})
			}

			if (rejected) continue

			const shape = branches.length

			branches.push(`    case ${shape}: return in.value${left_gap}${operator}${right_gap}1;`)

			for (const value of [1, 2]) {
				runtime.push({
					id: `language/expressions/comparison/whitespace/${name}/${gap_name}/${position}/${value}`,
					input: { shape, value },
					expected: { value: name === 'equal' ? value === 1 : value !== 1 },
				})
			}
		}
	}

	const base = `tests/language/expressions/comparison/whitespace/${name}`

	writeCatalog(base + '.jsonl', runtime)
	writeOutput(base + '.zx', `export type Input = { shape: u64; value: f64; };\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  switch (in.shape) {\n${branches.join('\n')}\n    default: return false;\n  }\n}\n`)
}

writeCatalog('tests/language/types/equality_whitespace/cases.jsonl', frontend)
