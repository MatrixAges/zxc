import { writeCatalog } from './shared/catalog.ts'

const groups: Record<string, Array<[string, string, string | null, string | null]>> = {
	left: [
		['true', '1', 'bool', 'f64'],
		['false', '"0"', 'bool', 'string'],
		['true', 'new Boolean(true)', null, null],
		['true', '{valueOf: function () {return 1}}', null, null],
	],
	right: [
		['0', 'false', 'f64', 'bool'],
		['"1"', 'true', 'string', 'bool'],
		['new Boolean(false)', 'false', null, null],
		['{valueOf: function () {return "0"}}', 'false', null, null],
	],
}
const rows: Array<{ id: string; source: string; phase: string; diagnostic: string | null }> = []

for (const [group, pairs] of Object.entries(groups)) {
	for (const [index, [left, right, left_type, right_type]] of pairs.entries()) {
		for (const shape of left_type === null ? ['original'] : ['original', 'bound']) {
			const body = shape === 'original'
				? `  return ${left} != ${right}
`
				: `  const left: ${left_type} = ${left}
  const right: ${right_type} = ${right}

  return left != right
`

			rows.push({
				id: `language/types/boolean_inequality/${group}/${index + 1}/${shape}`,
				source: `export type Input = void

export type Output = bool

export default function (in: Input): Output {
${body}\n}\n`,
				phase: left_type === null ? 'parse' : 'analyze',
				diagnostic: left_type === null ? 'syntax' : 'type_mismatch',
			})
		}
	}
}

rows.push({
	id: 'language/types/boolean_inequality/control',
	source: 'export type Input = { left: bool\n right: bool }\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n  return in.left != in.right\n}\n',
	phase: 'analyze',
	diagnostic: null,
})

writeCatalog('tests/language/types/boolean_inequality/cases.jsonl', rows)
