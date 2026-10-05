import type { Check, Gateway } from './types.ts'
import assert from 'node:assert/strict'
import { gzipSync } from 'node:zlib'

export default async function checkBody(args: { gateway: Gateway; check: Check }) {
	const { gateway, check } = args

	for (const body of [
		'',
		'{',
		'{"message":"x"}',
		'{"message":1,"count":2}',
		'{"message":"x","count":2,"extra":3}',
		'{"message":"a","message":"b","count":1}'
	]) {
		await check(`echo rejects invalid JSON or shape ${JSON.stringify(body)}`, async () => {
			const response = await gateway.request({ method: 'POST', path: '/api/v1/echo', body })

			assert.equal(response.status, 400)
		})
	}

	for (const body of ['true', '[1]', '2147483648', '1.5', '1 2']) {
		await check(`scalar rejects incompatible JSON ${body}`, async () => {
			const response = await gateway.request({ method: 'POST', path: '/scalar', body })

			assert.equal(response.status, 400)
		})
	}

	for (const body of ['null', ' ', '{}']) {
		await check(`void input rejects nonempty body ${JSON.stringify(body)}`, async () => {
			const response = await gateway.request({ path: '/void', body })

			assert.equal(response.status, 400)
		})
	}

	await check('JSON string rejects invalid UTF8 bytes', async () => {
		const body = Buffer.from([34, 255, 34])
		const response = await gateway.raw({
			wire: Buffer.concat([
				Buffer.from(`POST /text HTTP/1.1\r\nHost: local\r\nContent-Length: ${body.length}\r\n\r\n`),
				body
			])
		})

		assert.equal(response.status, 400)
	})

	for (const length of [128, 129]) {
		await check(`Content-Length body boundary ${length}`, async () => {
			const body = JSON.stringify('x'.repeat(length - 2))
			const response = await gateway.request({ method: 'POST', path: '/text', body })

			assert.equal(Buffer.byteLength(body), length)
			assert.equal(response.status, length === 128 ? 200 : 413)

			if (length === 128) assert.equal(JSON.parse(response.body.toString()), 'x'.repeat(126))
		})
	}

	for (const length of [128, 129]) {
		await check(`chunked limit counts decoded body ${length}`, async () => {
			const body = JSON.stringify('x'.repeat(length - 2))
			const pieces = [body.slice(0, 30), body.slice(30)]
			const wire =
				'POST /text HTTP/1.1\r\nHost: local\r\nTransfer-Encoding: chunked\r\n\r\n' +
				pieces.map(piece => `${Buffer.byteLength(piece).toString(16)}\r\n${piece}\r\n`).join('') +
				'0\r\nX-Trailer: end\r\n\r\n'
			const response = await gateway.raw({ wire: Buffer.from(wire) })

			assert.equal(response.status, length === 128 ? 200 : 413)
			if (length === 128) assert.equal(JSON.parse(response.body.toString()), 'x'.repeat(126))
		})
	}

	await check('framing absent means empty body despite trailing bytes', async () => {
		const response = await gateway.raw({ wire: Buffer.from('GET /void HTTP/1.1\r\nHost: local\r\n\r\nignored') })

		assert.equal(response.status, 200)
		assert.equal(response.body.toString(), '7')
	})

	for (const expectation of ['100-continue', '100-CONTINUE']) {
		await check(`Expect ${expectation} completes handshake before body`, async () => {
			const response = await gateway.raw({
				wire: Buffer.from(
					`POST /scalar HTTP/1.1\r\nHost: local\r\nContent-Length: 2\r\nExpect: ${expectation}\r\n\r\n`
				),
				continue_body: Buffer.from('42')
			})

			assert.deepEqual(response.interim, [100])
			assert.equal(response.status, 200)
			assert.equal(response.body.toString(), '42')
		})
	}

	await check('oversized declared body is refused before Continue', async () => {
		const response = await gateway.raw({
			wire: Buffer.from(
				'POST /text HTTP/1.1\r\nHost: local\r\nContent-Length: 129\r\nExpect: 100-continue\r\n\r\n'
			),
			continue_body: Buffer.alloc(129, 120)
		})

		assert.equal(response.status, 413)
		assert.deepEqual(response.interim, [])
	})

	await check('unsupported Expect is refused without waiting for body', async () => {
		const response = await gateway.raw({
			wire: Buffer.from(
				'POST /scalar HTTP/1.1\r\nHost: local\r\nContent-Length: 2\r\nExpect: something-else\r\n\r\n'
			),
			continue_body: Buffer.from('42')
		})

		assert.equal(response.status, 417)
		assert.deepEqual(response.interim, [])
	})

	await check('compressed request body returns 415', async () => {
		const body = gzipSync(Buffer.from('42'))
		const response = await gateway.raw({
			wire: Buffer.concat([
				Buffer.from(
					`POST /scalar HTTP/1.1\r\nHost: local\r\nContent-Length: ${body.length}\r\nContent-Encoding: gzip\r\n\r\n`
				),
				body
			])
		})

		assert.equal(response.status, 415)
	})

	for (const item of [
		{
			name: 'truncated Content-Length',
			wire: 'POST /scalar HTTP/1.1\r\nHost: local\r\nContent-Length: 10\r\n\r\n42'
		},
		{
			name: 'missing terminal chunk',
			wire: 'POST /scalar HTTP/1.1\r\nHost: local\r\nTransfer-Encoding: chunked\r\n\r\n2\r\n42\r\n'
		},
		{
			name: 'truncated chunk data',
			wire: 'POST /scalar HTTP/1.1\r\nHost: local\r\nTransfer-Encoding: chunked\r\n\r\nA\r\n42'
		},
		{
			name: 'invalid chunk size',
			wire: 'POST /scalar HTTP/1.1\r\nHost: local\r\nTransfer-Encoding: chunked\r\n\r\nNO\r\n42\r\n0\r\n\r\n'
		},
		{
			name: 'conflicting lengths',
			wire: 'POST /scalar HTTP/1.1\r\nHost: local\r\nContent-Length: 0\r\nContent-Length: 2\r\n\r\n42'
		},
		{ name: 'invalid HTTP version', wire: 'GET /void HTTP/9.0\r\nHost: local\r\n\r\n' },
		{ name: 'unknown method', wire: 'BREW /void HTTP/1.1\r\nHost: local\r\n\r\n' },
		{ name: 'header without colon', wire: 'GET /void HTTP/1.1\r\nHost: local\r\nBrokenHeader\r\n\r\n' },
		{ name: 'header name containing space', wire: 'GET /void HTTP/1.1\r\nHost: local\r\nBad Name: x\r\n\r\n' },
		{ name: 'header value containing NUL', wire: 'GET /void HTTP/1.1\r\nHost: local\r\nX-Bad: a\x00b\r\n\r\n' }
	]) {
		await check(`invalid request ${item.name} is rejected`, async () => {
			const response = await gateway.raw({ wire: Buffer.from(item.wire) })

			assert.equal(response.status, 400)
		})
	}

	await check('invalid header rejects request before Store mutation', async () => {
		const before = await gateway.request({ path: '/state' })
		const rejected = await gateway.raw({
			wire: Buffer.from('POST /advance HTTP/1.1\r\nHost: local\r\nBad Name: x\r\nContent-Length: 1\r\n\r\n7')
		})
		const after = await gateway.request({ path: '/state' })

		assert.equal(rejected.status, 400)
		assert.deepEqual(JSON.parse(after.body.toString()), JSON.parse(before.body.toString()))
	})

	await check('legal header token HTAB and nonUTF8 value remain accepted', async () => {
		const response = await gateway.raw({
			wire: Buffer.from('GET /void HTTP/1.1\r\nHost: local\r\nX-Token_1!: a\xff\tb\r\n\r\n', 'latin1')
		})

		assert.equal(response.status, 200)
		assert.equal(response.body.toString(), '7')
	})

	for (const size of [512, 513]) {
		await check(`raw header size boundary ${size}`, async () => {
			const prefix = 'GET /void HTTP/1.1\r\nHost: local\r\nX-Fill: '
			const suffix = '\r\n\r\n'
			const wire = Buffer.from(prefix + 'x'.repeat(size - Buffer.byteLength(prefix + suffix)) + suffix)
			const response = await gateway.raw({ wire })

			assert.equal(response.status, size === 512 ? 200 : 431)
		})
	}

	await check('one connection serves one request despite keep-alive pipeline', async () => {
		const first = 'GET /void HTTP/1.1\r\nHost: local\r\nConnection: keep-alive\r\n\r\n'
		const second = 'GET /void/ HTTP/1.1\r\nHost: local\r\n\r\n'
		const response = await gateway.raw({ wire: Buffer.from(first + second) })

		assert.equal(response.status, 200)
		assert.equal(response.body.toString(), '7')
		assert.equal(response.headers.get('connection'), 'close')
	})

	await check('server recovers after header body and protocol failures', async () => {
		const response = await gateway.request({ path: '/void' })

		assert.equal(response.status, 200)
		assert.equal(response.body.toString(), '7')
	})
}
