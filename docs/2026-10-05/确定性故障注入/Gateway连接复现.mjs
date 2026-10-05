import { createConnection } from 'node:net'
import { fileURLToPath } from 'node:url'
import createApplication from '../../../packages/test/tests/runtime/gateway/application.ts'

const application = createApplication({
	compiler: process.argv[2],
	source: fileURLToPath(new URL('../../../packages/test/tests/runtime/gateway/fixtures', import.meta.url)),
	optimize: 'debug'
})
const gateway = await application.start()
const results = []

try {
	for (let index = 0; index < 100; index += 1) {
		const size = index % 2 === 0 ? 512 : 513
		const prefix = 'GET /void HTTP/1.1\r\nHost: local\r\nX-Fill: '
		const suffix = '\r\n\r\n'
		const wire = Buffer.from(prefix + 'x'.repeat(size - Buffer.byteLength(prefix + suffix)) + suffix)
		const result = await new Promise(resolve => {
			const chunks = []
			let failure = null
			const socket = createConnection({ host: '127.0.0.1', port: gateway.port })
			const timer = setTimeout(() => socket.destroy(new Error('timeout')), 10000)

			socket.on('connect', () => socket.end(wire))
			socket.on('data', data => chunks.push(data))
			socket.on('error', error => {
				failure = error.code ?? error.message
			})
			socket.on('close', () => {
				clearTimeout(timer)
				resolve({ size, failure, response: Buffer.concat(chunks).toString() })
			})
		})

		results.push(result)
	}

	console.log(JSON.stringify(results, null, 2))
} finally {
	await gateway.stop()
	application.close()
}
