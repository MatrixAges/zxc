import assert from 'node:assert/strict'
import { existsSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture from './fixture.ts'
import { source } from './registry.ts'

for (const mutation of ['content', 'mapping'] as const) {
	test(`installed package integrity / ${mutation} corruption rejects compilation and recovers`, () => {
		const fixture = createFixture()

		try {
			fixture.install()
			const before = fixture.metadata()
			const mapping_name = Object.keys(before).find(name => name !== 'pkg.lock.json')!
			const mapping: { paths: Array<string> } = JSON.parse(before[mapping_name])
			const lock: { packages: Array<{ name: string, version: string }> } = JSON.parse(before['pkg.lock.json'])
			const left = lock.packages.findIndex(entry => entry.name === 'calc' && entry.version === '1.4.0')
			const right = lock.packages.findIndex(entry => entry.name === 'calc' && entry.version === '2.0.0')
			assert.ok(left >= 0 && right >= 0)
			const target = mutation === 'content' ? join(mapping.paths[left], 'main.zx') : join(fixture.project, '.zxc/packages', mapping_name)
			const original = readFileSync(target)

			if (mutation === 'content') writeFileSync(target, source(999))
			else {
				mapping.paths[left] = mapping.paths[right]
				writeFileSync(target, JSON.stringify(mapping))
			}

			const output = join(fixture.root, 'corrupt-app')
			const result = fixture.run(['build', 'apps/left/main.zx', '--mode', 'app', '--out', output])
			assert.equal(result.status, 1, result.stderr)
			assert.ok(result.stderr.includes(mutation === 'content' ? 'CorruptPackageStore' : 'InvalidPackageInstallation'), result.stderr)
			assert.equal(existsSync(output), false)
			writeFileSync(target, original)
			assert.deepEqual(fixture.metadata(), before)
			fixture.execute('left', 9)
		} finally {
			fixture.cleanup()
		}
	})
}
