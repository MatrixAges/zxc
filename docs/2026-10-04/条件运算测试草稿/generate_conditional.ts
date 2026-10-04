import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
type Expression = { name: string; source: string; value: boolean | number | string | null }
const frontend: Array<Frontend> = []
const prefix = 'language/expressions/conditional'
const whitespace = { tab: '\t', vertical_tab: '\v', form_feed: '\f', space: ' ', line_feed: '\n', carriage_return: '\r', nbsp: '\u00a0', line_separator: '\u2028', paragraph_separator: '\u2029', combined: '\t\v\f \u00a0\n\r\u2028\u2029' }

function program(args: { input: string; output: string; body: string }): string {
	const { input, output, body } = args

	return `export type Input = ${input};\n\nexport type Output = ${output};\n\nexport default function (in: Input): Output {\n${body}\n}\n`
}

function writeExpressions(name: string, expressions: Array<Expression>): void {
	const output = { boolean: 'bool', number: 'u64', string: 'string', optional: 'bool?' }[name]!
	const branches = expressions.map((expression, index) => `    case ${index}: return ${expression.source};`).join('\n')
	const base = `tests/${prefix}/${name}`

	writeOutput(base + '.zx', program({ input: 'u8', output, body: `  switch (in) {\n${branches}\n    default: return ${expressions[0].source};\n  }` }))
	writeCatalog(base + '.jsonl', expressions.map((expression, index) => ({ id: `${prefix}/${name}/${expression.name}`, input: index, expected: { value: expression.value } })))
}

const boolean_expressions: Array<Expression> = []

for (const condition of [false, true]) {
	for (const yes of [false, true]) {
		for (const no of [false, true]) {
			boolean_expressions.push({ name: `${condition}/${yes}/${no}`, source: `${condition} ? ${yes} : ${no}`, value: condition ? yes : no })
		}
	}
}

for (const [name, gap] of Object.entries(whitespace)) {
	const expression = `false${gap}?${gap}true${gap}:${gap}true`
	const source = program({ input: 'void', output: 'bool', body: `  return ${expression};` })
	const rejected = [...gap].find(character => character.charCodeAt(0) > 127)
	const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0

	frontend.push({ id: `language/lexical/conditional/${name}`, source, phase: rejected ? 'parse' : 'analyze', diagnostic: rejected ? 'lexical' : null, ...(rejected ? { span: [start, start + 1] } : {}) })
	if (!rejected) boolean_expressions.push({ name: `whitespace/${name}`, source: expression, value: true })
}

writeExpressions('boolean', boolean_expressions)

for (const [name, yes, no, yes_value, no_value] of [
	['number', '0', '1', 0, 1],
	['string', '""', '"1"', '', '1'],
	['optional', 'null', 'true', null, true],
] as const) {
	writeExpressions(name, [false, true].flatMap(condition => [
		{ name: `${condition}/forward`, source: `${condition} ? ${yes} : ${no}`, value: condition ? yes_value : no_value },
		{ name: `${condition}/reverse`, source: `${condition} ? ${no} : ${yes}`, value: condition ? no_value : yes_value },
	]))
}

const coalesce_base = `tests/${prefix}/coalesce`

writeOutput(coalesce_base + '.zx', program({ input: '{ value: bool?; fallback: bool; }', output: 'u64', body: '  return in.value ?? in.fallback ? 0 : 42;' }))
writeCatalog(coalesce_base + '.jsonl', [null, false, true].flatMap(value => [false, true].map(fallback => ({ id: `${prefix}/coalesce/${value}/${fallback}`, input: { value, fallback }, expected: { value: (value ?? fallback) ? 0 : 42 } }))))

for (const [name, condition] of [['zero', '0'], ['one', '1'], ['empty_string', '""'], ['nonempty_string', '"1"']]) {
	frontend.push({ id: `language/types/conditional/${name}`, source: program({ input: 'void', output: 'bool', body: `  return ${condition} ? false : true;` }), phase: 'analyze', diagnostic: 'type_mismatch' })
}

for (const [name, input, body] of [
	['optional_condition', 'bool?', 'return in ? false : true;'],
	['mixed_branches', 'bool', 'return in ? 1 : true;'],
	['coalesce_nonoptional', 'bool', 'return in ?? false ? false : true;'],
	['coalesce_numeric', '{ value: u64?; fallback: u64; }', 'return in.value ?? in.fallback ? false : true;'],
]) {
	frontend.push({ id: `language/types/conditional/${name}`, source: program({ input, output: 'bool', body: `  ${body}` }), phase: 'analyze', diagnostic: 'type_mismatch' })
}

writeCatalog('tests/language/types/conditional/cases.jsonl', frontend)
