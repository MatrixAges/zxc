import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Value = { name: string; value: boolean | number | string }
type Row = { id: string; input: Json; expected: { value?: Json; error?: string } }
const types: Array<{ name: string; type: string; values: Array<Value> }> = [
	{ name: 'number', type: 'f64', values: [{ name: 'zero', value: 0 }, { name: 'forty_two', value: 42 }] },
	{ name: 'boolean', type: 'bool', values: [{ name: 'false', value: false }, { name: 'true', value: true }] },
	{ name: 'string', type: 'string', values: [{ name: 'empty', value: '' }, { name: 'undefined_text', value: 'undefined' }] },
]
const frontend: Array<{ id: string; source: string; phase: string; diagnostic: string }> = []

function program(args: { input: string; output: string; expression: string }): string {
	const { input, output, expression } = args

	return `export type Input = ${input};\n\nexport type Output = ${output};\n\nexport default function (in: Input): Output {\n  return ${expression};\n}\n`
}

for (const spec of types) {
	const values = [{ name: 'null', value: null }, ...spec.values]
	const prefix = `language/expressions/coalesce/values/${spec.name}`
	const layouts = [
		{ name: 'direct', input: `{ left: ${spec.type}?; fallback: ${spec.type}; }`, expression: 'in.left ?? in.fallback' },
		{ name: 'nested', input: `{ left: ${spec.type}?; right: ${spec.type}?; fallback: ${spec.type}; }`, expression: 'in.left ?? (in.right ?? in.fallback)' },
		{ name: 'index', input: `{ left: ${spec.type}?; items: ${spec.type}[]; index: u64; }`, expression: 'in.left ?? in.items[in.index]' },
	]
	const direct: Array<Row> = []
	const nested: Array<Row> = []
	const indexed: Array<Row> = []

	for (const left of values) {
		for (const fallback of spec.values) {
			direct.push({ id: `${prefix}/direct/${left.name}/${fallback.name}`, input: { left: left.value, fallback: fallback.value }, expected: { value: left.value === null ? fallback.value : left.value } })

			for (const right of values) {
				const result = left.value !== null ? left.value : right.value !== null ? right.value : fallback.value

				nested.push({ id: `${prefix}/nested/${left.name}/${right.name}/${fallback.name}`, input: { left: left.value, right: right.value, fallback: fallback.value }, expected: { value: result } })
			}
		}

		for (const present of [false, true]) {
			for (const index of [0, 1]) {
				const items = present ? [spec.values[1].value] : []
				const expected = left.value !== null ? { value: left.value } : present && index === 0 ? { value: items[0] } : { error: 'IndexOutOfBounds' }

				indexed.push({ id: `${prefix}/index/${left.name}/${present ? 'present' : 'empty'}/${index}`, input: { left: left.value, items, index }, expected })
			}
		}
	}

	for (const [index, layout] of layouts.entries()) {
		const base = `tests/${prefix}/${layout.name}`

		writeOutput(base + '.zx', program({ input: layout.input, output: spec.type, expression: layout.expression }))
		writeCatalog(base + '.jsonl', [direct, nested, indexed][index])
	}

	for (const [name, expression] of Object.entries({ nonoptional_head: 'in.fallback ?? in.fallback', optional_fallback: 'in.left ?? in.right', null_fallback: 'in.left ?? null', unparenthesized_chain: 'in.left ?? in.right ?? in.fallback' })) {
		if (spec.name === 'boolean' && name !== 'null_fallback') continue

		frontend.push({ id: `language/types/coalesce_values/${spec.name}/${name}`, source: program({ input: layouts[1].input, output: spec.type, expression }), phase: 'analyze', diagnostic: 'type_mismatch' })
	}
}

writeCatalog('tests/language/types/coalesce_values/cases.jsonl', frontend)
