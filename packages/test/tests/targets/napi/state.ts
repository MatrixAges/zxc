import assert from 'node:assert/strict'
import { Worker } from 'node:worker_threads'
import load from './load.ts'

export default async function checkState(path: string): Promise<number> {
	const execute = load(path)

	assert.equal(execute(0n), 3n)
	assert.equal(execute(2n), 5n)
	assert.throws(() => execute('invalid'), Error)
	assert.equal(execute(0n), 5n)
	assert.equal(execute(7n), 12n)

	for (let index = 0; index < 3; index += 1) {
		const worker = new Worker(new URL('./worker.ts', import.meta.url), { workerData: path })
		const output = await new Promise<unknown>((resolve, reject) => {
			let response: unknown
			const timer = setTimeout(() => {
				worker.terminate()
				reject(new Error('Worker did not finish within 30 seconds'))
			}, 30_000)

			worker.on('message', value => {
				response = value
			})
			worker.on('error', reject)
			worker.on('exit', code => {
				clearTimeout(timer)
				if (code === 0) resolve(response)
				else reject(new Error(`Worker exit ${code}`))
			})
		})

		assert.deepEqual(output, [3n, 5n, 5n])
		assert.equal(execute(0n), 12n)
	}

	for (let index = 0; index < 10; index += 1) {
		globalThis.gc!()
		assert.equal(execute(1n), BigInt(13 + index))
	}

	return 18
}
