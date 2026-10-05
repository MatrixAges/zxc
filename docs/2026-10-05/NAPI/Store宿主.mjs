import { createRequire } from 'node:module'
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads'

const require = createRequire(import.meta.url)
const path = isMainThread ? process.argv[2] : workerData
const addon = require(path)
const first = addon.execute(5n)
const second = addon.execute(2n)

if (isMainThread) {
	const worker_result = await new Promise((resolve, reject) => {
		const worker = new Worker(new URL(import.meta.url), { workerData: path })

		worker.once('message', resolve)
		worker.once('error', reject)
		worker.once('exit', code => {
			if (code !== 0) reject(new Error(`Worker exited ${code}`))
		})
	})

	console.log(
		JSON.stringify(
			{ first, second, worker: worker_result },
			(_, value) => (typeof value === 'bigint' ? `${value}n` : value),
			2
		)
	)
} else {
	parentPort.postMessage({ first, second })
}
