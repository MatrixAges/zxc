import assert from 'node:assert/strict'
import { createRequire } from 'node:module'

export type Execute = (...values: Array<unknown>) => unknown

export default function load(path: string): Execute {
	const require = createRequire(import.meta.url)
	const addon: unknown = require(path)

	assert.ok(typeof addon === 'object' && addon !== null && 'execute' in addon)
	assert.equal(typeof addon.execute, 'function')

	return addon.execute as Execute
}
