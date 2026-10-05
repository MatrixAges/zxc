import type { Input, Output } from './addon.cjs'

import { executeAsync } from './addon.cjs'

const input: Input = {
	name: 'async module',
	bytes: new Uint8Array([1, 2, 255]),
	count: 9007199254740993n,
	pair: [true, 1.25],
	mode: 'Read'
}

const pending: Promise<Output> = executeAsync(input)
const output: Output = await pending

console.log(output)
