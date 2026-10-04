import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { existsSync, mkdtempSync, readFileSync, readdirSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { test } from 'node:test'
import runDriver from './run_driver.ts'
import startServer from './server.ts'

const archive = readFileSync(new URL('../../package_archive/fixtures/valid.tgz', import.meta.url))
const digest = createHash('sha256').update(archive).digest('hex')
const corrupted = Buffer.from(archive)
corrupted[corrupted.length - 8] ^= 1

const cases = [
	{ name: 'direct response', path: '/direct', requests: 1 },
	{ name: 'chunked response', path: '/streamed', requests: 1 },
	{ name: 'relative redirect', path: '/redirect/1', requests: 2 },
	{ name: 'three redirects', path: '/redirect/3', requests: 4 },
	{ name: 'four redirects rejected', path: '/redirect/4', requests: 4, error: 'TooManyHttpRedirects' },
	{ name: 'redirect loop rejected', path: '/loop', requests: 4, error: 'TooManyHttpRedirects' },
	{ name: '404 rejected', path: '/status/404', requests: 1, error: 'PackageDownloadFailed' },
	{ name: '500 rejected', path: '/status/500', requests: 1, error: 'PackageDownloadFailed' },
	{ name: '204 rejected', path: '/status/204', requests: 1, error: 'PackageDownloadFailed' },
	{ name: 'content encoding rejected', path: '/encoded', requests: 1, error: 'UnsupportedPackageContentEncoding' },
	{ name: 'declared oversized body rejected', path: '/oversized', requests: 1, error: 'PackageArchiveTooLarge' },
	{ name: 'downloaded gzip CRC rejected', path: '/direct', requests: 1, error: 'InvalidPackageGzipChecksum', digest: createHash('sha256').update(corrupted).digest('hex'), content: corrupted },
	{ name: 'download SHA mismatch rejected', path: '/direct', requests: 1, error: 'PackageArchiveChecksumMismatch', digest: '0'.repeat(64) },
]

for (const sample of cases) {
	test(`package HTTP / ${sample.name}`, async () => {
		const root = mkdtempSync(join(tmpdir(), 'zxc-package-http-'))
		const cache = join(root, 'cache')
		const server = await startServer(sample.content ?? archive)

		try {
			const result = await runDriver({ source: server.url + sample.path, sha256: sample.digest ?? digest, cache })
			assert.equal(result.error, '')
			assert.equal(result.status, sample.error ? 1 : 0, result.output)
			assert.equal(server.requests.length, sample.requests)
			assert.ok(server.requests.every(request => request.encoding === 'identity'))

			if (sample.error) {
				assert.equal(result.output, `error:${sample.error}`)
				if (sample.content) assert.deepEqual(readdirSync(join(cache, 'packages/v1/contents')), [])
				else assert.equal(existsSync(cache), false)
			} else {
				assert.equal(result.output, join(cache, 'packages/v1/contents', digest, 'package'))
				assert.equal(readFileSync(join(result.output, 'src/main.zx'), 'utf8'), 'export const value = 7\n')
				assert.deepEqual(readdirSync(join(cache, 'packages/v1/contents')), [digest])
				const offline = await runDriver({ source: server.url + '/status/500', sha256: digest, cache, offline: true })
				assert.equal(offline.status, 0, offline.output)
				assert.equal(offline.output, result.output)
				assert.equal(server.requests.length, sample.requests)
			}
		} finally {
			await server.close()
			rmSync(root, { recursive: true, force: true })
		}
	})
}
