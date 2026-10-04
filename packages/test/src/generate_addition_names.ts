import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'tests/language/expressions/addition/source'
const source = `export type Input = { left: f64
 right: f64 }

export type Output = { literal: f64
 left: f64
 right: f64
 both: f64
 fields: f64 }

export default function (in: Input): Output {
  const left = in.left
  const right = in.right
  const object_left = { prop: in.left }
  const object_right = { prop: in.right }

  return { literal: 1 + 1, left: left + 1, right: 1 + right, both: left + right, fields: object_left.prop + object_right.prop }
}
`

writeOutput(base + '/values.zx', source)
writeCatalog(
	base + '/values.jsonl',
	[{ left: 1, right: 1 }, { left: 5, right: 3 }, { left: -5, right: 3 }, { left: 5, right: -3 }].map(input => ({
		id: `language/expressions/addition/source/values/${input.left}/${input.right}`,
		input,
		expected: { value: { literal: 2, left: input.left + 1, right: 1 + input.right, both: input.left + input.right, fields: input.left + input.right } }
	}))
)

const rows = []

for (const side of ['left', 'right']) {
	for (const declared of [false, true]) {
		const expression = side === 'left' ? 'missing + 1' : '1 + missing'
		const declaration = declared ? '  const missing = in\n\n' : ''
		const program = `export type Input = f64

export type Output = f64

export default function (in: Input): Output {
${declaration}  return ${expression}
}
`
		const start = program.indexOf('missing')

		rows.push({
			id: `language/expressions/addition/names/${side}/${declared ? 'declared' : 'unbound'}`,
			source: program,
			phase: 'analyze',
			diagnostic: declared ? null : 'name',
			...(!declared ? { span: [start, start + 7] } : {})
		})
	}
}

writeCatalog('tests/language/expressions/addition/names/cases.jsonl', rows)

