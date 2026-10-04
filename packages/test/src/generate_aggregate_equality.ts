import { writeCatalog } from './shared/catalog.ts'

const pairs = [
	['ordinary', 'u64', '0', 'u64', '0'],
	['boxed_true', 'bool', 'true', 'bool', 'true'],
	['boxed_false', 'bool', 'false', 'bool', 'false'],
	['boxed_zero', 'f64', '0', 'f64', '-0'],
	['alias', 'u64', '0', 'u64', '0'],
	['boolean_number', 'bool', 'true', 'f64', '1'],
	['number_string', 'f64', '1', 'string', '"1"'],
	['string_boolean', 'string', '"1"', 'bool', 'true'],
]
const rows: Array<{ id: string; source: string; phase: string; diagnostic: string | null }> = []

function addCase(args: { name: string; input: string; body: string; diagnostic: string | null }): void {
	const { name, input, body, diagnostic } = args

	rows.push({
		id: `language/types/aggregate_equality/${name}`,
		source: `export type Input = ${input}

export type Output = bool

export default function (in: Input): Output {
${body}\n}\n`,
		phase: 'analyze',
		diagnostic,
	})
}

for (const [name, operator] of [['equal', '=='], ['not_equal', '!=']]) {
	for (const [label, left_type, left, right_type, right] of pairs) {
		const declarations = label === 'alias'
			? '  const left = in\n  const right = left\n'
			: `  const left: { value: ${left_type} } = { value: ${left} }
  const right: { value: ${right_type} } = { value: ${right} }
`

		addCase({ name: `${name}/upstream/${label}`, input: '{ value: u64 }', body: `${declarations}\n\n  return left ${operator} right
`, diagnostic: 'type_mismatch' })
	}

	for (const [label, input, body] of [
		['same_object', '{ value: u64 }', `  return in ${operator} in
`],
		['same_list', 'u64[]', `  return in ${operator} in
`],
		['alias_list', 'u64[]', `  const alias = in

  return in ${operator} alias
`],
		['distinct_list', '{ left: u64[]\n right: u64[] }', `  return in.left ${operator} in.right
`],
	]) {
		addCase({ name: `${name}/${label}`, input, body, diagnostic: 'type_mismatch' })
	}

	for (const scalar of ['bool', 'f64', 'string']) {
		addCase({ name: `${name}/fields/${scalar}`, input: `{ left: { value: ${scalar} }, right: { value: ${scalar} } }`, body: `  return in.left.value ${operator} in.right.value
`, diagnostic: null })
	}
}

writeCatalog('tests/language/types/aggregate_equality/cases.jsonl', rows)
