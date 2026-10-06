import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import createApplication from '../../../packages/test/tests/runtime/gateway/application.ts'

const directory = dirname(fileURLToPath(import.meta.url))
const compiler = resolve(process.argv[2])
const application = createApplication({ compiler, source: resolve(directory, '应用'), optimize: 'debug' })

const rows = [
	{ path: '/scalar', body: '1' },
	{ path: '/scalar', body: '1e400' },
	{ path: '/scalar', body: '-1e400' },
	{ path: '/division', body: '{"numerator":1,"denominator":0}' },
	{ path: '/division', body: '{"numerator":-1,"denominator":0}' },
	{ path: '/division', body: '{"numerator":0,"denominator":0}' },
	{ path: '/scalar', body: '2' }
]

const observations = []
let gateway
let executable_sha256
let stderr
let stdout

try {
	gateway = await application.start()
	executable_sha256 = createHash('sha256').update(readFileSync(gateway.executable)).digest('hex')

	for (const row of rows) {
		const response = await gateway.request({ ...row, method: 'POST' })
		const body = response.body.toString()
		let parsed = null
		let parse_error = null

		try {
			parsed = JSON.parse(body)
		} catch (error) {
			parse_error = { name: error.name, message: error.message }
		}

		observations.push({
			...row,
			input_utf8_hex: Buffer.from(row.body).toString('hex'),
			response: {
				...response,
				headers: Object.fromEntries(response.headers),
				body,
				body_utf8_hex: response.body.toString('hex')
			},
			parsed,
			parse_error
		})
	}
} finally {
	await gateway?.stop()

	stderr = gateway?.stderr()
	stdout = gateway?.stdout()

	application.close()

	writeFileSync(
		resolve(directory, '实际结果.json'),
		JSON.stringify(
			{
				compiler,
				compiler_sha256: createHash('sha256').update(readFileSync(compiler)).digest('hex'),
				optimize: 'debug',
				executable_sha256,
				observations,
				stdout,
				stderr
			},
			null,
			2
		) + '\n'
	)
}

assert.equal(observations.length, 7)
assert.equal(observations[0].response.status, 200)
assert.equal(observations[0].parsed, 1)
assert.equal(observations[6].response.status, 200)
assert.equal(observations[6].parsed, 2)
console.log(JSON.stringify(observations, null, 2))
