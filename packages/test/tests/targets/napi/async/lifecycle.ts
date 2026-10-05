import assert from 'node:assert/strict'
import { join } from 'node:path'
import { Worker } from 'node:worker_threads'
import createInput from './input.ts'
import load from './load.ts'

export default async function checkLifecycle(root: string): Promise<number> {
	const state = load(join(root, 'state.cjs'))
	const ordinary = load(join(root, 'addon.cjs'))
	const retained = state.execute(0n)
	let count = 0

	for (const stateful of [false, true]) {
		for (const terminate of [false, true]) {
			for (let iteration = 0; iteration < 3; iteration += 1) {
				const worker = new Worker(new URL('./worker.ts', import.meta.url), {
					workerData: { root, stateful, terminate }
				})
				const result = await new Promise<unknown>((resolve, reject) => {
					let response: unknown
					const timer = setTimeout(() => {
						worker.terminate()
						reject(new Error('Async Worker did not exit within 30 seconds'))
					}, 30_000)

					worker.on('message', value => {
						response = value
						if (terminate) worker.terminate().catch(reject)
					})
					worker.on('error', reject)
					worker.on('exit', code => {
						clearTimeout(timer)
						if (code === (terminate ? 1 : 0)) resolve(response)
						else reject(new Error(`Async Worker exited with ${code}`))
					})
				})

				if (terminate) assert.deepEqual(result, { queued: 16 })
				else if (stateful)
					assert.deepEqual(
						result,
						Array.from({ length: 16 }, (_, index) => BigInt(index + 4))
					)
				else
					assert.deepEqual(
						result,
						Array.from({ length: 16 }, (_, index) => ({
							...createInput(),
							bytes: new Uint8Array([0, 127, 255]),
							count: BigInt(index)
						}))
					)

				assert.equal(state.execute(0n), retained)
				assert.deepEqual(await ordinary.executeAsync(createInput()), ordinary.execute(createInput()))
				count += 1
			}
		}
	}

	return count
}
