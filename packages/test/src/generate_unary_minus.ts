import { boundaries, hex } from './generate_division.ts'
import { decode } from './models/ieee.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const bodies = {
	direct: '  return -in\n',
	binding: '  const value = in\n\n  return -value\n',
	double: '  return -(-in)\n',
	field: '  const object = { value: in }\n\n  return -object.value\n'
}

for (const width of [32, 64]) {
	const scalar = `f${width}`
	const sign = 1n << BigInt(width - 1)

	for (const [shape, body] of Object.entries(bodies)) {
		const rows = Object.entries(boundaries(width)).map(([name, bits]) => ({
			id: `language/expressions/unary_minus/${scalar}/${shape}/${name}`,
			input: hex(bits, width),
			expected: decode(bits, width) === 'nan' ? 'nan' : hex(shape === 'double' ? bits : bits ^ sign, width)
		}))
		const base = `tests/language/expressions/unary_minus/${scalar}/${shape}`

		writeCatalog(base + '.jsonl', rows)
		writeOutput(
			base + '.zx',
			`export type Input = ${scalar}

export type Output = ${scalar}

export default function (in: Input): Output {
${body.trimEnd()}\n}\n`
		)
	}
}

const types = {
	u8: 'u8',
	u16: 'u16',
	u32: 'u32',
	u64: 'u64',
	i32: 'i32',
	i64: 'i64',
	f32: 'f32',
	f64: 'f64',
	bool: 'bool',
	string: 'string',
	list: 'u64[]',
	object: '{ value: u64 }'
}
const rows: Array<{ id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }> = []

for (const [name, type] of Object.entries(types)) {
	const allowed = ['i32', 'i64', 'f32', 'f64'].includes(name)
	rows.push({
		id: `language/types/unary_minus/${name}`,
		source: `export type Input = ${type}

export type Output = ${type}

export default function (in: Input): Output {
  return -in
}
`,
		phase: 'analyze',
		diagnostic: allowed ? null : 'type_mismatch'
	})
}

for (const literal of ['""', '"1"', '"x"', 'false', 'true']) {
	rows.push({
		id: `language/types/unary_minus/literal/${literal}`,
		source: `export type Input = void

export type Output = f64

export default function (in: Input): Output {
  return -${literal}
}
`,
		phase: 'analyze',
		diagnostic: 'type_mismatch'
	})
}

for (const declared of [false, true]) {
	const binding = declared ? '  const missing = in\n\n' : ''
	const source = `export type Input = f64

export type Output = f64

export default function (in: Input): Output {
${binding}  return -missing
}
`
	const start = source.indexOf('missing')
	rows.push({
		id: `language/types/unary_minus/name/${declared ? 'declared' : 'unbound'}`,
		source,
		phase: 'analyze',
		diagnostic: declared ? null : 'name',
		...(!declared ? { span: [start, start + 7] } : {})
	})
}

for (const [name, input_type, expression, phase, diagnostic] of [
	['null', 'void', '-null', 'analyze', 'type_mismatch'],
	['undefined', 'void', '-undefined', 'analyze', 'name'],
	['void_input', 'void', '-in', 'analyze', 'type_mismatch'],
	['optional_number', 'f64?', '-in', 'analyze', 'type_mismatch'],
	['empty_object', 'void', '-{}', 'analyze', 'type_mismatch'],
	['function_expression', 'void', '-function(){return 1}', 'parse', 'syntax'],
	['void_expression', 'void', '-void 0', 'parse', 'syntax'],
]) {
	rows.push({
		id: `language/types/unary_minus/conversion/${name}`,
		source: `export type Input = ${input_type}

export type Output = f64

export default function (in: Input): Output {
  return ${expression}
}
`,
		phase,
		diagnostic,
	})
}

writeCatalog('tests/language/types/unary_minus/cases.jsonl', rows)

const expressions = ['-1', '-(-1)', '-x', '-(-x)', '-object.prop', '-(1)']
const values = [-1, 1, 1, -1, -1, -1]
const literal_rows = expressions.map((expression, index) => ({
	id: `language/expressions/unary_minus/f64/source_values/${index}`,
	input: index,
	expected: { value: values[index] }
}))
const branches = expressions
	.map(
		(expression, index) => `    case ${index}: return ${expression}
`
	)
	.join('')

writeCatalog('tests/language/expressions/unary_minus/f64/source_values.jsonl', literal_rows)
writeOutput(
	'tests/language/expressions/unary_minus/f64/source_values.zx',
	'export type Input = u64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n  const x = -1.0\n  const object = { prop: 1.0 }\n\n  switch (in) {\n' +
		branches +
		'    default: return 0\n  }\n}\n'
)
