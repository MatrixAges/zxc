import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture from '../../package_install/fixture.ts'

test('real installed lock lint is read-only and every lock fmt mode is rejected', async context => {
	const fixture = createFixture()

	try {
		fixture.install()
		const original = fixture.metadata()
		const lock_path = join(fixture.project, 'pkg.lock.json')
		const lock_bytes = readFileSync(lock_path, 'utf8')
		const custom = 'unformatted-lock.json'
		const custom_bytes = ' \n' + JSON.stringify(JSON.parse(lock_bytes)) + '   '
		writeFileSync(join(fixture.project, custom), custom_bytes)

		for (const file of ['pkg.lock.json', custom]) {
			await context.test(`read-only validation / ${file}`, () => {
				const selection = file === custom ? ['--kind', 'lock'] : []
				const result = fixture.run(['lint', file, ...selection])
				assert.equal(result.status, 0, result.stderr)
				assert.equal(result.stdout, '')
				assert.equal(result.stderr, '')

				for (const mode of [[], ['--check'], ['--write']]) {
					const rejected = fixture.run(['fmt', file, ...selection, ...mode])
					assert.equal(rejected.status, 1, rejected.stderr)
					assert.match(rejected.stderr, /pkg.lock.json is managed by zxc pkg install/)
					assert.equal(rejected.stdout, '')
					assert.deepEqual(fixture.metadata(), original)
					assert.equal(readFileSync(join(fixture.project, custom), 'utf8'), custom_bytes)
				}
			})
		}

		await context.test('invalid lock graph is rejected without changing installed mappings', () => {
			const invalid = JSON.parse(lock_bytes) as { packages: Array<{ dependencies: Array<{ target: number }> }> }
			const owner = invalid.packages.find(package_entry => package_entry.dependencies.length > 0)
			assert.ok(owner)
			owner.dependencies[0].target = invalid.packages.length
			const invalid_bytes = JSON.stringify(invalid)
			writeFileSync(lock_path, invalid_bytes)
			const before = fixture.metadata()

			for (const argv of [
				['lint', 'pkg.lock.json'],
				['fmt', 'pkg.lock.json', '--write']
			]) {
				const result = fixture.run(argv)
				assert.equal(result.status, 1, result.stderr)
				assert.match(result.stderr, /InvalidLockTarget/)
				assert.equal(result.stdout, '')
				assert.deepEqual(fixture.metadata(), before)
			}
			writeFileSync(lock_path, lock_bytes)
		})

		fixture.install(['--offline', '--frozen-lockfile'])
		assert.deepEqual(fixture.metadata(), original)
	} finally {
		fixture.cleanup()
	}
})
