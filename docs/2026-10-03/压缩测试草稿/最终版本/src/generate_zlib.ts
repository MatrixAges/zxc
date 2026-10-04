import { deflateRawSync, deflateSync, gzipSync } from 'node:zlib'
import { writeCatalog, writeOutput } from './shared/catalog.ts'
import errorCases from './zlib/errors.ts'

type Row = { id: string; input: { data: Array<number>; max_output_length: number }; expected: { value: Array<number> } | { error: string } }
const payloads = [
	{ name: 'empty', data: Buffer.alloc(0) },
	{ name: 'one_nul', data: Buffer.from([0]) },
	{ name: 'unicode', data: Buffer.from('中文🌱\0') },
	{ name: 'all_bytes', data: Buffer.from(Array.from({ length: 256 }, (_, index) => index)) },
	{ name: 'repeated_4097', data: Buffer.alloc(4097, 65) },
	...([32767, 32768, 32769].map(length => ({ name: `window_${length}`, data: Buffer.alloc(length, 0) }))),
]

for (const [format, operation, compress] of [
	['gunzip', 'gunzip', gzipSync],
	['inflate', 'inflate', deflateSync],
	['inflate_raw', 'inflateRaw', deflateRawSync],
] as const) {
	const rows: Array<Row> = []

	for (const payload of payloads) {
		for (const level of [0, 6, 9]) {
			const data = [...compress(payload.data, { level })]
			const limits = [...new Set([Math.max(0, payload.data.length - 1), payload.data.length, payload.data.length + 1])]

			for (const max_output_length of limits) rows.push({
				id: `standard/zlib/${format}/${payload.name}/level_${level}/limit_${max_output_length}`,
				input: { data, max_output_length },
				expected: max_output_length < payload.data.length ? { error: 'OutputTooLarge' } : { value: [...payload.data] },
			})
		}
	}

	for (const row of errorCases(format)) rows.push({ id: `standard/zlib/${format}/${row.name}`, input: { data: [...row.data], max_output_length: 100 }, expected: { error: row.error } })

	if (format === 'gunzip') {
		const data = [...Buffer.concat([gzipSync('abc'), gzipSync(''), gzipSync('def')])]

		for (const max_output_length of [0, 3, 5, 6, 7]) rows.push({ id: `standard/zlib/gunzip/concatenated_members/limit_${max_output_length}`, input: { data, max_output_length }, expected: max_output_length < 6 ? { error: 'OutputTooLarge' } : { value: [...Buffer.from('abcdef')] } })
	}

	const base = `tests/standard/zlib/${format}/cases`

	writeCatalog(base + '.jsonl', rows)
	writeOutput(base + '.zx', `import zlib from "std:zlib";\nimport type { DecompressOptions } from "std:zlib";\n\nexport type Input = DecompressOptions;\n\nexport type Output = u8[];\n\nexport default function (in: Input): Output {\n  return zlib.${operation}(in);\n}\n`)
}

const fixtures = [['gzip', gzipSync], ['zlib', deflateSync], ['raw', deflateRawSync]] as const

writeOutput('tests/standard/resources/zlib/fixtures.zig', fixtures.map(([name, compress]) => `pub const ${name} = [_]u8{ ${[...compress('abc', { level: 0 })].join(', ')} };`).join('\n\n') + '\n')
