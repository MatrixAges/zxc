import { createConnection } from 'node:net'
import assert from 'node:assert/strict'

export type Response = {
	status: number
	headers: Map<string, string>
	body: Buffer
	interim: Array<number>
	raw: Buffer
}

export default async function exchange(args: {
	port: number
	wire: Buffer
	head?: boolean
	continue_body?: Buffer
}): Promise<Response> {
	const { port, wire, head = false, continue_body } = args
	const raw = await new Promise<Buffer>((resolve, reject) => {
		const socket = createConnection({ host: '127.0.0.1', port })
		const chunks: Array<Buffer> = []
		let continued = false
		const timer = setTimeout(() => {
			socket.destroy()
			reject(new Error('Gateway request timed out'))
		}, 10_000)

		socket.on('connect', () => (continue_body ? socket.write(wire) : socket.end(wire)))
		socket.on('data', (data: Buffer) => {
			chunks.push(data)

			if (continue_body && !continued && Buffer.concat(chunks).includes('100 Continue\r\n\r\n')) {
				continued = true
				socket.end(continue_body)
			}
		})
		socket.on('error', error => {
			clearTimeout(timer)
			reject(error)
		})
		socket.on('close', () => {
			clearTimeout(timer)
			resolve(Buffer.concat(chunks))
		})
	})
	const interim: Array<number> = []
	let offset = 0

	while (true) {
		const boundary = raw.indexOf('\r\n\r\n', offset)

		assert.ok(boundary >= 0, raw.toString())

		const lines = raw.subarray(offset, boundary).toString('latin1').split('\r\n')
		const status = Number(lines[0].split(' ')[1])
		const headers = new Map(
			lines.slice(1).map(line => {
				const colon = line.indexOf(':')

				return [line.slice(0, colon).toLowerCase(), line.slice(colon + 1).trim()] as const
			})
		)

		offset = boundary + 4

		if (status >= 100 && status < 200) {
			interim.push(status)

			continue
		}

		const body = raw.subarray(offset)

		if (head) assert.equal(body.length, 0)
		else assert.equal(body.length, Number(headers.get('content-length')), raw.toString())

		return { status, headers, body, interim, raw }
	}
}
