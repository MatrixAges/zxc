import { writeCatalog, writeOutput } from './shared/catalog.ts'

const root = 'tests/language/expressions/logical_not/'
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
	object: '{ value: u64 }',
	optional_bool: 'bool?',
	void: 'void'
}
type Case = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const frontend: Array<Case> = []

function program(input: string, expression: string): string {
	return `export type Input = ${input}

export type Output = bool

export default function (in: Input): Output {
  return ${expression}
}
`
}

for (const [name, type] of Object.entries(types))
	frontend.push({
		id: `language/types/logical_not/${name}`,
		source: program(type, '!in'),
		phase: 'analyze',
		diagnostic: name === 'bool' ? null : 'type_mismatch'
	})
for (const literal of [
	'0',
	'-0',
	'13',
	'-13',
	'1.3',
	'-1.3',
	'0.1',
	'""',
	'" "',
	'"Nonempty String"',
	'"1"',
	'"x"',
	'null'
])
	frontend.push({
		id: `language/types/logical_not/literal/${literal}`,
		source: program('void', `!(${literal})`),
		phase: 'analyze',
		diagnostic: 'type_mismatch'
	})

for (const declared of [false, true]) {
	const source = program('bool', '!missing').replace(
		'  return',
		(declared ? '  const missing = in\n\n' : '') + '  return'
	)
	const start = source.indexOf('missing')
	frontend.push({
		id: `language/types/logical_not/name/${declared ? 'declared' : 'unbound'}`,
		source,
		phase: 'analyze',
		diagnostic: declared ? null : 'name',
		...(!declared ? { span: [start, start + 7] } : {})
	})
}

const whitespace: Record<string, string> = {
	tab: '\t',
	vertical_tab: '\v',
	form_feed: '\f',
	space: ' ',
	nbsp: '\u00a0',
	line_feed: '\n',
	carriage_return: '\r',
	line_separator: '\u2028',
	paragraph_separator: '\u2029'
}
whitespace.combined = Object.values(whitespace).join('')
const source_expressions = ['!true', '!(!true)', '!x', '!(!x)', '!object.prop', '!false', '!(true)', '!(false)']
const source_values = [false, true, false, true, false, true, false, true]
const source_rows = source_values.map((value, index) => ({
	id: `language/expressions/logical_not/source/${index}`,
	input: index,
	expected: { value }
}))

for (const [name, gap] of Object.entries(whitespace)) {
	const source = program('void', '!' + gap + 'true')
	const rejected = [...gap].find(character => character.charCodeAt(0) > 127)
	const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0
	frontend.push({
		id: `language/lexical/logical_not/${name}`,
		source,
		phase: rejected ? 'parse' : 'analyze',
		diagnostic: rejected ? 'lexical' : null,
		...(rejected ? { span: [start, start + 1] } : {})
	})
	if (!rejected) {
		source_rows.push({
			id: `language/expressions/logical_not/whitespace/${name}`,
			input: source_expressions.length,
			expected: { value: false }
		})
		source_expressions.push('!' + gap + 'true')
	}
}

const branches = source_expressions
	.map(
		(expression, index) => `    case ${index}: return ${expression}
`
	)
	.join('')
writeCatalog(root + 'source.jsonl', source_rows)
writeOutput(
	root + 'source.zx',
	'export type Input = u64\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n  const x = true\n  const object = { prop: true }\n\n  switch (in) {\n' +
		branches +
		'    default: return false\n  }\n}\n'
)
for (const [name, input_type, expression, phase, diagnostic] of [
	['undefined', 'void', '!(undefined)', 'analyze', 'name'],
	['void_expression', 'void', '!(void 0)', 'parse', 'syntax'],
	['empty_object', 'void', '!{}', 'analyze', 'type_mismatch'],
	['function_expression', 'void', '!(function(){return 1})', 'parse', 'syntax'],
	['eval', 'void', '!(eval("var x"))', 'analyze', 'name'],
	['nan_name', 'void', '!NaN', 'analyze', 'name'],
	['infinity_name', 'void', '!Infinity', 'analyze', 'name'],
	['nan_value', 'void', '!(0.0 / 0.0)', 'analyze', 'type_mismatch'],
	['positive_infinity', 'void', '!(1.0 / 0.0)', 'analyze', 'type_mismatch'],
	['negative_infinity', 'void', '!(-1.0 / 0.0)', 'analyze', 'type_mismatch'],
	['optional_number', 'f64?', '!in', 'analyze', 'type_mismatch'],
]) {
	frontend.push({
		id: `language/types/logical_not/conversion/${name}`,
		source: program(input_type, expression),
		phase,
		diagnostic,
	})
}

writeCatalog('tests/language/types/logical_not/cases.jsonl', frontend)

const values = [false, true].map(input => ({
	id: `language/expressions/logical_not/values/${input}`,
	input,
	expected: { value: { direct: !input, binding: !input, double: input, field: !input, triple: !input } }
}))
writeCatalog(root + 'values.jsonl', values)
writeOutput(
	root + 'values.zx',
	'export type Input = bool\n\nexport type Output = { direct: bool\n binding: bool\n double: bool\n field: bool\n triple: bool }\n\nexport default function (in: Input): Output {\n  const bound = in\n  const object = { prop: in }\n\n  return { direct: !in, binding: !bound, double: !!in, field: !object.prop, triple: !!!in }\n}\n'
)

const operations: Array<[string, string, (left: boolean, right: boolean) => boolean]> = [
	['not_left_and', '!in.left && in.right', (left, right) => !left && right],
	['not_group_and', '!(in.left && in.right)', (left, right) => !(left && right)],
	['not_left_or', '!in.left || in.right', (left, right) => !left || right],
	['not_group_or', '!(in.left || in.right)', (left, right) => !(left || right)]
]

for (const [name, expression, evaluate] of operations) {
	const rows = [false, true].flatMap(left =>
		[false, true].map(right => ({
			id: `language/expressions/logical_not/precedence/${name}/${left}/${right}`,
			input: { left, right },
			expected: { value: evaluate(left, right) }
		}))
	)
	writeCatalog(root + 'precedence/' + name + '.jsonl', rows)
	writeOutput(root + 'precedence/' + name + '.zx', program('{ left: bool\n right: bool }', expression))
}
