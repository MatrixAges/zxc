import { range, writeCatalog, writeOutput } from './shared/catalog.ts'

const digits = range(10)
const vectors = [
	digits.map(BigInt),
	digits.map(digit => BigInt(9 - digit)),
	digits.map(() => 0n),
	digits.map(digit => (digit % 2 ? 0n : 18446744073709551615n))
]
const input_fields = digits.map(digit => `  v${digit}: u64`).join('\n')

for (const position of ['suffix', 'middle', 'underscore']) {
	const names = digits.map(digit =>
		position === 'suffix' ? `a${digit}` : position === 'middle' ? `a${digit}b` : `a_${digit}`
	)
	const bindings = names.map((name, digit) => `  const ${name} = in.v${digit}`).join('\n')
	const branches = names.map((name, digit) => `    case ${digit}:\n      return ${name}`).join('\n')
	const base = `language/lexical/identifiers/digits/${position}`
	const rows = vectors.flatMap((values, vector) =>
		digits.map(selector => ({
			id: `${base}/${names[selector]}/${vector}`,
			input: { selector, ...Object.fromEntries(values.map((value, digit) => [`v${digit}`, value])) },
			expected: { value: values[selector] }
		}))
	)

	writeOutput(
		`tests/${base}.zx`,
		`export type Input = {\n  selector: u64\n${input_fields}\n}\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n${bindings}\n\n  switch (in.selector) {\n${branches}\n    default:\n      return 0\n  }\n}\n`
	)
	writeCatalog(`tests/${base}.jsonl`, rows)
}
