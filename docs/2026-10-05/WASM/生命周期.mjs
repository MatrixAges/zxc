import { readFile } from 'node:fs/promises'

const { instance } = await WebAssembly.instantiate(await readFile(process.argv[2]), {})
const api = instance.exports
const bytes = new TextEncoder().encode(process.argv[3])
const decoder = new TextDecoder()

function invoke() {
	const pointer = api.zxc_alloc(bytes.length) >>> 0

	if (pointer === 0) throw new Error('Allocation failed')

	new Uint8Array(api.memory.buffer, pointer, bytes.length).set(bytes)

	const status = api.zxc_execute()
	const result = decoder.decode(
		new Uint8Array(api.memory.buffer, api.zxc_result_ptr() >>> 0, api.zxc_result_len() >>> 0)
	)
	const repeat_status = api.zxc_execute()

	return { status, result, repeat_status }
}

const first = invoke()
const second = invoke()

api.zxc_deinit()

const restarted = invoke()

api.zxc_deinit()

console.log(JSON.stringify({ first, second, restarted }, null, 2))
