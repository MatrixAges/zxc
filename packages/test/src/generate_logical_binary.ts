import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const frontend: Array<Frontend> = []
const whitespace: Record<string, string> = { tab: '\t', vertical_tab: '\v', form_feed: '\f', space: ' ', nbsp: '\u00a0', line_feed: '\n', carriage_return: '\r', line_separator: '\u2028', paragraph_separator: '\u2029' }
const types = { integer: 'u64', number: 'f64', string: 'string', list: 'u64[]', object: '{ value: bool }', optional_bool: 'bool?', void: 'void' }

whitespace.combined = Object.values(whitespace).join('')

function program(input: string, body: string): string {
	return `export type Input = ${input}

export type Output = bool

export default function (in: Input): Output {
${body}\n}\n`
}

for (const [name, operator] of [['logical_and', '&&'], ['logical_or', '||']] as const) {
	const expressions: Array<{ name: string; source: string; value: boolean }> = []

	for (const left of [false, true]) {
		for (const right of [false, true]) {
			expressions.push({ name: `literal/${left}/${right}`, source: `${left} ${operator} ${right}`, value: name === 'logical_and' ? left && right : left || right })
		}
	}

	for (const [binding, expression] of [['binding_left', `x ${operator} true`], ['binding_both', `x ${operator} y`], ['field_both', `object.left ${operator} object.right`]]) {
		expressions.push({ name: binding, source: expression, value: name === 'logical_or' })
	}

	for (const [gap_name, gap] of Object.entries(whitespace)) {
		const expression = `${name === 'logical_and'}${gap}${operator}${gap}true`
		const source = program('void', `  return ${expression}
`)
		const rejected = [...gap].find(character => character.charCodeAt(0) > 127)
		const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0

		frontend.push({ id: `language/lexical/${name}/${gap_name}`, source, phase: rejected ? 'parse' : 'analyze', diagnostic: rejected ? 'lexical' : null, ...(rejected ? { span: [start, start + 1] } : {}) })
		if (!rejected) expressions.push({ name: `whitespace/${gap_name}`, source: expression, value: true })
	}

	for (const [type_name, type] of Object.entries(types)) {
		for (const side of ['left', 'right']) {
			for (const value of [false, true]) {
				const expression = side === 'left' ? `in ${operator} ${value}` : `${value} ${operator} in`

				frontend.push({ id: `language/types/${name}/${side}/${value}/${type_name}`, source: program(type, `  return ${expression}
`), phase: 'analyze', diagnostic: 'type_mismatch' })
			}
		}
	}

	for (const [value_name, declaration] of [
		['empty_string', 'const value: string = ""\n'],
		['nonempty_string', 'const value: string = "1"\n'],
		['null_optional', 'const value: bool? = null\n'],
	]) {
		for (const side of ['left', 'right']) {
			for (const value of [false, true]) {
				const expression = side === 'left' ? `value ${operator} ${value}` : `${value} ${operator} value`

				frontend.push({ id: `language/types/${name}/literal/${value_name}/${side}/${value}`, source: program('void', `  ${declaration}\n\n  return ${expression}
`), phase: 'analyze', diagnostic: 'type_mismatch' })
			}
		}
	}

	for (const side of ['left', 'right']) {
		const input = side === 'left' ? '{ left: { prop: f64 }\n right: { prop: bool } }' : '{ left: { prop: bool }\n right: { prop: f64 } }'

		frontend.push({ id: `language/types/${name}/numeric_field/${side}`, source: program(input, `  return in.left.prop ${operator} in.right.prop
`), phase: 'analyze', diagnostic: 'type_mismatch' })
	}

	const branches = expressions.map((expression, index) => `    case ${index}: return ${expression.source}
`).join('\n')
	const body = `  const x = false
  const y = true
  const object = { left: false, right: true }

  switch (in) {
${branches}
    default: return false
  }`
	const base = `tests/language/expressions/${name}/source`

	writeCatalog(base + '.jsonl', expressions.map((expression, index) => ({ id: `language/expressions/${name}/source/${expression.name}`, input: index, expected: { value: expression.value } })))
	writeOutput(base + '.zx', program('u8', body))
}

writeCatalog('tests/language/types/logical_binary/cases.jsonl', frontend)
