import { spawn, spawnSync } from 'node:child_process'
import { createConnection, createServer } from 'node:net'
import assert from 'node:assert/strict'
import { cpSync, mkdirSync, mkdtempSync, readFileSync, realpathSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import exchange from './request.ts'

export default function createApplication(args: { compiler: string; source: string; optimize: string }) {
	const { compiler, source, optimize } = args
	const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-gateway-')))
	const project = join(root, 'project')
	const cwd = join(root, 'runtime 目录')
	const environment = { ...process.env, ZXC_GATEWAY_TEST_VALUE: 'server value 🌿' }
	const argv = ['literal server argument', '--not-http-input']

	cpSync(source, project, { recursive: true })
	mkdirSync(cwd)

	async function start(entry = 'main.gateway.rx') {
		const reservation = createServer()

		await new Promise<void>((resolve, reject) => {
			reservation.once('error', reject)
			reservation.listen(0, '127.0.0.1', resolve)
		})

		const address = reservation.address()

		assert.ok(address && typeof address !== 'string')

		const port = address.port
		const path = join(project, entry)
		const template = readFileSync(join(source, entry), 'utf8')
		const executable = join(root, `${entry}-${port}${process.platform === 'win32' ? '.exe' : ''}`)

		try {
			writeFileSync(path, template.replace('127.0.0.1:0', `127.0.0.1:${port}`))

			const built = spawnSync(compiler, ['build', path, '--out', executable, '--optimize', optimize], {
				cwd: project,
				timeout: 180_000,
				encoding: 'utf8'
			})

			assert.ifError(built.error)
			assert.equal(built.signal, null, built.stderr)
			assert.equal(built.status, 0, built.stderr)
		} finally {
			await new Promise<void>((resolve, reject) =>
				reservation.close(error => (error ? reject(error) : resolve()))
			)
		}

		const child = spawn(executable, argv, { cwd, env: environment, stdio: ['ignore', 'pipe', 'pipe'] })
		const output: Array<Buffer> = []
		const errors: Array<Buffer> = []
		let finished = false
		const closed = new Promise<void>((resolve, reject) => {
			child.on('error', reject)
			child.on('close', () => {
				finished = true
				resolve()
			})
		})

		child.stdout.on('data', (data: Buffer) => output.push(data))
		child.stderr.on('data', (data: Buffer) => errors.push(data))

		try {
			const deadline = Date.now() + 15_000

			while (true) {
				assert.equal(finished, false, Buffer.concat(errors).toString())

				const ready = await new Promise<boolean>((resolve, reject) => {
					const socket = createConnection({ host: '127.0.0.1', port })

					socket.on('connect', () => {
						socket.end()
						resolve(true)
					})
					socket.on('error', (error: NodeJS.ErrnoException) =>
						error.code === 'ECONNREFUSED' ? resolve(false) : reject(error)
					)
				})

				if (ready) break

				assert.ok(Date.now() < deadline, 'Gateway startup timed out')
				await new Promise(resolve => setTimeout(resolve, 25))
			}
		} catch (error) {
			child.kill()
			await closed

			throw error
		}

		return {
			port,
			executable,
			argv,
			cwd,
			environment,
			raw(args: { wire: Buffer; head?: boolean; continue_body?: Buffer }) {
				return exchange({ port, ...args })
			},
			request(args: { path: string; method?: string; body?: string; headers?: Array<[string, string]> }) {
				const { path, method = 'GET', body = '', headers = [] } = args
				const text = `${method} ${path} HTTP/1.1\r\nHost: 127.0.0.1\r\nContent-Length: ${Buffer.byteLength(body)}\r\n${headers.map(([name, value]) => `${name}: ${value}\r\n`).join('')}\r\n${body}`

				return exchange({ port, wire: Buffer.from(text), head: method === 'HEAD' })
			},
			stderr() {
				return Buffer.concat(errors).toString()
			},
			stdout() {
				return Buffer.concat(output).toString()
			},
			async stop() {
				if (!finished) child.kill()
				await closed
			}
		}
	}

	return {
		start,
		close() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
