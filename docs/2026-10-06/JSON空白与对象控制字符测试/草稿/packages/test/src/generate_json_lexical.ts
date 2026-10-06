import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Case = { id: string; json_text: string; expected: { value: Json } | { error: string } }
const prefix = 'built_ins/json/parse/lexical'
const numbers: Array<Case> = []

for (const [index, whitespace] of ['\t', '\r', '\n', ' '].entries()) {
	const id = `${prefix}/g1_${index + 1}`

	numbers.push({ id: id + '/leading', json_text: whitespace + '1234', expected: { value: 1234 } })
	numbers.push({ id: id + '/between', json_text: '12' + whitespace + '34', expected: { error: 'SyntaxError' } })
}

const definitions: Array<{ name: string; text: string; expected: { value: Json } | { error: string } }> = [
	{ name: 'g2_1', text: '"abc"', expected: { value: 'abc' } },
	{ name: 'g2_2', text: "'abc'", expected: { error: 'SyntaxError' } },
	{ name: 'g2_3', text: '\\u0022abc\\u0022', expected: { error: 'SyntaxError' } },
	{ name: 'g2_4', text: '"abc\'', expected: { error: 'UnexpectedEndOfInput' } },
	{ name: 'g2_5', text: '""', expected: { value: '' } },
	{ name: 'g5_1', text: '"\\u0058"', expected: { value: 'X' } },
	{ name: 'g5_2', text: '"\\u005"', expected: { error: 'SyntaxError' } },
	{ name: 'g5_3', text: '"\\u0X50"', expected: { error: 'SyntaxError' } },
	{ name: 'g6_1', text: '"\\/"', expected: { value: '/' } },
	{ name: 'g6_2', text: '"\\\\"', expected: { value: '\\' } },
	{ name: 'g6_3', text: '"\\b"', expected: { value: '\b' } },
	{ name: 'g6_4', text: '"\\f"', expected: { value: '\f' } },
	{ name: 'g6_5', text: '"\\n"', expected: { value: '\n' } },
	{ name: 'g6_6', text: '"\\r"', expected: { value: '\r' } },
	{ name: 'g6_7', text: '"\\t"', expected: { value: '\t' } }
]

const strings: Array<Case> = definitions.map(definition => ({
	id: `${prefix}/${definition.name}`,
	json_text: definition.text,
	expected: definition.expected
}))

for (let group = 0; group < 4; group++) {
	const controls = Array.from({ length: 8 }, (_, index) => String.fromCharCode(group * 8 + index)).join('')

	strings.push({
		id: `${prefix}/g4_${group + 1}`,
		json_text: '"' + controls + '"',
		expected: { error: 'SyntaxError' }
	})
}

const invalid_prefixes = ['\v', '\f', '\u00a0', '\u200b', '\ufeff', '\u2028\u2029']

numbers.push({
	id: `${prefix}/whitespace/0_1`,
	json_text: '12\t\r\n 34',
	expected: { error: 'SyntaxError' }
})

for (const [index, whitespace] of invalid_prefixes.entries()) {
	numbers.push({
		id: `${prefix}/whitespace/0_${index === 5 ? 8 : index + 2}`,
		json_text: whitespace + '1234',
		expected: { error: 'SyntaxError' }
	})
}

for (const code of [
	0x1680,
	0x180e,
	...Array.from({ length: 11 }, (_, index) => 0x2000 + index),
	0x202f,
	0x205f,
	0x3000
]) {
	numbers.push({
		id: `${prefix}/whitespace/invalid_${code.toString(16)}`,
		json_text: String.fromCodePoint(code) + '1',
		expected: { error: 'SyntaxError' }
	})
}

const object_controls: Array<Case> = [
	{ id: `${prefix}/object_controls/valid`, json_text: '{ "name" : "John" } ', expected: { value: { name: 'John' } } }
]

for (let group = 1; group <= 10; group++) {
	for (let code = 0; code < 32; code++) {
		const quoted = '"' + String.fromCharCode(code) + '"'
		const texts = [
			'{ ' + quoted + ' : "John" } ',
			'{ ' + quoted + 'name : "John" } ',
			'{name' + quoted + ' : "John" } ',
			'{' + quoted + 'name' + quoted + ' : "John" } ',
			'{ na' + quoted + 'me : "John" } ',
			'{ "name" : ' + quoted + ' } ',
			'{ "name" : ' + quoted + 'John } ',
			'{ "name" : John' + quoted + ' } ',
			'{ "name" : ' + quoted + 'John' + quoted + ' } ',
			'{ "name" : Jo' + quoted + 'hn } '
		]

		object_controls.push({
			id: `${prefix}/object_controls/2_${group}/${code.toString(16).padStart(2, '0')}`,
			json_text: texts[group - 1],
			expected: { error: 'SyntaxError' }
		})
	}
}

const whitespace = '\t\r \n'
const token_whitespace: Array<Case> = [
	{
		id: `${prefix}/whitespace/0_9`,
		json_text:
			whitespace +
			'{' +
			whitespace +
			'"property"' +
			whitespace +
			':' +
			whitespace +
			'{' +
			whitespace +
			'}' +
			whitespace +
			',' +
			whitespace +
			'"prop2"' +
			whitespace +
			':' +
			whitespace +
			'[' +
			whitespace +
			'true' +
			whitespace +
			',' +
			whitespace +
			'null' +
			whitespace +
			',123.456' +
			whitespace +
			']' +
			whitespace +
			'}' +
			whitespace,
		expected: { value: { property: {}, prop2: [true, null, 123.456] } }
	}
]

for (const group of [
	{ name: 'numbers', type: 'u64', rows: numbers },
	{ name: 'strings', type: 'string', rows: strings },
	{ name: 'object_controls', type: '{ name: string }', rows: object_controls },
	{ name: 'token_whitespace', type: '{ property: {}, prop2: [bool, bool?, f64] }', rows: token_whitespace }
]) {
	const base = `tests/${prefix}/${group.name}`

	writeCatalog(base + '.jsonl', group.rows)

	writeOutput(
		base + '.zx',
		`export type Input = ${group.type}

export type Output = ${group.type}

export default function (in: Input): Output {
  return in
}
`
	)
}
