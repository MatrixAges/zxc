import type { Execute } from './load.ts'
import assert from 'node:assert/strict'

export default function checkProperties(execute: Execute): number {
	const input = Object.fromEntries(['__proto__', 'constructor', 'prototype'].map(name => [name, `own:${name}`]))
	const output = execute(input)

	assert.ok(typeof output === 'object' && output !== null)
	assert.equal(Object.getPrototypeOf(output), Object.prototype)
	assert.deepEqual(Object.keys(output).sort(), Object.keys(input).sort())

	for (const name of Object.keys(input)) {
		const descriptor = Object.getOwnPropertyDescriptor(output, name)

		assert.ok(descriptor)
		assert.equal(descriptor.value, input[name])
		assert.equal(descriptor.enumerable, true)
		assert.equal(descriptor.get, undefined)
	}

	return 1
}
