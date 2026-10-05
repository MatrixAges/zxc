import assert from 'node:assert/strict'
import { createRequire } from 'node:module'

type Addon = {
	execute: (...values: Array<unknown>) => unknown
	executeAsync: (...values: Array<unknown>) => Promise<unknown>
}

export default function load(path: string): Addon {
	const require = createRequire(import.meta.url)
	const addon: unknown = require(path)

	assert.ok(typeof addon === 'object' && addon !== null)
	assert.ok('execute' in addon && typeof addon.execute === 'function')
	assert.ok('executeAsync' in addon && typeof addon.executeAsync === 'function')

	return addon as Addon
}
