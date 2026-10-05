import assert from 'node:assert/strict'
import { join } from 'node:path'
import createInput from './input.ts'
import load from './load.ts'

export default async function checkOwnership(root: string): Promise<number> {
	const addon = load(join(root, 'addon.cjs'))
	let count = 0

	for (const bytes of [
		Buffer.from([1, 2, 3]),
		new Uint8Array([9, 1, 2, 3, 9]).subarray(1, 4),
		new Uint8ClampedArray([1, 2, 3]),
		[1, 2, 3]
	]) {
		const input = { ...createInput(), bytes }
		const expected = { ...structuredClone(input), bytes: Buffer.from(input.bytes) }
		const pending = addon.executeAsync(input)

		bytes.fill(0)
		input.name = 'changed'
		input.pair[0] = false
		input.values.push(77n)
		input.nested[0].value = 'changed'
		globalThis.gc!()
		assert.deepEqual(await pending, expected)
		count += 1
	}

	const bytes = new Uint8Array([3, 4, 5])
	const input = { ...createInput(), bytes }
	const expected = { ...structuredClone(input), bytes: Buffer.from(input.bytes) }
	const pending = addon.executeAsync(input)

	structuredClone(bytes.buffer, { transfer: [bytes.buffer] })
	assert.equal(bytes.byteLength, 0)
	assert.deepEqual(await pending, expected)
	count += 1

	const inputs = Array.from({ length: 32 }, (_, index) => ({ ...createInput(), count: BigInt(index) }))
	const expected_outputs = inputs.map(input => ({ ...structuredClone(input), bytes: Buffer.from(input.bytes) }))
	const ordinary_input = createInput()
	const ordinary = { ...ordinary_input, bytes: Buffer.from(ordinary_input.bytes) }
	const detached_input = (() => {
		const input = createInput()

		return addon.executeAsync(input)
	})()

	globalThis.gc!()
	assert.deepEqual(await detached_input, ordinary)
	count += 1

	const pending_outputs = inputs.map(input => addon.executeAsync(input))

	assert.deepEqual(addon.execute(createInput()), ordinary)
	const outputs = await Promise.all(pending_outputs)

	assert.deepEqual(outputs, expected_outputs)
	globalThis.gc!()
	await addon.executeAsync(createInput())
	assert.deepEqual(outputs, expected_outputs)
	count += inputs.length + 2

	const first = outputs[0] as ReturnType<typeof createInput> & { bytes: Buffer }

	first.bytes.fill(0)
	first.values.push(999n)
	first.nested[0].value = 'changed output'
	assert.deepEqual(outputs.slice(1), expected_outputs.slice(1))
	assert.deepEqual(inputs[0], { ...createInput(), count: 0n })
	count += 2

	return count
}
