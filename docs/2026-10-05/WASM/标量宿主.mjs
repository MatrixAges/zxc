import { readFile } from 'node:fs/promises'

const module = await WebAssembly.compile(await readFile(process.argv[2]))
const { exports: api } = await WebAssembly.instantiate(module, {})
const decoder = new TextDecoder()
const results = []

try {
	for (const argument of process.argv.slice(3)) {
		const value = argument.endsWith('n') ? BigInt(argument.slice(0, -1)) : Number(argument)
		const status = api.zxc_call(value)
		const error = decoder.decode(
			new Uint8Array(api.memory.buffer, api.zxc_result_ptr() >>> 0, api.zxc_result_len() >>> 0)
		)

		results.push({ input: value, status, output: status === 0 ? api.zxc_scalar_result() : null, error })
	}

	console.log(
		JSON.stringify(
			{ imports: WebAssembly.Module.imports(module), exports: WebAssembly.Module.exports(module), results },
			(_, value) => (typeof value === 'bigint' ? `${value}n` : value),
			2
		)
	)
} finally {
	api.zxc_deinit()
}
