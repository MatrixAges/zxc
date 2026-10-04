import type { ServerResponse } from 'node:http'
import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { once } from 'node:events'
import { existsSync, mkdtempSync, readFileSync, rmSync } from 'node:fs'
import { createServer } from 'node:http'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { test } from 'node:test'
import runDriver from './run_driver.ts'

const archive = readFileSync(new URL('../../package_archive/fixtures/valid.tgz', import.meta.url))
const digest = createHash('sha256').update(archive).digest('hex')

for (const sample of [
	{ name: 'oversized', status: 200, headers: { 'Content-Length': String(128 * 1024 * 1024 + 1) }, error: 'PackageArchiveTooLarge' },
	{ name: 'unavailable', status: 503, headers: { 'Content-Length': '100' }, error: 'PackageDownloadFailed' },
]) {
	test(`package HTTP / rejects ${sample.name} headers before peer finishes body`, async () => {
		const root = mkdtempSync(join(tmpdir(), 'zxc-package-rejection-'))
		const cache = join(root, 'cache')
		let pending: ServerResponse | undefined
		const received = Promise.withResolvers<void>()
		const server = createServer((request, response) => {
			pending = response
			response.writeHead(sample.status, sample.headers)
			response.flushHeaders()
			received.resolve()
		})
		server.listen(0, '127.0.0.1')
		await once(server, 'listening')
		const address = server.address()
		assert.ok(address !== null && typeof address !== 'string')
		const result = runDriver({ source: `http://127.0.0.1:${address.port}/pending`, sha256: digest, cache })
		let timer: ReturnType<typeof setTimeout> | undefined

		try {
			await Promise.race([received.promise, result.then(() => { throw new Error('driver exited before requesting headers') })])
			const completed_before_release = await Promise.race([
				result.then(() => true),
				new Promise<boolean>(resolve => { timer = setTimeout(() => resolve(false), 3000) }),
			])
			clearTimeout(timer)
			pending?.destroy()
			const actual = await result

			assert.equal(actual.status, 1, actual.error)
			assert.equal(actual.output, `error:${sample.error}`)
			assert.equal(actual.error, '')
			assert.equal(existsSync(cache), false)
			assert.equal(completed_before_release, true, 'header rejection waited for server body completion')
		} finally {
			clearTimeout(timer)
			pending?.destroy()
			await result
			server.closeAllConnections()
			await new Promise<void>((resolve, reject) => server.close(error => error ? reject(error) : resolve()))
			rmSync(root, { recursive: true, force: true })
		}
	})
}
