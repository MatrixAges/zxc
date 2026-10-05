import type { Execute } from './load.ts'
import assert from 'node:assert/strict'

export default function checkBytes(execute: Execute): number {
	let count = 0

	for (const size of [0, 1, 255, 256, 4096, 65536]) {
		const data = Array.from({ length: size }, (_, index) => index % 256)
		const expected = Buffer.from(data)
		const storage = Uint8Array.from([91, ...data, 92])

		for (const input of [
			data,
			Buffer.from(data),
			Uint8Array.from(data),
			Uint8ClampedArray.from(data),
			storage.subarray(1, size + 1)
		]) {
			const output = execute(input)

			assert.ok(Buffer.isBuffer(output))
			assert.deepEqual(output, expected)
			input.fill(17)
			assert.deepEqual(output, expected)
			output.fill(23)
			assert.ok(input.every(value => value === 17))
			count += 1
		}
	}

	for (const input of [
		new Uint16Array(2),
		new Int8Array(2),
		new Float32Array(2),
		new BigUint64Array(2),
		new ArrayBuffer(2),
		new DataView(new ArrayBuffer(2)),
		'x',
		{},
		null,
		[256],
		[-1],
		[0.5],
		[NaN],
		[1n],
		new Array(2)
	]) {
		assert.throws(() => execute(input), Error)
		assert.deepEqual(execute([1, 2]), Buffer.from([1, 2]))
		count += 1
	}

	return count
}
