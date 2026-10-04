import { rawJson } from './shared/json.ts'
import { range, writeCatalog, writeOutput } from './shared/catalog.ts'

const examples: Record<string, Array<[string, number]>> = {
	u64: [
		['1_1', 11],
		['1_0123456789', 10123456789],
		...range(10).map(digit => [`123456789_${digit}`, 1234567890 + digit] as [string, number])
	],
	f64: [
		['1.0e+1_0', 1e10],
		['1.0e-1_0', 1e-10],
		['10.00_01e2', 1000.01]
	]
}

for (const [scalar, values] of Object.entries(examples)) {
	const rows = values.map(([token, value], index) => ({
		id: `language/lexical/numeric/runtime/${scalar}/${token}`,
		input: index,
		expected: { value: scalar === 'f64' && Number.isInteger(value) ? rawJson(String(value) + '.0') : value }
	}))
	const branches = values
		.map(
			([token], index) => `    case ${index}: return ${token}
`
		)
		.join('')
	const source =
		`export type Input = u64

export type Output = ${scalar}

export default function (in: Input): Output {
  switch (in) {
` +
		branches +
		'    default: return 0\n  }\n}\n'
	const base = `tests/language/lexical/numeric/literals_${scalar}`

	writeCatalog(base + '.jsonl', rows)
	writeOutput(base + '.zx', source)
}
