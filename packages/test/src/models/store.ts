export type State = { count: bigint; items: Array<bigint> }
export type Input = { action: number; increment: bigint; index: number }
export type Result =
	| { error: 'IndexOutOfBounds' | 'Conflict' }
	| { value: { before: bigint; after: bigint; other: bigint; value: bigint } }
export type Expected = {
	pending_a: State
	pending_b: State
	final_a: State
	final_b: State
	attempts: number
	commits: number
	result: Result
}
export type StoreCase = {
	id: string
	initial_a: State
	initial_b: State
	input: Input
	conflict: boolean
	expected: Expected
	allocation_failures?: boolean
}

export default function evaluate(args: {
	initial_a: State
	initial_b: State
	input: Input
	conflict: boolean
}): Expected {
	const { initial_a, initial_b, input, conflict } = args
	const pending_a = {
		count: initial_a.count + input.increment * (input.action === 1 ? 2n : 1n),
		items: input.action === 2 ? [...initial_a.items, input.increment] : initial_a.items
	}
	const pending_b = { count: initial_b.count + pending_a.count, items: initial_b.items }
	const out_of_bounds = input.index >= pending_a.items.length
	const error = out_of_bounds ? 'IndexOutOfBounds' : conflict ? 'Conflict' : null

	return {
		pending_a,
		pending_b,
		final_a: error ? initial_a : pending_a,
		final_b: error ? initial_b : pending_b,
		attempts: out_of_bounds ? 0 : 1,
		commits: error ? 0 : 1,
		result: error
			? { error }
			: {
					value: {
						before: initial_a.count,
						after: pending_a.count,
						other: pending_b.count,
						value: pending_a.items[input.index]
					}
				}
	}
}
