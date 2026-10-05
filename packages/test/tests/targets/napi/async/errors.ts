import assert from 'node:assert/strict'
import { join } from 'node:path'
import load from './load.ts'

export default async function checkErrors(root: string): Promise<number> {
	const plain = load(join(root, 'select.cjs'))
	let count = 0

	for (const input of [
		{ values: [], index: 0n },
		{ values: [2n, 7n], index: 2n }
	]) {
		await assert.rejects(plain.executeAsync(input), /IndexOutOfBounds/)
		assert.equal(await plain.executeAsync({ values: [2n, 7n], index: 1n }), 7n)
		count += 2
	}

	const state = load(join(root, 'selected_state.cjs'))
	const first = state.executeAsync({ values: [5n], index: 0n })
	const failed = state.executeAsync({ values: [], index: 0n })
	const last = state.executeAsync({ values: [7n], index: 0n })
	const outcomes = await Promise.allSettled([first, failed, last])

	assert.deepEqual(outcomes[0], { status: 'fulfilled', value: 8n })
	assert.equal(outcomes[1].status, 'rejected')
	assert.ok(outcomes[1].reason instanceof Error)
	assert.match(outcomes[1].reason.message, /IndexOutOfBounds/)
	assert.deepEqual(outcomes[2], { status: 'fulfilled', value: 15n })
	assert.equal(state.execute({ values: [0n], index: 0n }), 15n)
	count += 4

	return count
}
