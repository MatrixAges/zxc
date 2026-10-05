import { createRequire } from 'node:module'

const require = createRequire(import.meta.url)
const addon = require(process.argv[2])
const bytes = Buffer.from([0, 128, 255])
const input = { name: '中文\0文本', bytes, count: 9007199254740993n, pair: [true, 1.25], mode: 'Read', note: null }
const output = addon.execute(input)

bytes.fill(1)

const observations = { output, output_is_buffer: Buffer.isBuffer(output.bytes), independent_bytes: [...output.bytes] }

try {
	addon.execute({ ...input, count: 1n << 80n })
} catch (error) {
	observations.overflow = error.message
}

try {
	addon.execute({
		...input,
		get name() {
			throw new Error('getter failure')
		}
	})
} catch (error) {
	observations.getter_error = error.message
}

try {
	addon.execute({
		...input,
		get name() {
			return addon.execute(input).name
		}
	})
} catch (error) {
	observations.reentry = error.message
}

observations.after_error = addon.execute({ ...input, bytes: new Uint8Array([2, 3]), note: 'restored' })

console.log(JSON.stringify(observations, (_, value) => (typeof value === 'bigint' ? `${value}n` : value), 2))
