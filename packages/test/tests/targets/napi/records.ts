import type { Execute } from './load.ts'
import assert from 'node:assert/strict'

function sample() {
	return {
		name: '中\0🙂',
		bytes: Buffer.from([0, 128, 255]),
		count: -((1n << 53n) + 1n),
		pair: [true, 0.5],
		mode: 'Read',
		note: null,
		values: [0n, (1n << 64n) - 1n],
		nested: [{ value: 'owned' }]
	}
}

export default function checkRecords(execute: Execute): number {
	let count = 0

	for (const mode of ['Read', 'Write']) {
		for (const note of [null, undefined, '', 'text']) {
			const input = { ...sample(), mode, note, extra: 1 }
			const expected = { ...sample(), mode, note: note ?? null }
			const output = execute(input)

			assert.deepEqual(output, expected)
			input.nested[0].value = 'changed'
			input.bytes.fill(17)
			input.values.fill(7n)
			assert.deepEqual(output, expected)
			count += 1
		}
	}

	const inherited = Object.create(sample()) as object

	assert.deepEqual(execute(inherited), sample())
	assert.deepEqual(execute({ ...sample(), note: undefined }), sample())
	count += 2

	for (const patch of [
		{ name: 1 },
		{ bytes: new Uint16Array(1) },
		{ count: 1 },
		{ pair: [true] },
		{ pair: [true, 1, 2] },
		{ pair: [1, 2] },
		{ mode: 'Missing' },
		{ values: [1] },
		{ nested: [{ value: null }] }
	]) {
		assert.throws(() => execute({ ...sample(), ...patch }), Error)
		assert.deepEqual(execute(sample()), sample())
		count += 1
	}

	for (const field of ['name', 'bytes', 'count', 'pair', 'mode', 'values', 'nested']) {
		const input: Record<string, unknown> = sample()

		delete input[field]
		assert.throws(() => execute(input), Error)
		count += 1
	}

	for (const thrown of [new Error('getter failure'), { marker: 'original' }, null, 17]) {
		const input = sample()

		Object.defineProperty(input, 'name', {
			get() {
				throw thrown
			}
		})
		assert.throws(
			() => execute(input),
			error => error === thrown
		)
		assert.deepEqual(execute(sample()), sample())
		count += 1
	}

	const input = sample()

	Object.defineProperty(input, 'name', {
		get() {
			execute(sample())
			return 'unreachable'
		}
	})
	assert.throws(() => execute(input), /ReentrantInvocation/)
	assert.deepEqual(execute(sample()), sample())
	count += 1

	return count
}
