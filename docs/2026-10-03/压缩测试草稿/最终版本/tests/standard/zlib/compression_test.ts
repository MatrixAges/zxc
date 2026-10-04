import assert from 'node:assert/strict'
import { mkdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { gunzipSync, inflateRawSync, inflateSync } from 'node:zlib'

type Run = (args: { command: string; argv: Array<string>; cwd: string; failure?: string }) => string

export default function checkCompression(args: { directory: string; executable: string; run: Run }): void {
	const { directory, executable, run } = args
	const project = join(directory, 'zlib_compression')
	const application = join(project, process.platform === 'win32' ? 'application.exe' : 'application')

	mkdirSync(project)
	writeFileSync(join(project, 'main.zx'), `import zlib from "std:zlib";

export type Input = { operation: u8; data: u8[]; level: i32; };

export type Output = u8[];

export default function (in: Input): Output {
  switch (in.operation) {
    case 0: return zlib.gzip(in.data);
    case 1: return zlib.deflate(in.data);
    case 2: return zlib.deflateRaw(in.data);
    case 3: return zlib.gzipWith({ data: in.data, level: in.level });
    case 4: return zlib.deflateWith({ data: in.data, level: in.level });
    default: return zlib.deflateRawWith({ data: in.data, level: in.level });
  }
}
`)
	run({ command: executable, argv: ['build', 'main.zx', '--out', application], cwd: project })

	const payloads = [
		{ name: 'empty', data: Buffer.alloc(0) },
		{ name: 'one_nul', data: Buffer.from([0]) },
		{ name: 'unicode', data: Buffer.from('中文🌱\0') },
		{ name: 'all_bytes', data: Buffer.from(Array.from({ length: 256 }, (_, index) => index)) },
		{ name: 'window_32769', data: Buffer.from(Array.from({ length: 32769 }, (_, index) => (index * 37 + Math.floor(index / 256)) % 256)) },
		{ name: 'stored_65535', data: Buffer.alloc(65535, 65) },
		{ name: 'stored_65536', data: Buffer.alloc(65536, 65) },
	]
	let passed = 0

	for (const [format, decompress] of [gunzipSync, inflateSync, inflateRawSync].entries()) {
		for (const payload of payloads) {
			for (const level of [null, -1, ...Array.from({ length: 10 }, (_, index) => index)]) {
				const id = `zlib/compression/format_${format}/${payload.name}/level_${level ?? 'default'}`
				const input = { operation: format + (level === null ? 0 : 3), data: [...payload.data], level: level ?? -1 }
				const output: unknown = JSON.parse(run({ command: application, argv: [JSON.stringify(input)], cwd: project }))

				assert.ok(typeof output === 'string' || (Array.isArray(output) && output.every((value: unknown) => typeof value === 'number' && Number.isInteger(value) && value >= 0 && value <= 255)), id)

				const bytes = typeof output === 'string' ? Buffer.from(output, 'utf8') : Buffer.from(output as Array<number>)

				assert.deepEqual(decompress(bytes), payload.data, id)
				passed++
			}
		}

		for (const level of [-2147483648, -2, 10, 2147483647]) {
			const input = { operation: format + 3, data: [1, 2, 3], level }
			const output = run({ command: application, argv: [JSON.stringify(input)], cwd: project, failure: 'InvalidCompressionLevel' })

			assert.equal(output, '', `zlib/compression/format_${format}/invalid_level_${level}`)
			passed++
		}
	}

	console.log(`Zlib compression: ${passed} independently decoded or rejected application calls passed`)
}
