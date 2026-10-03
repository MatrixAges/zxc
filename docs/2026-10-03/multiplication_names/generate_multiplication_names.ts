import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'tests/language/expressions/multiplication/source'
const source = `export type Input = f64;

export type Output = { literal: f64; left: f64; right: f64; both: f64; fields: f64; };

export default function (in: Input): Output {
  const left = in;
  const right = in;
  const object_left = { prop: in };
  const object_right = { prop: in };

  return { literal: 1 * 1, left: left * 1, right: 1 * right, both: left * right, fields: object_left.prop * object_right.prop };
}
`

writeOutput(base + '/values.zx', source)
writeCatalog(
	base + '/values.jsonl',
	[-2, 0, 1, 2, 3].map(input => ({
		id: `language/expressions/multiplication/source/values/${input}`,
		input,
		expected: { value: { literal: 1, left: input, right: input, both: input * input, fields: input * input } }
	}))
)

writeOutput(
	base + '/lines.zx',
	'export type Input = u8;\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n  return 18\n\n*\n\n2\n\n*\n\n9;\n}\n'
)
writeCatalog(base + '/lines.jsonl', [
	{ id: 'language/expressions/multiplication/source/lines', input: 0, expected: { value: 324 } }
])

const rows = []

for (const side of ['left', 'right']) {
	for (const declared of [false, true]) {
		const expression = side === 'left' ? 'missing * 1' : '1 * missing'
		const declaration = declared ? '  const missing = in;\n\n' : ''
		const program = `export type Input = f64;\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n${declaration}  return ${expression};\n}\n`
		const start = program.indexOf('missing')

		rows.push({
			id: `language/expressions/multiplication/names/${side}/${declared ? 'declared' : 'unbound'}`,
			source: program,
			phase: 'analyze',
			diagnostic: declared ? null : 'name',
			...(!declared ? { span: [start, start + 7] } : {})
		})
	}
}

writeCatalog('tests/language/expressions/multiplication/names/cases.jsonl', rows)
