import assert from 'node:assert/strict'
import { join } from 'node:path'
import createInput from './input.ts'
import load from './load.ts'

export default async function checkProtocol(root: string): Promise<number> {
	const addon = load(join(root, 'addon.cjs'))
	let count = 0

	for (const values of [[], [createInput(), createInput()], [null], [{ ...createInput(), count: 1 }]]) {
		let pending: Promise<unknown> | undefined

		assert.doesNotThrow(() => {
			pending = addon.executeAsync(...values)
		})
		assert.ok(pending instanceof Promise)
		await assert.rejects(pending, Error)
		count += 1
	}

	for (const reason of [new Error('getter failure'), { marker: 'original' }, null, 17]) {
		const input = createInput()

		Object.defineProperty(input, 'name', {
			get() {
				throw reason
			}
		})
		await assert.rejects(addon.executeAsync(input), (error: unknown) => error === reason)
		count += 1
	}

	const input = createInput()

	Object.defineProperty(input, 'name', {
		get() {
			return addon.execute(createInput())
		}
	})
	await assert.rejects(addon.executeAsync(input), /ReentrantInvocation/)
	count += 1

	let reentrant: Promise<unknown> | undefined
	const nested = createInput()

	Object.defineProperty(nested, 'name', {
		get() {
			reentrant = addon.executeAsync(createInput())
			reentrant.catch(() => {})
			return 'outer'
		}
	})
	await addon.executeAsync(nested)
	assert.ok(reentrant)
	await assert.rejects(reentrant, /ReentrantInvocation/)
	count += 1

	let settled = false
	const pending = addon.executeAsync(createInput()).then(value => {
		settled = true
		return value
	})

	assert.equal(settled, false)
	assert.deepEqual(await pending, addon.execute(createInput()))
	assert.deepEqual(
		await addon.executeAsync(createInput()).then(() => addon.executeAsync(createInput())),
		addon.execute(createInput())
	)
	count += 2

	for (const [name, args, expected] of [
		['void', [], undefined],
		['no_input', [], 9n],
		['no_output', [1n], undefined]
	] as const) {
		const module = load(join(root, `${name}.cjs`))

		assert.equal(await module.executeAsync(...args), expected)
		await assert.rejects(module.executeAsync(...args, undefined), /InvalidArgumentCount/)
		count += 2
	}

	return count
}
