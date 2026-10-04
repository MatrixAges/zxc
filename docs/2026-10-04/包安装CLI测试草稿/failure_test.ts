import assert from 'node:assert/strict'
import { existsSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture from './fixture.ts'

type Index = { packages: Array<{ name: string, versions: Array<{ version: string, archive: string, sha256: string }> }> }

for (const sample of [
	{ name: 'outdated frozen lock', requirement: '^2.0.0', frozen: true, error: 'LockFileOutdated' },
	{ name: 'unavailable version', requirement: '^99.0.0', error: 'PackageVersionNotFound' },
	{ name: 'archive checksum mismatch', requirement: '^3.0.0', release: 'checksum', error: 'PackageArchiveChecksumMismatch' },
	{ name: 'archive version identity mismatch', requirement: '^3.0.0', release: 'identity', error: 'PackageArchiveIdentityMismatch' },
]) {
	test(`package install / ${sample.name} preserves previous lock and mapping`, () => {
		const fixture = createFixture()

		try {
			fixture.install()
			const before = fixture.metadata()
			fixture.writeMember('left', sample.requirement)

			if (sample.release) {
				const index: Index = JSON.parse(readFileSync(fixture.index, 'utf8'))
				const entry = index.packages.find(entry => entry.name === 'calc')!
				const release = entry.versions.find(entry => entry.version === '2.0.0')!
				entry.versions.push({ ...release, version: '3.0.0', sha256: sample.release === 'checksum' ? '0'.repeat(64) : release.sha256 })
				writeFileSync(fixture.index, JSON.stringify(index))
			}

			const result = fixture.run(['pkg', 'install', '--index', fixture.index, ...(sample.frozen ? ['--frozen-lockfile'] : [])])
			assert.equal(result.status, 1)
			assert.equal(result.stdout, '')
			assert.equal(result.stderr, `pkg.yaml: install: ${sample.error}\n`)
			assert.deepEqual(fixture.metadata(), before)
			fixture.writeMember('left', '^1.0.0')
			fixture.install(['--offline', '--frozen-lockfile'])
			assert.deepEqual(fixture.metadata(), before)
		} finally {
			fixture.cleanup()
		}
	})
}

test('package install / missing frozen lock creates no lock or mapping', () => {
	const fixture = createFixture()

	try {
		const result = fixture.run(['pkg', 'install', '--index', fixture.index, '--frozen-lockfile'])
		assert.equal(result.status, 1)
		assert.equal(result.stdout, '')
		assert.equal(result.stderr, 'pkg.yaml: install: LockFileMissing\n')
		assert.equal(existsSync(join(fixture.project, 'pkg.lock.json')), false)
		assert.equal(existsSync(join(fixture.project, '.zxc/packages')), false)
	} finally {
		fixture.cleanup()
	}
})
