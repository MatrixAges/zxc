import type { Socket } from 'node:net'
import { createServer } from 'node:net'
import assert from 'node:assert/strict'

export type Request = {
	method: string
	target: string
	headers: Array<{ name: string; value: Buffer }>
	body: Buffer
}

export default async function createFixtureServer() {
	const sockets = new Set<Socket>()
	const requests: Array<Request> = []
	let response = Buffer.from('HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n')
	const server = createServer(socket => {
		sockets.add(socket)
		socket.on('close', () => sockets.delete(socket))
		socket.on('error', () => {})
		let data = Buffer.alloc(0)
		let answered = false

		socket.on('data', chunk => {
			if (answered) return

			data = Buffer.concat([data, chunk])
			const boundary = data.indexOf('\r\n\r\n')

			if (boundary < 0) return

			const lines = data.subarray(0, boundary).toString('latin1').split('\r\n')
			const [method, target] = lines[0].split(' ')
			const headers = lines.slice(1).map(line => {
				const colon = line.indexOf(':')

				assert.ok(colon > 0)

				return {
					name: line.slice(0, colon),
					value: Buffer.from(line.slice(colon + 1).replace(/^[ \t]+|[ \t]+$/g, ''), 'latin1')
				}
			})
			const length_header = headers.find(header => header.name.toLowerCase() === 'content-length')
			const length = length_header ? Number(length_header.value.toString()) : 0

			if (data.length < boundary + 4 + length) return

			answered = true
			requests.push({
				method,
				target,
				headers,
				body: Buffer.from(data.subarray(boundary + 4, boundary + 4 + length))
			})
			socket.end(response)
		})
	})

	await new Promise<void>((resolve, reject) => {
		server.once('error', reject)
		server.listen(0, '127.0.0.1', resolve)
	})

	const address = server.address()

	assert.ok(address && typeof address !== 'string')

	return {
		url: `http://127.0.0.1:${address.port}`,
		requests,
		respond(bytes: Buffer) {
			response = bytes
		},
		async close() {
			for (const socket of sockets) socket.destroy()

			await new Promise<void>((resolve, reject) => server.close(error => (error ? reject(error) : resolve())))
		}
	}
}
