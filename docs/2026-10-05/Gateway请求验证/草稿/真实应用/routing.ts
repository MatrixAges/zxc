import type { Check, Gateway } from './types.ts'
import assert from 'node:assert/strict'

export default async function checkRouting(args: { gateway: Gateway; check: Check }) {
	const { gateway, check } = args

	for (const method of ['GET', 'POST']) {
		await check(`nested Group route supports ${method} JSON body`, async () => {
			const input = { message: '中文 🌿', count: 17 }
			const response = await gateway.request({ method, path: '/api/v1/echo', body: JSON.stringify(input) })

			assert.equal(response.status, 200)
			assert.equal(response.headers.get('content-type'), 'application/json')
			assert.deepEqual(JSON.parse(response.body.toString()), input)
		})
	}

	await check('query does not change route or service input', async () => {
		const input = { message: 'query', count: 2 }
		const response = await gateway.request({
			method: 'POST',
			path: '/api/v1/echo?message=forged&count=99',
			body: JSON.stringify(input)
		})

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), input)
	})

	for (const path of ['/missing', '/api/echo', '/api/v1/echo/', '/VOID', '/literal/item', '/literal%2fitem']) {
		await check(`literal route rejects unmatched ${path}`, async () => {
			const response = await gateway.request({ path })

			assert.equal(response.status, 404)
		})
	}

	await check('encoded route remains literal without percent decoding', async () => {
		const response = await gateway.request({ path: '/literal%2Fitem' })

		assert.equal(response.status, 200)
		assert.equal(JSON.parse(response.body.toString()), 7)
	})

	await check('trailing slash identifies a separate void output service', async () => {
		const response = await gateway.request({ path: '/void/' })

		assert.equal(response.status, 200)
		assert.equal(response.body.toString(), 'null')
	})

	await check('method mismatch reports configured Allow set', async () => {
		const response = await gateway.request({ method: 'PUT', path: '/api/v1/echo' })

		assert.equal(response.status, 405)
		assert.deepEqual(new Set(response.headers.get('allow')!.split(/,\s*/)), new Set(['GET', 'POST']))
	})

	await check('HEAD does not implicitly match a GET route', async () => {
		const response = await gateway.request({ method: 'HEAD', path: '/void' })

		assert.equal(response.status, 405)
		assert.equal(response.body.length, 0)
		assert.equal(response.headers.get('allow'), 'GET')
	})

	for (const method of ['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'CONNECT', 'OPTIONS', 'TRACE', 'PATCH']) {
		await check(`route without method handles ${method}`, async () => {
			const response = await gateway.request({ method, path: '/any' })

			assert.equal(response.status, 200)
			if (method === 'HEAD') assert.equal(response.body.length, 0)
			else assert.equal(JSON.parse(response.body.toString()), 7)
		})
	}

	await check('different scalar service retains its own Input type', async () => {
		const response = await gateway.request({ method: 'POST', path: '/scalar', body: '-42' })

		assert.equal(response.status, 200)
		assert.equal(JSON.parse(response.body.toString()), -42)
	})

	await check('HTTP cannot forge server argv environment or cwd', async () => {
		const response = await gateway.request({
			path: '/native?argv=forged&cwd=/fake',
			headers: [['ZXC_GATEWAY_TEST_VALUE', 'forged']]
		})

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), {
			argv: [gateway.executable, ...gateway.argv],
			env: gateway.environment.ZXC_GATEWAY_TEST_VALUE,
			cwd: gateway.cwd
		})
	})

	await check('service error returns generic 500 and server continues', async () => {
		const failed = await gateway.request({ method: 'POST', path: '/error', body: '"BAD=KEY"' })
		const recovered = await gateway.request({ path: '/void' })

		assert.equal(failed.status, 500)
		assert.equal(failed.body.toString(), 'service failed')
		assert.equal(recovered.status, 200)
		assert.equal(JSON.parse(recovered.body.toString()), 7)
	})
}
