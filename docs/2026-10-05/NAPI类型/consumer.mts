import type { Input, Output } from './addon.cjs'

import { execute } from './addon.cjs'

const input: Input = {
	name: 'typed module',
	bytes: new Uint8Array([1, 2, 255]),
	count: 9007199254740993n,
	pair: [true, 1.25],
	mode: 'Read'
}

const output: Output = execute(input)

console.log(JSON.stringify(output, (_, value: unknown) => (typeof value === 'bigint' ? `${value}n` : value), 2))
