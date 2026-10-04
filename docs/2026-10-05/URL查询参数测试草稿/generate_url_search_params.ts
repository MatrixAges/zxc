import assert from 'node:assert/strict'
import samples from './url_search_params/samples.ts'
import parseCases from './url_search_params/parse_cases.ts'
import writeSuite from './url_search_params/write_suite.ts'

function toEntries(params: URLSearchParams): Array<{ key: string; value: string }> {
	return Array.from(params, ([key, value]) => ({ key, value }))
}

const capability = new URLSearchParams('a=1&a=2')

assert.equal(capability.has('a', 'missing'), false)
capability.delete('a', '1')
assert.equal(capability.toString(), 'a=2')
assert.equal(capability.size, 1)

writeSuite({
	operation: 'parse',
	input: 'string',
	output: 'Entry[]',
	rows: parseCases().map(row => ({
		name: row.name,
		input: row.query,
		value: toEntries(new URLSearchParams(row.query))
	}))
})

for (const operation of ['stringify', 'sort', 'keys', 'values', 'size']) {
	const rows = samples.map(sample => {
		const params = new URLSearchParams(sample.entries.map((entry): [string, string] => [entry.key, entry.value]))

		if (operation === 'sort') params.sort()

		const value =
			operation === 'sort'
				? toEntries(params)
				: operation === 'stringify'
					? params.toString()
					: operation === 'keys'
						? Array.from(params.keys())
						: operation === 'values'
							? Array.from(params.values())
							: params.size

		return { name: sample.name, input: sample.entries, value }
	})

	writeSuite({
		operation,
		input: 'Entry[]',
		output:
			operation === 'sort'
				? 'Entry[]'
				: operation === 'stringify'
					? 'string'
					: operation === 'size'
						? 'u64'
						: 'string[]',
		rows
	})
}

for (const operation of ['get', 'getAll', 'has', 'remove', 'append', 'set']) {
	const matching = operation === 'has' || operation === 'remove'
	const updating = operation === 'append' || operation === 'set'
	const rows = samples.flatMap(sample => {
		const keys = Array.from(new Set([...sample.entries.map(entry => entry.key), '', 'missing']))

		return keys.flatMap((key, key_index) => {
			const values = matching
				? Array.from(
						new Set([
							null,
							'',
							'missing',
							...sample.entries.filter(entry => entry.key === key).map(entry => entry.value)
						])
					)
				: updating
					? ['', 'new', 'a b', '=+&']
					: [null]

			return values.map((value, value_index) => {
				const params = new URLSearchParams(
					sample.entries.map((entry): [string, string] => [entry.key, entry.value])
				)

				if (operation === 'remove') value === null ? params.delete(key) : params.delete(key, value)
				if (operation === 'append') params.append(key, value!)
				if (operation === 'set') params.set(key, value!)

				const result =
					operation === 'get'
						? params.get(key)
						: operation === 'getAll'
							? params.getAll(key)
							: operation === 'has'
								? value === null
									? params.has(key)
									: params.has(key, value)
								: toEntries(params)

				return {
					name: `${sample.name}/${key_index}/${value_index}`,
					input: { entries: sample.entries, key, ...(matching || updating ? { value } : {}) },
					value: result
				}
			})
		})
	})

	writeSuite({
		operation,
		input: matching ? 'Match' : updating ? 'Update' : 'Lookup',
		output:
			operation === 'get'
				? 'string?'
				: operation === 'getAll'
					? 'string[]'
					: operation === 'has'
						? 'bool'
						: 'Entry[]',
		rows
	})
}
