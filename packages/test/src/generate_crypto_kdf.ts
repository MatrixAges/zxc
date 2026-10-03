import type { Json } from './shared/json.ts'
import { createHmac, hkdfSync, pbkdf2Sync } from 'node:crypto'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Row = { id: string; input: Json; expected: { value: Json } | { error: string } }
const bytes = (length: number) => Buffer.from(Array.from({ length }, (_, index) => (index * 37 + 11) % 256))

for (const bits of [256, 512]) {
	const digest = `sha${bits}`
	const tag_length = bits / 8
	const hmac_rows: Array<Row> = []
	const hkdf_rows: Array<Row> = []
	const password_rows: Array<Row> = []

	for (const key_length of [0, 1, 32, 64, 65, 128, 129]) {
		for (const data_length of [0, 1, 15, 16, 17, 64, 129]) {
			const key = bytes(key_length)
			const data = bytes(data_length)
			const tag = createHmac(digest, key).update(data).digest()
			const bad = Buffer.from(tag)

			bad[0] ^= 1
			hmac_rows.push({
				id: `standard/crypto/hmac_sha${bits}/${key_length}/${data_length}`,
				input: { key: [...key], data: [...data], tag: [...tag], bad: [...bad] },
				expected: { value: { tag: [...tag], valid: true, invalid: false } }
			})
		}
	}

	for (const length of [0, tag_length - 1, tag_length + 1]) {
		hmac_rows.push({
			id: `standard/crypto/hmac_sha${bits}/tag_length/${length}`,
			input: { key: [], data: [], tag: [...bytes(length)], bad: [...bytes(tag_length)] },
			expected: { error: 'InvalidTagLength' }
		})
	}

	for (const key_length of [0, 1, 65]) {
		for (const salt_length of [0, 16]) {
			for (const info of [Buffer.alloc(0), Buffer.from('上下文🌱')]) {
				for (const length of [0, 1, 31, 32, 33, 65]) {
					const key = bytes(key_length)
					const salt = bytes(salt_length)
					const output =
						length === 0 ? Buffer.alloc(0) : Buffer.from(hkdfSync(digest, key, salt, info, length))

					hkdf_rows.push({
						id: `standard/crypto/hkdf_sha${bits}/${key_length}/${salt_length}/${info.length}/${length}`,
						input: { key: [...key], salt: [...salt], info: [...info], length },
						expected: { value: [...output] }
					})
				}
			}
		}
	}

	for (const length of [tag_length * 255, tag_length * 255 + 1]) {
		hkdf_rows.push({
			id: `standard/crypto/hkdf_sha${bits}/limit/${length}`,
			input: { key: [], salt: [], info: [], length },
			expected:
				length > tag_length * 255
					? { error: 'OutputTooLong' }
					: {
							value: [
								...Buffer.from(
									hkdfSync(digest, Buffer.alloc(0), Buffer.alloc(0), Buffer.alloc(0), length)
								)
							]
						}
		})
	}

	for (const [index, password] of [Buffer.alloc(0), Buffer.from('密码\0🌱'), bytes(80)].entries()) {
		for (const salt_length of [0, 16]) {
			for (const iterations of [1, 2, 17]) {
				for (const length of [0, 1, 31, 32, 33, 65]) {
					const salt = bytes(salt_length)
					const output =
						length === 0 ? Buffer.alloc(0) : pbkdf2Sync(password, salt, iterations, length, digest)

					password_rows.push({
						id: `standard/crypto/pbkdf2_sha${bits}/${index}/${salt_length}/${iterations}/${length}`,
						input: { password: [...password], salt: [...salt], iterations, length },
						expected: { value: [...output] }
					})
				}
			}
		}
	}

	password_rows.push({
		id: `standard/crypto/pbkdf2_sha${bits}/zero_iterations`,
		input: { password: [], salt: [], iterations: 0, length: 32 },
		expected: { error: 'InvalidIterations' }
	})

	for (const [name, input, output, body, rows] of [
		[
			`hmac_sha${bits}`,
			'{ key: u8[]; data: u8[]; tag: u8[]; bad: u8[]; }',
			'{ tag: u8[]; valid: bool; invalid: bool; }',
			`return { tag: crypto.hmacSha${bits}({ key: in.key, data: in.data }), valid: crypto.verifyHmacSha${bits}({ key: in.key, data: in.data, tag: in.tag }), invalid: crypto.verifyHmacSha${bits}({ key: in.key, data: in.data, tag: in.bad }) };`,
			hmac_rows
		],
		[
			`hkdf_sha${bits}`,
			'{ key: u8[]; salt: u8[]; info: u8[]; length: u32; }',
			'u8[]',
			`return crypto.hkdfSha${bits}(in);`,
			hkdf_rows
		],
		[
			`pbkdf2_sha${bits}`,
			'{ password: u8[]; salt: u8[]; iterations: u32; length: u32; }',
			'u8[]',
			`return crypto.pbkdf2Sha${bits}(in);`,
			password_rows
		]
	] as const) {
		const base = `tests/standard/crypto/${name}/cases`

		writeCatalog(base + '.jsonl', rows)
		writeOutput(
			base + '.zx',
			`import crypto from "std:crypto";\n\nexport type Input = ${input};\n\nexport type Output = ${output};\n\nexport default function (in: Input): Output {\n  ${body}\n}\n`
		)
	}
}

const compare_rows: Array<Row> = []

for (const length of [0, 1, 16, 32, 64]) {
	const left = [...bytes(length)]
	const variants = [
		{ name: 'same', right: [...left] },
		{ name: 'longer', right: [...left, 0] }
	]

	if (length > 0) variants.push({ name: 'shorter', right: left.slice(0, -1) })

	for (const index of new Set([0, Math.floor(length / 2), length - 1])) {
		if (index < 0 || index >= length) continue

		const right = [...left]
		right[index] ^= 1
		variants.push({ name: `different_${index}`, right })
	}

	for (const { name, right } of variants) {
		compare_rows.push({
			id: `standard/crypto/timing_safe_equal/${length}/${name}`,
			input: { left, right },
			expected:
				left.length !== right.length
					? { error: 'LengthMismatch' }
					: { value: Buffer.from(left).equals(Buffer.from(right)) }
		})
	}
}

writeCatalog('tests/standard/crypto/timing_safe_equal/cases.jsonl', compare_rows)
writeOutput(
	'tests/standard/crypto/timing_safe_equal/cases.zx',
	'import crypto from "std:crypto";\n\nexport type Input = { left: u8[]; right: u8[]; };\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return crypto.timingSafeEqual(in);\n}\n'
)
