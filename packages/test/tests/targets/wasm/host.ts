/// <reference lib="dom" />

import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'

type Api = {
	memory: WebAssembly.Memory
	zxc_alloc(length: number): number
	zxc_execute(): number
	zxc_result_ptr(): number
	zxc_result_len(): number
	zxc_reset(): void
	zxc_deinit(): void
	zxc_call?: (value?: number | bigint) => number
	zxc_scalar_result?: () => number | bigint
}

export default function createHost(path: string) {
	const module = new WebAssembly.Module(readFileSync(path))

	assert.deepEqual(WebAssembly.Module.imports(module), [])

	const instance = new WebAssembly.Instance(module, {})
	const exports = instance.exports

	assert.ok(exports.memory instanceof WebAssembly.Memory)

	for (const name of ['zxc_alloc', 'zxc_execute', 'zxc_result_ptr', 'zxc_result_len', 'zxc_reset', 'zxc_deinit']) {
		assert.equal(typeof exports[name], 'function', name)
	}

	const api = exports as unknown as Api
	const encoder = new TextEncoder()
	const decoder = new TextDecoder('utf-8', { fatal: true })

	function readResult(): string {
		const pointer = api.zxc_result_ptr() >>> 0
		const length = api.zxc_result_len() >>> 0

		assert.ok(pointer + length <= api.memory.buffer.byteLength)

		return decoder.decode(new Uint8Array(api.memory.buffer, pointer, length))
	}

	function invoke(text: string) {
		const bytes = encoder.encode(text)
		const pointer = api.zxc_alloc(bytes.length) >>> 0

		assert.notEqual(pointer, 0, readResult())
		new Uint8Array(api.memory.buffer, pointer, bytes.length).set(bytes)

		const status = api.zxc_execute()

		return { status, result: readResult() }
	}

	return { api, invoke, readResult }
}
