import { readFile } from 'node:fs/promises'

const module = await WebAssembly.compile(await readFile(process.argv[2]))
const instance = await WebAssembly.instantiate(module, {})
const api = instance.exports
const encoder = new TextEncoder()
const decoder = new TextDecoder()

function readResult() {
	return decoder.decode(new Uint8Array(api.memory.buffer, api.zxc_result_ptr() >>> 0, api.zxc_result_len() >>> 0))
}

function invoke(input) {
	const bytes = encoder.encode(input)
	const pointer = api.zxc_alloc(bytes.length) >>> 0

	if (pointer === 0) throw new Error(readResult())

	new Uint8Array(api.memory.buffer, pointer, bytes.length).set(bytes)

	const status = api.zxc_execute()
	const result = readResult()

	api.zxc_reset()

	return { status, result }
}

try {
	console.log(
		JSON.stringify(
			{ imports: WebAssembly.Module.imports(module), results: process.argv.slice(3).map(invoke) },
			null,
			2
		)
	)
} finally {
	api.zxc_deinit()
}
