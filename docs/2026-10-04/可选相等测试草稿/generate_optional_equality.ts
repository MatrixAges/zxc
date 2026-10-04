import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const scalars: Array<[string, Array<Json>]> = [
	['u8', [null, 0, 1, 255]], ['u16', [null, 0, 1, 65535]],
	['u32', [null, 0, 1, 4294967295]], ['u64', [null, 0n, 1n, 18446744073709551615n]],
	['i32', [null, -2147483648, 0, 2147483647]], ['i64', [null, -9223372036854775808n, 0n, 9223372036854775807n]],
	['f32', [null, -1.5, 0, 1.5]], ['f64', [null, -1.5, 0, 1.5]],
	['bool', [null, false, true]], ['string', [null, '', 'same', 'other', '中文']],
]

for (const [scalar, values] of scalars) {
	const rows = values.flatMap((left, left_index) => values.map((right, right_index) => ({
		id: `language/expressions/comparison/optional/${scalar}/${left_index}/${right_index}`,
		input: { left, right },
		expected: { value: { equal: left === right, different: left !== right, left_none: left === null, right_none: right === null, none_left: left === null, none_right: right === null } },
	})))
	const base = `tests/language/expressions/comparison/optional/${scalar}`

	writeCatalog(base + '.jsonl', rows)
	writeOutput(base + '.zx', `export type Input = { left: ${scalar}?; right: ${scalar}?; };\n\nexport type Output = { equal: bool; different: bool; left_none: bool; right_none: bool; none_left: bool; none_right: bool; };\n\nexport default function (in: Input): Output {\n  return { equal: in.left == in.right, different: in.left != in.right, left_none: in.left == null, right_none: in.right == null, none_left: null == in.left, none_right: null == in.right };\n}\n`)
}

const aggregates: Array<[string, string, Array<Json>]> = [
	['object', '{ value: u64; }', [null, { value: 0 }, { value: 1 }]],
	['list', 'u64[]', [null, [], [0], [1, 2]]],
	['tuple', '[u64, string]', [null, [0, ''], [1, 'x']]],
]
const frontend = []

for (const [name, type, values] of aggregates) {
	const base = `tests/language/expressions/comparison/optional/${name}`

	writeCatalog(base + '.jsonl', values.map((input, index) => ({
		id: `language/expressions/comparison/optional/${name}/${index}`,
		input,
		expected: { value: { equal: input === null, different: input !== null, reverse_equal: input === null, reverse_different: input !== null } },
	})))
	writeOutput(base + '.zx', `export type Value = ${type};\n\nexport type Input = Value?;\n\nexport type Output = { equal: bool; different: bool; reverse_equal: bool; reverse_different: bool; };\n\nexport default function (in: Input): Output {\n  return { equal: in == null, different: in != null, reverse_equal: null == in, reverse_different: null != in };\n}\n`)

	for (const [operation, operator] of [['equal', '=='], ['not_equal', '!=']]) {
		for (const shape of ['same', 'pair']) {
			const right = shape === 'same' ? 'in.left' : 'in.right'

			frontend.push({
				id: `language/types/optional_equality/${name}/${operation}/${shape}`,
				source: `export type Value = ${type};\n\nexport type Input = { left: Value?; right: Value?; };\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return in.left ${operator} ${right};\n}\n`,
				phase: 'analyze',
				diagnostic: 'type_mismatch',
			})
		}
	}
}

writeCatalog('tests/language/types/optional_equality/cases.jsonl', frontend)
