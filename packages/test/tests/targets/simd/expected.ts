export default function expected(args: { values: Array<number>; type: string }): Record<string, Array<number>> {
	const { values, type } = args
	const round = type === 'f32' ? Math.fround : (value: number) => value
	const input = values.map(round)

	return {
		identity: input,
		negative: input.map(value => round(-value)),
		broadcast: input.map(() => round(1.5)),
		add: input.map(value => round(value + 1.5)),
		subtract: input.map(value => round(1.5 - value)),
		multiply: input.map(value => round(value * value)),
		divide: input.map(value => round(value / 2)),
		chain: input.map(value => round(round(value * value) + value)),
		grouped: input.map(value => round(round(value + 1.5) * round(value - 1.5))),
		cancellation: input.map(value => round(round(value + 16777216) - 16777216)),
		conditional: input.map(value => (value < 0 ? round(-value) : value))
	}
}
