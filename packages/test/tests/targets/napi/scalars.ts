import type { Execute } from './load.ts'
import assert from 'node:assert/strict'

export default function checkScalars(args: { execute: Execute; type: string }): number {
	const { execute, type } = args
	let count = 0

	if (type === 'void') {
		assert.equal(execute(), undefined)
		assert.throws(() => execute(undefined), /InvalidArgumentCount/)
		assert.throws(() => execute(1, 2), /InvalidArgumentCount/)

		return 3
	}

	assert.throws(() => execute(), /InvalidArgumentCount/)
	assert.throws(() => execute(1, 2), /InvalidArgumentCount/)
	count += 2

	const bounds: Record<string, [number | bigint, number | bigint]> = {
		u8: [0, 255],
		u16: [0, 65535],
		u32: [0, 0xffffffff],
		i32: [-0x80000000, 0x7fffffff],
		u64: [0n, (1n << 64n) - 1n],
		i64: [-(1n << 63n), (1n << 63n) - 1n]
	}
	let valid: Array<unknown>
	let invalid: Array<unknown>

	if (type in bounds) {
		const [lower, upper] = bounds[type]
		const wide = typeof lower === 'bigint'

		valid = wide ? [lower, upper, 0n, 1n, (1n << 53n) + 1n] : [lower, upper, 0, 1, 42]
		if (type === 'u8') valid = Array.from({ length: 256 }, (_, index) => index)

		invalid = wide
			? [BigInt(lower) - 1n, BigInt(upper) + 1n, 0, 1.5, '1', null, undefined, true, {}, Symbol('x')]
			: [
					Number(lower) - 1,
					Number(upper) + 1,
					-0.5,
					0.5,
					NaN,
					Infinity,
					-Infinity,
					1n,
					'1',
					null,
					undefined,
					true,
					{},
					Symbol('x')
				]
	} else if (type === 'bool') {
		valid = [true, false]
		invalid = [0, 1, 'true', null, undefined, {}, [], 0n, Symbol('x')]
	} else if (type === 'string') {
		valid = ['', 'ASCII', '中🙂', 'a\0b', '\ud800', '\udfff', '中'.repeat(65536)]
		invalid = [0, true, null, undefined, {}, [], 0n, Symbol('x')]
	} else {
		valid = [0, -0, 1, -1, 0.1, Math.PI, 2 ** -149, Number.MIN_VALUE, Number.MAX_VALUE, Infinity, -Infinity, NaN]
		invalid = [1n, '1', null, undefined, true, {}, [], Symbol('x')]
	}

	for (const value of valid) {
		const expected =
			type === 'f32' ? Math.fround(Number(value)) : type === 'string' ? String(value).toWellFormed() : value

		assert.ok(Object.is(execute(value), expected), `${type}: ${String(value)}`)
		count += 1
	}

	for (const value of invalid) {
		assert.throws(() => execute(value), Error, `${type}: ${String(value)}`)
		assert.doesNotThrow(() => execute(valid[0]))
		count += 1
	}

	return count
}
