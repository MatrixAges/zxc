import add from './add.ts'

export default function subtract(args: { left_bits: bigint; right_bits: bigint; width: number }): bigint | 'nan' {
	const { left_bits, right_bits, width } = args

	return add({ left_bits, right_bits: right_bits ^ (1n << BigInt(width - 1)), width })
}
