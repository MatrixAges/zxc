import assert from 'node:assert/strict'
import { join } from 'node:path'
import load from './load.ts'

export default async function checkState(root: string): Promise<number> {
	const addon = load(join(root, 'state.cjs'))
	const increments = [1n, 5n, 2n, 9n, 0n, 3n]
	const expected: Array<bigint> = []
	let current = 3n

	assert.equal(addon.execute(0n), current)
	for (const increment of increments) {
		current += increment
		expected.push(current)
	}

	const pending = increments.map(increment => addon.executeAsync(increment))

	assert.throws(() => addon.execute(0n), /PendingAsyncInvocation/)
	await assert.rejects(addon.executeAsync('invalid'), Error)
	assert.deepEqual(await Promise.all(pending), expected)
	assert.equal(addon.execute(0n), current)
	assert.equal(await addon.executeAsync(1n).then(() => addon.executeAsync(2n)), current + 3n)
	assert.equal(addon.execute(0n), current + 3n)

	return increments.length + 5
}
