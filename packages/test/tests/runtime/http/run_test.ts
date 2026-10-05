import assert from 'node:assert/strict'
import { resolve } from 'node:path'
import { gzipSync } from 'node:zlib'
import createApplication from './application.ts'
import createFixtureServer from './server.ts'

type Options = {
	url: string
	method: string
	headers: Array<{ name: string; value: Array<number> }>
	body: Array<number> | null
	max_body_bytes: number
	max_header_bytes: number
}

const application = createApplication({
	compiler: resolve(process.argv[2]),
	source: resolve(process.argv[3]),
	optimize: process.argv[4]
})
const server = await createFixtureServer()
let checks = 0

function options(): Options {
	return {
		url: `${server.url}/a%20b?q=%2F#fragment`,
		method: 'Get',
		headers: [],
		body: null,
		max_body_bytes: 1024,
		max_header_bytes: 8192
	}
}

function bytes(value: string | Array<number>) {
	return typeof value === 'string' ? Buffer.from(value) : Buffer.from(value)
}

function wire(args: { body: Buffer; status?: number; headers?: string }) {
	const { body, status = 200, headers = '' } = args

	return Buffer.concat([
		Buffer.from(`HTTP/1.1 ${status} Response\r\nContent-Length: ${body.length}\r\n${headers}\r\n`, 'latin1'),
		body
	])
}

async function check(name: string, body: () => Promise<void>) {
	await body()
	checks += 1
	console.log(`ok ${checks}: ${name}`)
}

