import type { Json } from '../shared/json.ts'

export type CollectionInput = {
	items: Array<bigint> | Array<Array<bigint>>
	other?: Array<bigint>
	last?: Array<bigint>
	value?: bigint
	start?: bigint
	count?: bigint
}

export default function evaluate(operation: string, args: CollectionInput): { error: string } | { value: Json } {
	const items = args.items as Array<bigint>
	let value: Json

	switch (operation) {
		case 'push':
			value = [...items, args.value!]
			break
		case 'pop':
			value = { items: items.slice(0, -1), value: items.at(-1) ?? null }
			break
		case 'reverse':
			value = items.toReversed()
			break
		case 'sort':
			value = items.toSorted((left, right) => (left < right ? -1 : left > right ? 1 : 0))
			break
		case 'concat':
		case 'concat_reverse': {
			value = [...items, ...args.other!]
			if (operation === 'concat_reverse') value.reverse()
			break
		}

		case 'concat_three':
			value = [...items, ...args.other!, ...args.last!]
			break
		case 'splice':
		case 'splice_reverse': {
			const start = args.start!
			const count = args.count!
			if (start > BigInt(items.length) || count > BigInt(items.length) - start)
				return { error: 'IndexOutOfBounds' }

			const next = [...items.slice(0, Number(start)), ...args.other!, ...items.slice(Number(start + count))]
			const removed = items.slice(Number(start), Number(start + count))
			value =
				operation === 'splice_reverse'
					? { items: next.toReversed(), removed: removed.toReversed() }
					: { items: next, removed }
			break
		}

		case 'map_double':
			value = items.map(item => item * 2n)
			break
		case 'map_plus_ten':
			value = items.map(item => item + 10n)
			break
		case 'map_greater_ten':
			value = items.map(item => item > 10n)
			break
		case 'map_true':
			value = items.map(() => true)
			break
		case 'filter_odd':
			value = items.filter(item => item % 2n !== 0n)
			break
		case 'filter_true':
			value = items.slice()
			break
		case 'reduce_sum':
			value = args.value! + items.reduce((sum, item) => sum + item, 0n)
			break
		case 'reduce_digits':
			value =
				args.value! * 10n ** BigInt(items.length) +
				items.reduce((sum, item, index) => sum + item * 10n ** BigInt(items.length - index - 1), 0n)
			break
		case 'index': {
			if (args.start! >= BigInt(items.length)) return { error: 'IndexOutOfBounds' }
			value = items[Number(args.start)]
			break
		}

		case 'map_index':
		case 'filter_index':
		case 'reduce_index': {
			const rows = args.items as Array<Array<bigint>>
			if (rows.some(row => !row.length)) return { error: 'IndexOutOfBounds' }

			value =
				operation === 'map_index'
					? rows.map(row => row[0])
					: operation === 'filter_index'
						? rows.filter(row => row[0] > 0n)
						: args.value! + rows.reduce((sum, row) => sum + row[0], 0n)
			break
		}

		default:
			throw new Error(`unknown collection operation: ${operation}`)
	}

	return { value }
}
