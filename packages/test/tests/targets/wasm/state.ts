import assert from 'node:assert/strict'
import createHost from './host.ts'

export default function checkState(path: string): number {
	const first = createHost(path)
	const second = createHost(path)

	try {
		assert.deepEqual(first.invoke('1'), { status: 0, result: '4' })
		assert.equal(first.api.zxc_execute(), 1)
		assert.equal(first.readResult(), 'InputNotPrepared')
		assert.deepEqual(first.invoke('0'), { status: 0, result: '4' })
		first.api.zxc_reset()
		assert.equal(first.api.zxc_call!(2n), 0)
		assert.equal(first.api.zxc_scalar_result!(), 6n)
		assert.deepEqual(first.invoke('0'), { status: 0, result: '6' })
		assert.equal(first.invoke('"invalid"').status, 1)
		assert.equal(first.api.zxc_scalar_result!(), 0n)
		assert.equal(first.api.zxc_call!(0n), 0)
		assert.equal(first.api.zxc_scalar_result!(), 6n)
		assert.equal(second.api.zxc_call!(0n), 0)
		assert.equal(second.api.zxc_scalar_result!(), 3n)
		first.api.zxc_deinit()
		first.api.zxc_deinit()
		assert.equal(first.api.zxc_call!(0n), 0)
		assert.equal(first.api.zxc_scalar_result!(), 3n)
		assert.deepEqual(first.invoke('5'), { status: 0, result: '8' })
		first.api.zxc_reset()
		assert.deepEqual(first.invoke('0'), { status: 0, result: '8' })
		assert.deepEqual(second.invoke('1'), { status: 0, result: '4' })

		const pointer = first.api.zxc_alloc(1) >>> 0

		assert.notEqual(pointer, 0)
		new Uint8Array(first.api.memory.buffer, pointer, 1)[0] = 50
		assert.deepEqual(first.invoke('0'), { status: 0, result: '8' })

		return 13
	} finally {
		first.api.zxc_deinit()
		second.api.zxc_deinit()
	}
}
