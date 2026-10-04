import { writeCatalog, writeOutput } from './shared/catalog.ts'

const leading_zero = ['00_0', '01_0', '07_0', '0_0', '0_1', '0_7', '08_0', '09_0', '0_8', '0_9', '0_0123456789']
const rejected: Array<[string, string, string, number, number]> = []

for (const prefix of ['b', 'x', 'o']) {
	for (const tail of ['_1', '0__0', '0_']) {
		const token = '0' + prefix + tail
		rejected.push([token, 'parse', 'syntax', 1, token.length])
	}
}

for (const token of ['10._1', '10._e1', '10._']) rejected.push([token, 'analyze', 'type_mismatch', 3, token.length])

rejected.push(['.0_e1', 'parse', 'lexical', 1, 5])
for (const token of ['._e1', '._']) rejected.push([token, 'parse', 'syntax', 0, 1])
rejected.push(['0__0123456789', 'parse', 'lexical', 0, 13], ['1\\u005F0123456789', 'parse', 'lexical', 1, 2])

const negatives = []

for (const [token, phase, diagnostic, start, end] of rejected) {
	for (const context of ['return', 'interpolation']) {
		const output = context === 'return' ? 'f64' : 'string'
		const expression = context === 'return' ? token : '`value=${' + token + '}`'
		const prefix = `export type Input = void

export type Output = ${output}

export default function (in: Input): Output {
  return `
		const offset = prefix.length + (context === 'interpolation' ? 9 : 0)
		negatives.push({
			id: `language/lexical/numeric/boundaries/${context}/${token}`,
			source: prefix + expression + '\n}\n',
			phase,
			diagnostic,
			span: [offset + start, offset + end]
		})
	}
}

const values = leading_zero.map((token, index) => ({
	id: `language/lexical/numeric/leading_zero/${token}`,
	input: index,
	expected: { value: Number(token.replaceAll('_', '')) }
}))
const branches = leading_zero
	.map(
		(token, index) => `    case ${index}: return ${token}
`
	)
	.join('')
const source =
	'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  switch (in) {\n' +
	branches +
	'    default: return 0\n  }\n}\n'
const root = 'tests/language/lexical/numeric/'

writeCatalog(root + 'boundaries.jsonl', negatives)
writeCatalog(root + 'leading_zero.jsonl', values)
writeOutput(root + 'leading_zero.zx', source)
