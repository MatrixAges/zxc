import assert from 'node:assert/strict'
import { resolve } from 'node:path'
import createApplication from './application.ts'
import checkRouting from './routing.ts'
import checkState from './state.ts'
import checkBody from './body.ts'

const application = createApplication({
	compiler: resolve(process.argv[2]),
	source: resolve(process.argv[3]),
	optimize: process.argv[4]
})
let gateway: Awaited<ReturnType<typeof application.start>> | undefined

let checks = 0

async function check(name: string, body: () => Promise<void>) {
	await body()
	checks += 1
	console.log(`ok ${checks}: ${name}`)
}

try {
	gateway = await application.start()
	await checkRouting({ gateway, check })
	await checkState({ gateway, check })
	await checkBody({ gateway, check })
	assert.ok(gateway.stderr().includes('InvalidEnvironmentKey'))
	assert.ok(gateway.stderr().includes('IndexOutOfBounds'))
	assert.equal(gateway.stdout(), '')
	await gateway.stop()
	gateway = await application.start('empty.gateway.rx')

	for (const path of ['/', '/missing']) {
		await check(`empty Gateway responds 404 at ${path}`, async () => {
			const response = await gateway!.request({ path })

			assert.equal(response.status, 404)
		})
	}

	await check('empty Gateway rejects malformed headers before route lookup', async () => {
		const response = await gateway!.raw({
			wire: Buffer.from('GET /missing HTTP/1.1\r\nHost: local\r\nBrokenHeader\r\n\r\n')
		})

		assert.equal(response.status, 400)
	})

	await gateway.stop()
	gateway = await application.start('zero.gateway.rx')

	await check('zero body limit accepts empty void request', async () => {
		const response = await gateway!.request({ path: '/' })

		assert.equal(response.status, 200)
		assert.equal(response.body.toString(), '7')
	})

	await check('zero body limit rejects one declared byte', async () => {
		const response = await gateway!.request({ path: '/', body: 'x' })

		assert.equal(response.status, 413)
	})

	await check('zero body limit rejects one chunked byte', async () => {
		const response = await gateway!.raw({
			wire: Buffer.from('POST / HTTP/1.1\r\nHost: local\r\nTransfer-Encoding: chunked\r\n\r\n1\r\nx\r\n0\r\n\r\n')
		})

		assert.equal(response.status, 413)
	})

	await gateway.stop()
	gateway = await application.start()

	await check('new server process starts from Store initializers', async () => {
		const response = await gateway!.request({ path: '/state' })

		assert.equal(response.status, 200)
		assert.deepEqual(JSON.parse(response.body.toString()), {
			primary: { value: 3, history: [8], label: 'seed' },
			secondary: { value: 100, history: [80], label: 'other' }
		})
	})

	console.log(`Gateway applications: ${checks} checks passed`)
} finally {
	await gateway?.stop()
	application.close()
}
