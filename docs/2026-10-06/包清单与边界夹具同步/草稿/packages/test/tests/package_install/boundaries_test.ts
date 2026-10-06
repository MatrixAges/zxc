import assert from 'node:assert/strict'
import { existsSync, realpathSync, writeFileSync } from 'node:fs'
import { join, relative } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import createFixture from './fixture.ts'
import { source } from './registry.ts'

for (const sample of [
	{
		name: 'transitive dependency is not a direct dependency',
		import: 'core',
		entry: 'apps/left/main.zx',
		diagnostic: 'ZX package is not declared in the project dependencies'
	},
	{
		name: 'workspace root does not inherit member dependencies',
		import: 'calc',
		entry: 'main.zx',
		diagnostic: 'ZX package is not declared in the project dependencies'
	},
	{
		name: 'relative import cannot cross workspace members',
		import: '../right/main',
		entry: 'apps/left/main.zx',
		diagnostic: 'file import crosses a package boundary; declare and import the package dependency'
	},
	{
		name: 'relative import cannot bypass installed archive boundary',
		import: null,
		entry: 'apps/left/main.zx',
		diagnostic: 'file import crosses a package boundary; declare and import the package dependency'
	}
]) {
	test(`installed package scopes / ${sample.name}`, () => {
		const fixture = createFixture()

		try {
			fixture.install()
			const before = fixture.metadata()
			const mapping: { paths: Array<string> } = JSON.parse(
				Object.entries(before).find(([name]) => name !== 'pkg.lock.json')![1]
			)
			const lock: { packages: Array<{ name: string; version: string }> } = JSON.parse(before['pkg.lock.json'])
			const target = lock.packages.findIndex(entry => entry.name === 'core' && entry.version === '1.1.0')
			assert.ok(target >= 0)
			const specifier =
				sample.import ??
				relative(
					realpathSync(join(fixture.project, 'apps/left')),
					join(mapping.paths[target], 'main')
				).replaceAll('\\', '/')
			writeFileSync(join(fixture.project, sample.entry), source(0, specifier))
			const output = join(fixture.root, 'rejected-app')
			const result = fixture.run(['build', sample.entry, '--mode', 'app', '--out', output])

			assert.equal(result.status, 1, result.stderr)
			assert.ok(result.stderr.includes(sample.diagnostic), result.stderr)
			assert.equal(existsSync(output), false)
			assert.deepEqual(fixture.metadata(), before)
		} finally {
			fixture.cleanup()
		}
	})
}

test('installed package scopes / explicit direct dependency grants access', () => {
	const fixture = createFixture()

	try {
		writeFileSync(
			join(fixture.project, 'apps/left/pkg.yaml'),
			stringify({
				name: 'left',
				version: '1.0.0',
				entry: 'main.zx',
				dependencies: { calc: '^1.0.0', core: '^1.0.0' }
			})
		)
		writeFileSync(join(fixture.project, 'apps/left/main.zx'), source(0, 'core'))
		fixture.install()
		fixture.execute('left', 2)
	} finally {
		fixture.cleanup()
	}
})

test('installed package scopes / root alias remains relative to the importing member', () => {
	const fixture = createFixture()

	try {
		fixture.install()
		writeFileSync(join(fixture.project, 'helper.zx'), source(1000))
		writeFileSync(join(fixture.project, 'apps/left/helper.zx'), source(40))
		writeFileSync(
			join(fixture.project, 'apps/left/main.zx'),
			source(0, 'calc')
				.replace('\n\nexport type Input', '\n\nimport local from "@/helper"\n\nexport type Input')
				.replace('return dependency(in)', 'return local(dependency(in))')
		)
		fixture.execute('left', 49)
	} finally {
		fixture.cleanup()
	}
})
