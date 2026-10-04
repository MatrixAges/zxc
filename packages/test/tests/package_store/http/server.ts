import type { ServerResponse } from 'node:http'
import { createServer } from 'node:http'
import { once } from 'node:events'

export default async function startServer(archive: Buffer, participants = 1) {
	const waiting: Array<ServerResponse> = []
	const requests: Array<{ path: string, encoding: string | undefined }> = []
	const server = createServer((request, response) => {
		const path = request.url ?? '/'
		requests.push({ path, encoding: request.headers['accept-encoding'] })

		if (path === '/barrier') {
			waiting.push(response)
			if (waiting.length === participants) {
				for (const pending of waiting) {
					pending.writeHead(200, { 'Content-Length': archive.length })
					pending.end(archive)
				}
			}
		} else if (path.startsWith('/redirect/')) {
			const remaining = Number(path.split('/').at(-1))
			response.writeHead(302, { Location: remaining === 1 ? '/direct' : `/redirect/${remaining - 1}` })
			response.end()
		} else if (path === '/loop') {
			response.writeHead(307, { Location: '/loop' })
			response.end()
		} else if (path.startsWith('/status/')) {
			response.writeHead(Number(path.split('/').at(-1)))
			response.end('unavailable')
		} else if (path === '/encoded') {
			response.writeHead(200, { 'Content-Encoding': 'gzip' })
			response.end(archive)
		} else if (path === '/oversized') {
			response.writeHead(200, { 'Content-Length': 128 * 1024 * 1024 + 1 })
			response.end()
		} else if (path === '/streamed') {
			response.writeHead(200)
			response.write(archive.subarray(0, 17))
			response.end(archive.subarray(17))
		} else {
			response.writeHead(200, { 'Content-Length': archive.length })
			response.end(archive)
		}
	})

	server.listen(0, '127.0.0.1')
	await once(server, 'listening')
	const address = server.address()
	if (address === null || typeof address === 'string') throw new Error('missing local HTTP port')

	return {
		url: `http://127.0.0.1:${address.port}`,
		requests,
		async close(): Promise<void> {
			server.closeAllConnections()
			await new Promise<void>((resolve, reject) => server.close(error => error ? reject(error) : resolve()))
		},
	}
}