try {
	for (const entry of ['request.zx', 'workflow.rx']) {
		const executable = application.build(entry)

		for (const method of ['Get', 'Head', 'Post', 'Put', 'Patch', 'Delete', 'Options']) {
			await check(`${entry} sends ${method} method body and literal path`, async () => {
				const payload = ['Post', 'Put', 'Patch'].includes(method) ? [0, 255, 65, 10] : null
				const input = { ...options(), method, body: payload }
				const previous = server.requests.length

				server.respond(wire({ body: Buffer.alloc(0) }))

				const result = await application.run({ executable, input })

				assert.ok(result)
				assert.equal(result.status, 200)
				assert.equal(server.requests.length, previous + 1)

				const request = server.requests.at(-1)!

				assert.equal(request.method, method.toUpperCase())
				assert.equal(request.target, '/a%20b?q=%2F')
				assert.deepEqual(request.body, Buffer.from(payload ?? []))
			})
		}

		await check(`${entry} sends large POST body across client write buffer`, async () => {
			const payload = Buffer.alloc(16385, 113)

			server.respond(wire({ body: Buffer.alloc(0) }))

			const result = await application.run({
				executable,
				input: { ...options(), method: 'Post', body: [...payload] }
			})

			assert.ok(result)
			assert.deepEqual(server.requests.at(-1)!.body, payload)
		})

		await check(`${entry} preserves request headers and raw duplicate response headers`, async () => {
			const input = options()

			input.headers = [
				{ name: 'Authorization', value: [...Buffer.from('Bearer explicit-test-token')] },
				{ name: 'X-Repeat', value: [65] },
				{ name: 'X-Repeat', value: [66] },
				{ name: 'X-Raw', value: [255] }
			]
			server.respond(
				wire({ body: Buffer.from([0, 255, 65]), headers: 'X-Repeat: one\r\nX-Repeat: two\r\nX-Raw: aÿb\r\n' })
			)

			const result = await application.run({ executable, input })

			assert.ok(result)
			assert.deepEqual(bytes(result.body), Buffer.from([0, 255, 65]))
			assert.deepEqual(
				result.headers
					.filter(header => header.name.toLowerCase() === 'x-repeat')
					.map(header => bytes(header.value).toString()),
				['one', 'two']
			)
			assert.deepEqual(
				bytes(result.headers.find(header => header.name.toLowerCase() === 'x-raw')!.value),
				Buffer.from([97, 255, 98])
			)

			const request = server.requests.at(-1)!

			assert.deepEqual(
				request.headers
					.filter(header => header.name.toLowerCase() === 'x-repeat')
					.map(header => header.value.toString()),
				['A', 'B']
			)
			assert.deepEqual(
				request.headers.find(header => header.name.toLowerCase() === 'x-raw')!.value,
				Buffer.from([255])
			)
			assert.equal(
				request.headers.find(header => header.name.toLowerCase() === 'authorization')!.value.toString(),
				'Bearer explicit-test-token'
			)
		})

		for (const status of [302, 404, 503]) {
			await check(`${entry} returns ${status} as normal response without retry or redirect`, async () => {
				const previous = server.requests.length

				server.respond(
					wire({ status, body: Buffer.from('response'), headers: `Location: ${server.url}/other\r\n` })
				)

				const result = await application.run({ executable, input: options() })

				assert.ok(result)
				assert.equal(result.status, status)
				assert.equal(bytes(result.body).toString(), 'response')
				assert.equal(server.requests.length, previous + 1)
			})
		}

		const compressed = gzipSync(Buffer.from('original text'))
		const valid = [
			{ name: 'empty zero limit', response: wire({ body: Buffer.alloc(0) }), body: Buffer.alloc(0), limit: 0 },
			{
				name: 'exact binary limit',
				response: wire({ body: Buffer.from([0, 255, 1, 2]) }),
				body: Buffer.from([0, 255, 1, 2]),
				limit: 4
			},
			{
				name: 'large body',
				response: wire({ body: Buffer.alloc(16385, 113) }),
				body: Buffer.alloc(16385, 113),
				limit: 16385
			},
			{
				name: 'close delimited',
				response: Buffer.from('HTTP/1.1 200 OK\r\nConnection: close\r\n\r\nbody'),
				body: Buffer.from('body'),
				limit: 4
			},
			{
				name: 'chunked trailers',
				response: Buffer.from(
					'HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n2\r\nab\r\n2\r\ncd\r\n0\r\nX-Trailer: final\r\n\r\n'
				),
				body: Buffer.from('abcd'),
				limit: 4
			},
			{
				name: 'compressed bytes',
				response: wire({ body: compressed, headers: 'Content-Encoding: gzip\r\n' }),
				body: compressed,
				limit: compressed.length
			}
		]

		for (const item of valid) {
			await check(`${entry} accepts ${item.name}`, async () => {
				server.respond(item.response)

				const result = await application.run({
					executable,
					input: { ...options(), max_body_bytes: item.limit }
				})

				assert.ok(result)
				assert.deepEqual(bytes(result.body), item.body)
			})
		}

		for (const status of [204, 304]) {
			await check(`${entry} status ${status} returns no body with zero limit`, async () => {
				server.respond(Buffer.from(`HTTP/1.1 ${status} Response\r\n\r\n`))

				const result = await application.run({ executable, input: { ...options(), max_body_bytes: 0 } })

				assert.ok(result)
				assert.equal(result.status, status)
				assert.equal(bytes(result.body).length, 0)
			})
		}

		const interim = Buffer.from('HTTP/1.1 100 Continue\r\n\r\nHTTP/1.1 103 Early Hints\r\nLink: </a>\r\n\r\n')
		const final = wire({ body: Buffer.alloc(0) })
		const combined = Buffer.concat([interim, final])

		await check(`${entry} interim responses fit aggregate exact header limit`, async () => {
			server.respond(combined)

			const result = await application.run({
				executable,
				input: { ...options(), max_header_bytes: combined.length }
			})

			assert.ok(result)
			assert.equal(result.status, 200)
			assert.equal(
				result.headers.some(header => header.name.toLowerCase() === 'link'),
				false
			)
		})

		const rejected = [
			{
				name: 'one byte over body limit',
				response: wire({ body: Buffer.from('abcd') }),
				input: { max_body_bytes: 3 },
				error: 'StreamTooLong'
			},
			{
				name: 'one byte over zero limit',
				response: wire({ body: Buffer.from('x') }),
				input: { max_body_bytes: 0 },
				error: 'StreamTooLong'
			},
			{
				name: 'cumulative header overflow',
				response: combined,
				input: { max_header_bytes: combined.length - 1 },
				error: 'HttpHeadersTooLarge'
			},
			{
				name: 'single head overflow',
				response: final,
				input: { max_header_bytes: final.length - 1 },
				error: 'HttpHeadersOversize'
			},
			{
				name: 'upgrade',
				response: Buffer.from(
					'HTTP/1.1 101 Switching Protocols\r\nConnection: upgrade\r\nUpgrade: websocket\r\n\r\n'
				),
				input: {},
				error: 'HttpUpgradeUnsupported'
			},
			{
				name: 'truncated content length',
				response: Buffer.from('HTTP/1.1 200 OK\r\nContent-Length: 10\r\n\r\nabc'),
				input: {},
				error: 'ReadFailed'
			},
			{
				name: 'missing terminal chunk',
				response: Buffer.from('HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nabc\r\n'),
				input: {},
				error: 'ReadFailed'
			},
			{
				name: 'truncated chunk data',
				response: Buffer.from('HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\nA\r\nabc'),
				input: {},
				error: 'ReadFailed'
			},
			{
				name: 'truncated final terminator',
				response: Buffer.from('HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n0\r\n'),
				input: {},
				error: 'ReadFailed'
			},
			{
				name: 'conflicting lengths',
				response: Buffer.from('HTTP/1.1 200 OK\r\nContent-Length: 0\r\nContent-Length: 1\r\n\r\nx'),
				input: {},
				error: 'HttpHeadersInvalid'
			}
		]

		for (const item of rejected) {
			await check(`${entry} rejects ${item.name}`, async () => {
				server.respond(item.response)
				await application.run({ executable, input: { ...options(), ...item.input }, failure: item.error })
			})
		}

		for (const item of [
			{ input: { ...options(), max_header_bytes: 0 }, failure: 'InvalidHeaderLimit' },
			{ input: { ...options(), body: [] }, failure: 'UnsupportedRequestBody' },
			{ input: { ...options(), headers: [{ name: 'hOsT', value: [65] }] }, failure: 'ManagedHttpHeader' },
			{ input: { ...options(), headers: [{ name: 'X-Value', value: [13, 10] }] }, failure: 'InvalidHttpHeader' }
		]) {
			await check(`${entry} rejects ${item.failure} before network`, async () => {
				const previous = server.requests.length

				await application.run({ executable, ...item })
				assert.equal(server.requests.length, previous)
			})
		}
	}

	console.log(`HTTP applications: ${checks} checks passed`)
} finally {
	await server.close()
	application.close()
}
