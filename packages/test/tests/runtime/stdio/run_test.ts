import assert from 'node:assert/strict'
import { isUtf8 } from 'node:buffer'
import { resolve } from 'node:path'
import createFixture from './fixture.ts'

const fixture = createFixture({
	compiler: resolve(process.argv[2]),
	source: resolve(process.argv[3]),
	optimize: process.argv[4]
})
const empty = Buffer.alloc(0)
const unicode = Buffer.from('中文 🌿\0tail\n')
const binary = Buffer.from(Array.from({ length: 256 }, (_, index) => index))
const large = Buffer.alloc(16385, 113)
const malformed = [
	Buffer.from([255]),
	Buffer.from([128]),
	Buffer.from([192, 128]),
	Buffer.from([226, 130]),
	Buffer.from([237, 160, 128]),
	Buffer.from([244, 144, 128, 128])
]
let checks = 0

function check(name: string, body: () => void) {
	body()
	checks += 1
	console.log(`ok ${checks}: ${name}`)
}

try {
	for (const mode of ['bytes', 'text']) {
		const executable = fixture.build({ entry: `read_${mode}.zx`, policy: 'json' })
		const inputs = mode === 'bytes' ? [empty, unicode, binary, large] : [empty, unicode, large]

		for (const input of inputs) {
			check(`${mode} reads ${input.length} bytes at exact limit and serializes only result`, () => {
				const result = fixture.run({ executable, input, max_bytes: input.length })

				assert.equal(result.stderr.length, 0)
				assert.deepEqual(
					JSON.parse(result.stdout.toString()),
					mode === 'bytes' && !isUtf8(input) ? [...input] : input.toString()
				)
			})
		}

		for (const [input, max_bytes] of [
			[Buffer.from('x'), 0],
			[Buffer.from('abcd'), 3],
			[Buffer.from('abcdefgh'), 3],
			[Buffer.alloc(4097, 113), 4096]
		] as const) {
			check(`${mode} rejects ${input.length} bytes above ${max_bytes} limit`, () => {
				fixture.run({ executable, input, max_bytes, failure: 'StreamTooLong' })
			})
		}

		if (mode === 'text') {
			for (const input of malformed) {
				check(`text rejects malformed UTF8 ${input.toString('hex')}`, () => {
					fixture.run({ executable, input, max_bytes: input.length, failure: 'InvalidUtf8' })
				})
			}

			check('text limit counts bytes rather than characters', () => {
				fixture.run({ executable, input: unicode, max_bytes: unicode.length - 1, failure: 'StreamTooLong' })
			})
		}
	}

	for (const mode of ['bytes', 'text']) {
		for (const policy of ['json', 'discard'] as const) {
			const executable = fixture.build({ entry: `copy_${mode}.rx`, policy })
			const inputs = mode === 'bytes' ? [empty, unicode, binary, large] : [empty, unicode, large]

			for (const input of inputs) {
				check(`${mode} ${policy} writes ${input.length} bytes to both streams`, () => {
					const result = fixture.run({ executable, input, max_bytes: input.length })
					const expected = Buffer.concat([input, policy === 'json' ? Buffer.from('null\n') : empty])

					assert.deepEqual(result.stdout, expected)
					assert.deepEqual(result.stderr, input)
				})
			}

			check(`${mode} ${policy} file redirection appends result after business output`, () => {
				const result = fixture.run({ executable, input: large, max_bytes: large.length, redirect: true })

				assert.deepEqual(
					result.stdout,
					Buffer.concat([large, policy === 'json' ? Buffer.from('null\n') : empty])
				)
				assert.deepEqual(result.stderr, large)
			})

			check(`${mode} ${policy} overflow fails before either business write`, () => {
				fixture.run({ executable, input: Buffer.from('abcd'), max_bytes: 3, failure: 'StreamTooLong' })
			})

			check(`${mode} ${policy} keeps stdin separate from required JSON argv`, () => {
				fixture.run({
					executable,
					input: Buffer.from('3'),
					max_bytes: 1,
					extra: ['extra'],
					failure: 'ExpectedJsonInput'
				})
			})

			if (mode === 'text') {
				check(`${mode} ${policy} invalid UTF8 is not suppressed by result policy`, () => {
					fixture.run({ executable, input: malformed[0], max_bytes: 1, failure: 'InvalidUtf8' })
				})
			}
		}
	}

	console.log(`Standard stream applications: ${checks} checks passed`)
} finally {
	fixture.close()
}
