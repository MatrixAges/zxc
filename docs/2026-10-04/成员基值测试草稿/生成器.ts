import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }
type Case = { name: string; input: string; expression: string; token?: string; diagnostic?: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/member_base.jsonl'))
const cases: Array<Case> = [
	{ name: 'null_index', input: 'u64', expression: 'null[in]', token: 'null' },
	{ name: 'null_field', input: 'u64', expression: 'null.value', token: 'null' },
	{ name: 'undefined_index', input: 'u64', expression: 'undefined[in]', token: 'undefined', diagnostic: 'name' },
	{ name: 'optional_object_index', input: '{ value: i64 }?', expression: 'in["value"]', token: 'in["value"]' },
	{ name: 'optional_object_field', input: '{ value: i64 }?', expression: 'in.value', token: 'value' },
	{ name: 'optional_list_index', input: 'i64[]?', expression: 'in[0]', token: 'in[0]' },
	{ name: 'object_string_key', input: '{ value: i64 }', expression: 'in["value"]', token: 'in["value"]' },
	{ name: 'scalar_index', input: 'i64', expression: 'in[0]', token: 'in[0]' },
	{ name: 'list_string_key', input: 'i64[]', expression: 'in["0"]', token: '"0"' },
	{ name: 'list_object_key', input: '{ items: i64[], key: { value: u64 } }', expression: 'in.items[in.key]', token: 'in.key' },
	{ name: 'object_field', input: '{ value: i64 }', expression: 'in.value' },
	{ name: 'list_index', input: '{ items: i64[], key: u64 }', expression: 'in.items[in.key]' },
	{ name: 'coalesced_object_field', input: '{ value: i64 }?', expression: '(in ?? { value: 3 }).value' },
	{ name: 'coalesced_list_index', input: 'i64[]?', expression: '(in ?? [3])[0]' },
]

writeCatalog('tests/language/types/member_base/cases.jsonl', cases.map(item => {
	const source = `export type Input = ${item.input}

export type Output = i64

export default function (in: Input): Output {
  return ${item.expression}
}
`
	const start = item.token ? source.indexOf(item.token, source.indexOf('  return')) : 0

	return {
		id: `language/types/member_base/${item.name}`, source, phase: 'analyze',
		diagnostic: item.token ? item.diagnostic ?? 'type_mismatch' : null,
		...(item.token ? { span: [start, start + item.token.length] } : {}),
	}
}))

writeCatalog('upstream/reviews/language/expressions/member_base.jsonl', samples.map(sample => ({
	...sample, status: 'excluded', contract: 'packages/compiler/src/zx/analysis/expressions.zig', cases: [],
})))
