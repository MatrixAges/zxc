export const lengths = [...Array.from({ length: 34 }, (_, index) => index), 63, 64, 65, 127, 128, 129, 257, 1025]

export default function values(args: { size: number; special: boolean }): Array<number> {
	const { size, special } = args
	const samples = special
		? [
				0,
				-0,
				1,
				-1,
				0.1,
				-0.1,
				2 ** -149,
				2 ** -126,
				Number.MIN_VALUE,
				Number.MAX_VALUE,
				16777216,
				-16777216,
				3.4028234e38,
				Infinity,
				-Infinity,
				NaN
			]
		: [0, 1, -1, 0.1, -0.1, 1.5, -1.5, 2 ** -20, 16777216, -16777216, 123.25]

	return Array.from({ length: size }, (_, index) => samples[index % samples.length])
}
