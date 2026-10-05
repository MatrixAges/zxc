import type { Execute } from './load.ts'
import assert from 'node:assert/strict'

export default function checkCollections(args: { optional: Execute; tuple: Execute }): number {
	const { optional, tuple } = args
	let count = 0

	for (const value of [null, undefined, '', '中\0']) {
		assert.equal(optional(value), value ?? null)
		count += 1
	}

	for (const value of [0, 1n, false, [], {}]) {
		assert.throws(() => optional(value), Error)
		count += 1
	}

	for (const value of [
		[true, 1],
		[false, -0],
		[true, NaN],
		[false, Infinity]
	]) {
		assert.deepEqual(tuple(value), value)
		count += 1
	}

	for (const value of [[], [true], [true, 1, 2], [0, 1], [true, 1n], { 0: true, 1: 1, length: 2 }, null]) {
		assert.throws(() => tuple(value), Error)
		count += 1
	}

	return count
}
