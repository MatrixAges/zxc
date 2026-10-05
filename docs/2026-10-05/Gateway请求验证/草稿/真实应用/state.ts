import type { Check, Gateway } from './types.ts'
import assert from 'node:assert/strict'

export default async function checkState(args: { gateway: Gateway; check: Check }) {
	const { gateway, check } = args
	let primary = { value: 3, history: [8], label: 'seed' }
	let secondary = { value: 100, history: [80], label: 'other' }

	async function snapshot() {
		const response = await gateway.request({ path: '/state' })

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), { primary, secondary })
	}

	await check('two Stores initialize once and reversed local slots map correctly', snapshot)

	for (const increment of [2, 5, 0]) {
		await check(`primary update ${increment} persists arrays across requests`, async () => {
			const response = await gateway.request({ method: 'POST', path: '/advance', body: String(increment) })

			primary = { ...primary, value: primary.value + increment, history: primary.history.map(item => item + 1) }

			assert.equal(response.status, 200)
			assert.deepEqual(JSON.parse(response.body.toString()), primary)
			await snapshot()
		})
	}

	await check('second physical Store updates without changing first', async () => {
		const response = await gateway.request({ method: 'POST', path: '/other', body: '7' })

		secondary = { ...secondary, value: secondary.value + 7, history: secondary.history.map(item => item + 1) }

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), secondary)
		await snapshot()
	})

	await check('later Call in same request observes first committed Store value', async () => {
		const first = { ...primary, value: primary.value + 3, history: primary.history.map(item => item + 1) }
		const second = { ...first, value: first.value + 3, history: first.history.map(item => item + 1) }
		const response = await gateway.request({ method: 'POST', path: '/twice', body: '3' })

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), { first, second })

		primary = second
		await snapshot()
	})

	await check('failed transaction does not commit pending setter', async () => {
		const response = await gateway.request({ method: 'POST', path: '/fail', body: '{"increment":99,"index":999}' })

		assert.equal(response.status, 500)
		await snapshot()
	})

	await check('later failed Call does not roll back earlier successful Call', async () => {
		const response = await gateway.request({
			method: 'POST',
			path: '/partial',
			body: '{"increment":4,"index":999}'
		})

		primary = { ...primary, value: primary.value + 4, history: primary.history.map(item => item + 1) }

		assert.equal(response.status, 500)
		await snapshot()
	})

	await check('HEAD executes configured writer but sends no response body', async () => {
		const response = await gateway.request({ method: 'HEAD', path: '/touch', body: '2' })

		primary = { ...primary, value: primary.value + 2, history: primary.history.map(item => item + 1) }

		assert.equal(response.status, 200)
		assert.equal(response.body.length, 0)
		await snapshot()
	})

	for (const input of [
		{ value: 91, history: [3, 5], label: 'request-owned 中文' },
		{ value: 12, history: [], label: 'later 🌿' }
	]) {
		await check(`owned list result and request string survive setter request ${input.value}`, async () => {
			const response = await gateway.request({ method: 'POST', path: '/replace', body: JSON.stringify(input) })

			primary = { ...input, history: [...input.history, input.history.length] }

			assert.equal(response.status, 200)
			assert.deepEqual(JSON.parse(response.body.toString()), primary)

			for (let index = 0; index < 6; index += 1) {
				const transient = await gateway.request({
					method: 'POST',
					path: '/text',
					body: JSON.stringify('x'.repeat(100))
				})

				assert.equal(transient.status, 200)
			}

			await snapshot()
		})
	}

	await check('malformed mutation request leaves both Stores unchanged', async () => {
		const response = await gateway.request({ method: 'POST', path: '/advance', body: '"invalid"' })

		assert.equal(response.status, 400)
		await snapshot()
	})

	await check('successful write still works after transaction and parse failures', async () => {
		const response = await gateway.request({ method: 'POST', path: '/advance', body: '1' })

		primary = { ...primary, value: primary.value + 1, history: primary.history.map(item => item + 1) }

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), primary)
		await snapshot()
	})
}
