import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { join } from 'node:path'
import { readdirSync, rmSync } from 'node:fs'
import { test } from 'node:test'
import createFixture from './fixture.ts'

type Lock = { format_version: number, packages: Array<{ name: string, version: string, dependencies: Array<{ name: string, requirement: string, target: number }> }> }

test('package install / highest compatible transitive versions execute and recover frozen offline', () => {
	const fixture = createFixture()

	try {
		fixture.install()
		const before = fixture.metadata()
		const lock: Lock = JSON.parse(before['pkg.lock.json'])
		assert.equal(lock.format_version, 1)
		assert.deepEqual(lock.packages.map(entry => `${entry.name}@${entry.version}`).sort(), ['root@1.0.0', 'left@1.0.0', 'right@1.0.0', 'calc@1.4.0', 'calc@2.0.0', 'core@1.1.0', 'core@2.2.0'].sort())

		for (const [owner, target] of [['left@1.0.0', 'calc@1.4.0'], ['right@1.0.0', 'calc@2.0.0'], ['calc@1.4.0', 'core@1.1.0'], ['calc@2.0.0', 'core@2.2.0']]) {
			const entry = lock.packages.find(entry => `${entry.name}@${entry.version}` === owner)
			assert.ok(entry)
			assert.equal(entry.dependencies.length, 1)
			const dependency = lock.packages[entry.dependencies[0].target]
			assert.equal(`${dependency.name}@${dependency.version}`, target)
		}

		const digest = createHash('sha256').update(before['pkg.lock.json']).digest('hex')
		assert.deepEqual(Object.keys(before).sort(), [digest + '.json', 'pkg.lock.json'].sort())
		fixture.execute('left', 9)
		fixture.execute('right', 24)

		rmSync(fixture.registry, { recursive: true })
		rmSync(join(fixture.project, '.zxc/packages'), { recursive: true })
		rmSync(join(fixture.cache, 'packages/v1/contents'), { recursive: true })
		fixture.install(['--offline', '--frozen-lockfile'])

		assert.deepEqual(fixture.metadata(), before)
		assert.equal(readdirSync(join(fixture.cache, 'packages/v1/contents')).length, 4)
		fixture.execute('left', 9)
		fixture.execute('right', 24)
	} finally {
		fixture.cleanup()
	}
})
