import assert from 'node:assert/strict'
import { parse } from 'node:querystring'

type Entry = { key: string; value: string }
type Case = {
	name: string
	query: string
	entries: Array<Entry>
	separator?: string
	assignment?: string
	max_keys?: number
}

const entries = (pairs: Array<[string, string]>) => pairs.map(([key, value]) => ({ key, value }))
const cases: Array<Case> = [
	{ name: 'empty', query: '', entries: [] },
	{ name: 'only_separators', query: '&&&', entries: [] },
	{ name: 'empty_key_value', query: '=', entries: entries([['', '']]) },
	{
		name: 'repeated_empty_key_value',
		query: '&=&=',
		entries: entries([
			['', ''],
			['', '']
		])
	},
	{ name: 'bare_key', query: 'name', entries: entries([['name', '']]) },
	{ name: 'empty_value', query: 'name=', entries: entries([['name', '']]) },
	{ name: 'empty_key', query: '=value', entries: entries([['', 'value']]) },
	{ name: 'first_assignment', query: 'a=b=c', entries: entries([['a', 'b=c']]) },
	{
		name: 'interleaved_duplicates',
		query: 'a=1&b=2&a=3',
		entries: entries([
			['a', '1'],
			['b', '2'],
			['a', '3']
		])
	},
	{
		name: 'numeric_key_order',
		query: '10=a&2=b&0=c',
		entries: entries([
			['10', 'a'],
			['2', 'b'],
			['0', 'c']
		])
	},
	{
		name: 'prototype_names',
		query: '__proto__=a&constructor=b&toString=c',
		entries: entries([
			['__proto__', 'a'],
			['constructor', 'b'],
			['toString', 'c']
		])
	},
	{
		name: 'skip_empty_parts',
		query: '&a=1&&b=2&',
		entries: entries([
			['a', '1'],
			['b', '2']
		])
	},
	{ name: 'plus_to_space', query: 'a+b=c+d', entries: entries([['a b', 'c d']]) },
	{ name: 'encoded_plus_literal', query: 'a%2Bb=%2B+', entries: entries([['a+b', '+ ']]) },
	{ name: 'encoded_delimiters', query: 'a%26b=c%3Dd', entries: entries([['a&b', 'c=d']]) },
	{ name: 'unicode', query: '%E4%B8%AD=%F0%9F%8C%B1', entries: entries([['中', '🌱']]) },
	{ name: 'invalid_utf8', query: '%FF=%E2%82', entries: entries([['�', '�']]) },
	{
		name: 'invalid_percent',
		query: '%G1=%1&%=%%',
		entries: entries([
			['%G1', '%1'],
			['%', '%%']
		])
	},
	{ name: 'nul', query: '%00=a%00b', entries: entries([['\0', 'a\0b']]) },
	{ name: 'no_url_prefix_stripping', query: '?a=1#tail', entries: entries([['?a', '1#tail']]) },
	{
		name: 'custom_delimiters',
		query: 'a:1;b:2',
		separator: ';',
		assignment: ':',
		entries: entries([
			['a', '1'],
			['b', '2']
		])
	},
	{
		name: 'multibyte_delimiters',
		query: 'a=>1||b=>2=>3',
		separator: '||',
		assignment: '=>',
		entries: entries([
			['a', '1'],
			['b', '2=>3']
		])
	},
	{
		name: 'unicode_delimiters',
		query: 'a值1分b值2',
		separator: '分',
		assignment: '值',
		entries: entries([
			['a', '1'],
			['b', '2']
		])
	},
	{
		name: 'empty_delimiters_use_defaults',
		query: 'a=1&b=2',
		separator: '',
		assignment: '',
		entries: entries([
			['a', '1'],
			['b', '2']
		])
	},
	{
		name: 'separator_equals_assignment',
		query: 'a=b=c',
		separator: '=',
		assignment: '=',
		entries: entries([
			['a', ''],
			['b', ''],
			['c', '']
		])
	},
	{ name: 'limit_counts_empty_parts', query: '&&a=1', max_keys: 2, entries: [] },
	{
		name: 'limit_counts_duplicates',
		query: 'a=1&a=2&b=3',
		max_keys: 2,
		entries: entries([
			['a', '1'],
			['a', '2']
		])
	},
	{ name: 'limit_one', query: 'a=1&b=2', max_keys: 1, entries: entries([['a', '1']]) },
	{
		name: 'unlimited',
		query: 'a=1&a=2&b=3',
		max_keys: 0,
		entries: entries([
			['a', '1'],
			['a', '2'],
			['b', '3']
		])
	}
]

for (const length of [999, 1000, 1001]) {
	const pairs = Array.from({ length }, (_, index) => ({ key: `k${index}`, value: `${index}` }))
	const query = pairs.map(entry => `${entry.key}=${entry.value}`).join('&')

	cases.push({ name: `default_limit_${length}`, query, entries: pairs.slice(0, 1000) })
	cases.push({ name: `unlimited_${length}`, query, max_keys: 0, entries: pairs })
}

export default function parseCases(): Array<Case> {
	for (const item of cases) {
		const grouped: Record<string, string | Array<string>> = Object.create(null)

		for (const entry of item.entries) {
			const previous = grouped[entry.key]

			grouped[entry.key] =
				previous === undefined
					? entry.value
					: [...(Array.isArray(previous) ? previous : [previous]), entry.value]
		}

		assert.deepEqual(
			grouped,
			parse(item.query, item.separator || '&', item.assignment || '=', { maxKeys: item.max_keys ?? 1000 }),
			item.name
		)
	}

	return cases
}
