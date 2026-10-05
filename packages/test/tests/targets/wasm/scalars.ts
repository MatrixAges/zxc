import assert from 'node:assert/strict'
import createHost from './host.ts'

export default function checkScalars(args: { path: string; type: string }): number {
	const { path, type } = args
	const host = createHost(path)
	const { api } = host
	let count = 0

	assert.equal(typeof api.zxc_call, 'function')

	try {
		if (type === 'void') {
			assert.equal(api.zxc_scalar_result, undefined)
			assert.equal(api.zxc_call!(), 0)
			assert.deepEqual(host.invoke(''), { status: 0, result: 'null' })
			assert.equal(host.invoke('null').status, 1)

			return 3
		}

		assert.equal(typeof api.zxc_scalar_result, 'function')

		const values: Array<number | bigint> =
			type === 'bool'
				? [0, 1, 2, -1, 255, 65535]
				: type === 'u8'
					? [...Array.from({ length: 256 }, (_, index) => index), -1, 256, 65535]
					: type === 'u16'
						? [0, 1, 255, 256, 32767, 32768, 65534, 65535, -1, 65536]
						: type === 'u32'
							? [0, 1, 0x7fffffff, 0x80000000, 0xffffffff]
							: type === 'i32'
								? [-0x80000000, -1, 0, 1, 0x7fffffff]
								: type === 'u64'
									? [0n, 1n, (1n << 53n) + 1n, (1n << 63n) - 1n, 1n << 63n, (1n << 64n) - 1n]
									: type === 'i64'
										? [-(1n << 63n), -((1n << 53n) + 1n), -1n, 0n, 1n, (1n << 63n) - 1n]
										: [
												0,
												-0,
												1,
												-1,
												0.1,
												Math.PI,
												2 ** -149,
												Number.MIN_VALUE,
												Number.MAX_VALUE,
												Infinity,
												-Infinity,
												NaN
											]

		for (const value of values) {
			const invalid =
				type === 'bool'
					? value !== 0 && value !== 1
					: type === 'u8'
						? value < 0 || value > 255
						: type === 'u16'
							? value < 0 || value > 65535
							: false
			const status = api.zxc_call!(value)

			if (invalid) {
				assert.equal(status, 1)
				assert.equal(host.readResult(), 'InvalidScalarInput')
				assert.equal(api.zxc_scalar_result!(), 0)
			} else {
				assert.equal(status, 0)

				const raw = api.zxc_scalar_result!()
				const actual =
					type === 'u32' ? Number(raw) >>> 0 : type === 'u64' ? BigInt.asUintN(64, BigInt(raw)) : raw
				const expected = type === 'f32' ? Math.fround(Number(value)) : value

				assert.ok(Object.is(actual, expected), `${type}: ${String(value)} -> ${String(actual)}`)
			}

			assert.equal(api.zxc_execute(), 1)
			assert.equal(host.readResult(), 'InputNotPrepared')
			count += 1
		}

		for (const value of type === 'bool' ? [false, true] : [0, 1, 7]) {
			const response = host.invoke(JSON.stringify(value))

			assert.equal(response.status, 0)
			assert.deepEqual(JSON.parse(response.result), value)
			assert.equal(api.zxc_scalar_result!(), type === 'u64' || type === 'i64' ? 0n : 0)
			count += 1
		}

		return count
	} finally {
		api.zxc_deinit()
	}
}
