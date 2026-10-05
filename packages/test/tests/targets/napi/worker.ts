import { parentPort, workerData } from 'node:worker_threads'
import load from './load.ts'

const execute = load(workerData as string)

parentPort!.postMessage([execute(0n), execute(2n), execute(0n)])
