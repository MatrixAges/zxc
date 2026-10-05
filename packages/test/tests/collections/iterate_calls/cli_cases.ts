type Input = { count: number; start: number; values: Array<number> }

export const inputs: Array<Input> = [
	{ count: 0, start: -5, values: [-4, 2, 0] },
	{ count: 1, start: -5, values: [-4, 2, 0] },
	{ count: 2, start: -5, values: [-4, 2, 0] },
	{ count: 17, start: -5, values: [-4, 2, 0] },
	{ count: 3, start: -100000, values: [7, 7, -3] }
]

export function expectedResult(input: Input, mode: string) {
	let total = input.start
	let previous = input.start
	let other = mode === 'branch_return' ? input.start + 100 : 0

	for (let index = 0; index < input.count; index++) {
		if (mode === 'branch_return') {
			previous = index % 2 === 0 ? total : other
			total += 1
			other += 2
		} else {
			previous = total
			total += mode === 'list_alias' ? input.values[0] + index : 1
		}
	}

	return {
		initial: input.start,
		total,
		previous,
		steps: input.count,
		other,
		values: input.values.map((value, index) => value + (mode === 'list_alias' && index === 0 ? input.count : 0))
	}
}
