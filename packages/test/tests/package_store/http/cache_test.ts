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

test('package HTTP / offline miss never requests an available archive', async () => {
	const root = mkdtempSync(join(tmpdir(), 'zxc-package-offline-'))
	const server = await startServer(archive)

	try {
		const cache = join(root, 'cache')
		const result = await runDriver({ source: server.url + '/direct', sha256: digest, cache, offline: true })
		assert.equal(result.status, 1)
		assert.equal(result.output, 'error:PackageNotCached')
		assert.equal(result.error, '')
		assert.equal(server.requests.length, 0)
		assert.equal(existsSync(cache), false)
	} finally {
		await server.close()
		rmSync(root, { recursive: true, force: true })
	}
})

test('package HTTP / four cold writers publish one verified cache and reuse it offline', async () => {
	const root = mkdtempSync(join(tmpdir(), 'zxc-package-concurrent-'))
	const server = await startServer(archive, 4)
	const cache = join(root, 'cache')
	const expected = join(cache, 'packages/v1/contents', digest, 'package')

	try {
		for (const offline of [false, true]) {
			const results = await Promise.allSettled(Array.from({ length: 4 }, () => runDriver({ source: server.url + '/barrier', sha256: digest, cache, offline })))

			for (const result of results) {
				if (result.status === 'rejected') throw result.reason
				assert.equal(result.value.status, 0, result.value.error + result.value.output)
				assert.equal(result.value.output, expected)
				assert.equal(result.value.error, '')
			}

			assert.equal(server.requests.length, 4)
			assert.ok(server.requests.every(request => request.encoding === 'identity'))
			assert.deepEqual(readdirSync(join(cache, 'packages/v1/contents')), [digest])
			assert.deepEqual(readdirSync(join(cache, 'packages/v1/archives')), [digest + '.tar.gz'])
			assert.deepEqual(readFileSync(join(cache, 'packages/v1/archives', digest + '.tar.gz')), archive)
			assert.equal(readFileSync(join(expected, 'src/main.zx'), 'utf8'), 'export const value = 7\n')
		}
	} finally {
		await server.close()
		rmSync(root, { recursive: true, force: true })
	}
})
