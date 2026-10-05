import { join } from 'node:path'
import { parentPort, workerData } from 'node:worker_threads'
import createInput from './input.ts'
import load from './load.ts'

const { root, stateful, terminate } = workerData as { root: string; stateful: boolean; terminate: boolean }
const addon = load(join(root, stateful ? 'state.cjs' : 'addon.cjs'))
const pending = Array.from({ length: 16 }, (_, index) =>
	addon.executeAsync(stateful ? 1n : { ...createInput(), count: BigInt(index) })
)

if (terminate) {
	parentPort!.postMessage({ queued: pending.length })
	Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0)
} else {
	parentPort!.postMessage(await Promise.all(pending))
}
