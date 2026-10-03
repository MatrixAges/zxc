import type { CollectionInput } from './models/collections.ts'
import { consuming, programs, source } from './collection_programs.ts'
import evaluate from './models/collections.ts'
import { product, range, writeCatalog, writeOutput } from './shared/catalog.ts'
import { stringify } from './shared/json.ts'

const maximum = 2n ** 63n - 1n
const minimum = -(2n ** 63n)
const max_index = 2n ** 64n - 1n

function label(value: bigint | Array<bigint> | Array<Array<bigint>>): string {
	if (Array.isArray(value)) {
		if (value.length && Array.isArray(value[0])) return 'rows_' + value.map(item => label(item)).join('__')

		return value.length ? value.map(item => label(item)).join('_') : 'empty'
	}

	return value < 0n ? `n${-value}` : `p${value}`
}

function* inputs(operation: string): Generator<CollectionInput> {
	if (operation === 'concat_three') {
		for (const [items, other, last] of product([[], [0n], [1n, 2n], [-1n, 0n, 1n], [maximum]], 3))
			yield { items, other, last }
		yield { items: [], other: [0n, 1n], last: [2n, 3n, 4n] }

		return
	}

	if (['map_index', 'filter_index', 'reduce_index'].includes(operation)) {
		for (const length of range(4)) {
			for (const rows of product([[], [0n], [1n, 2n], [-1n, 0n, 1n]], length)) {
				if (operation === 'reduce_index') {
					for (const value of [-2n, 0n, 3n]) yield { items: rows, value }
				} else yield { items: rows }
			}
		}

		return
	}

	let values = range(5).flatMap(length => product([-1n, 0n, 1n], length))
	values.push([1n, 2n], [0n, 1n, 2n, 3n], [1n, 2n, 3n, 4n, 5n])

	if (['map_true', 'filter_true'].includes(operation)) values = [[], [0n], [-1n, 1n], [1n, 2n, 3n, 4n, 5n]]
	else if (operation === 'map_greater_ten') values = [[], [11n], [9n, 10n, 11n], [11n, 10n, 9n]]
	else if (['sort', 'reverse', 'pop', 'index'].includes(operation))
		values.push([minimum, 0n, maximum], [maximum, minimum])

	for (const items of values) {
		if (['push', 'reduce_sum', 'reduce_digits'].includes(operation)) {
			for (const value of [-2n, 0n, 3n]) yield { items, value }
		} else if (['concat', 'concat_reverse'].includes(operation)) {
			for (const other of [[], [0n], [1n, 2n], [-1n, 0n, 1n], [maximum]]) yield { items, other }
		} else if (['splice', 'splice_reverse'].includes(operation)) {
			if (operation === 'splice_reverse' && !['[]', '[0]', '[-1,0,1]', '[0,1,2,3]'].includes(stringify(items)))
				continue

			for (const start of range(items.length + 1)) {
				for (const count of range(items.length - start + 1)) {
					for (const other of [[], [-1n], [0n], [1n, 2n], [-1n, 0n, 1n]])
						yield { items, other, start: BigInt(start), count: BigInt(count) }
				}
			}

			const invalid = [
				[BigInt(items.length + 1), 0n],
				[max_index, 1n],
				[0n, BigInt(items.length + 1)],
				[0n, max_index],
				[BigInt(items.length), 1n]
			]
			const seen = new Set<string>()

			for (const [start, count] of invalid) {
				const key = `${start}/${count}`
				if (seen.has(key)) continue
				seen.add(key)

				yield { items, other: [], start, count }
			}
		} else if (operation === 'index') {
			for (const start of new Set([0n, BigInt(Math.max(0, items.length - 1)), BigInt(items.length), max_index]))
				yield { items, start }
		} else yield { items }
	}

	if (operation === 'splice') yield { items: [0n, 1n, 2n, 3n], other: [4n, 5n], start: 0n, count: 3n }
}

for (const operation of Object.keys(programs)) {
	const rows = []
	const seen = new Set<string>()

	for (const data of inputs(operation)) {
		const key = stringify(
			Object.fromEntries(
				Object.entries(data).sort(([left], [right]) => (left < right ? -1 : left > right ? 1 : 0))
			)
		)
		if (seen.has(key)) continue
		seen.add(key)

		const suffix = Object.entries(data)
			.map(([name, value]) => `${name}_${label(value)}`)
			.join('/')
		rows.push({ id: `built_ins/list/${operation}/i64/${suffix}`, input: data, expected: evaluate(operation, data) })
	}

	const groups = new Map<number, typeof rows>()

	for (const row of rows) {
		const length = consuming.has(operation) ? row.input.items.length : -1
		const group = groups.get(length) ?? []

		group.push(row)
		groups.set(length, group)
	}

	for (const [length, group] of groups) {
		const base = `tests/built_ins/list/${operation}/` + (length < 0 ? 'i64' : `owned/${length}/i64`)

		writeCatalog(base + '.jsonl', group)
		writeOutput(base + '.zx', source(operation, length < 0 ? undefined : length))
	}
}
