import assert from 'node:assert/strict'
import createHost from './host.ts'

export default function checkProtocol(args: {
	scalar: string
	record: string
	discard: string
	state: string
}): number {
	const { scalar, record, discard, state } = args
	let count = 0

	for (const path of [scalar, record, discard, state]) {
		const host = createHost(path)

		try {
			assert.equal(host.api.zxc_execute(), 1)
			assert.equal(host.readResult(), 'InputNotPrepared')
			host.api.zxc_reset()
			assert.equal(host.readResult(), '')
			host.api.zxc_deinit()
			host.api.zxc_deinit()
			assert.equal(host.readResult(), '')
			count += 1
		} finally {
			host.api.zxc_deinit()
		}
	}

	const host = createHost(record)
	let trapped = false

	try {
		assert.equal(host.api.zxc_call, undefined)
		assert.equal(host.api.zxc_scalar_result, undefined)

		for (const size of [0, 1, 64, 4096, 65536, 1048576]) {
			const input = {
				message: '中'.repeat(size) + '\0尾',
				values: [0, 1, 65536],
				flag: size % 2 === 0,
				optional: size === 0 ? null : ''
			}
			const response = host.invoke(JSON.stringify(input))

			assert.equal(response.status, 0)
			assert.deepEqual(JSON.parse(response.result), input)
			assert.equal(host.api.zxc_execute(), 1)
			assert.equal(host.readResult(), 'InputNotPrepared')
			count += 1
		}

		for (const text of ['', '{', 'null', 'true', '[]', '{}', '{"message": 1}']) {
			assert.equal(host.invoke(text).status, 1)
			assert.match(host.readResult(), /^[A-Za-z][A-Za-z0-9]*$/)
			count += 1
		}

		const input = { message: '恢复', values: [42], flag: true, optional: null }

		for (let index = 0; index < 20; index += 1) assert.equal(host.invoke(JSON.stringify(input)).status, 0)

		const size = host.api.memory.buffer.byteLength

		for (let index = 0; index < 100; index += 1) {
			assert.deepEqual(JSON.parse(host.invoke(JSON.stringify(input)).result), input)
			assert.equal(host.api.memory.buffer.byteLength, size)
			count += 1
		}

		assert.equal(host.api.zxc_alloc(0xffffffff), 0)
		assert.equal(host.readResult(), 'OutOfMemory')
		assert.deepEqual(JSON.parse(host.invoke(JSON.stringify(input)).result), input)
		count += 1
	} catch (error) {
		trapped = error instanceof WebAssembly.RuntimeError
		throw error
	} finally {
		if (!trapped) host.api.zxc_deinit()
	}

	const silent = createHost(discard)

	try {
		assert.deepEqual(silent.invoke('7'), { status: 0, result: '' })
		assert.equal(silent.invoke('"invalid"').status, 1)
		assert.notEqual(silent.readResult(), '')
		count += 2
	} finally {
		silent.api.zxc_deinit()
	}

	return count
}
