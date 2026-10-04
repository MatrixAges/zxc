import assert from 'node:assert/strict'
import { cpSync, existsSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import { parse } from 'yaml'
import createFixture, { public_exports, snapshot, solver, zig } from './fixture.ts'

type Metadata = {
	format_version: number
	library: string
	public_modules: Array<{ name: string; path: string; dependencies: Array<string> }>
}
type Manifest = {
	library: string
	entry?: string
	exports: Record<string, { module: string }>
	dependencies?: unknown
	workspace?: unknown
}

test('published unified package relocates and executes through independent ZX and Zig consumers', () => {
	const fixture = createFixture()

	try {
		const published = fixture.publish()
		assert.equal(published.status, 0, published.stderr)
		const files = snapshot(fixture.published)
		const metadata = JSON.parse(readFileSync(join(fixture.published, 'library.json'), 'utf8')) as Metadata
		const manifest = parse(readFileSync(join(fixture.published, 'pkg.yaml'), 'utf8')) as Manifest
		assert.equal(metadata.format_version, 2)
		assert.equal(metadata.library, 'library.zxcir')
		assert.deepEqual(metadata.public_modules.map(module => module.name).sort(), Object.keys(public_exports).sort())
		assert.equal(manifest.library, 'library.zxcir')
		assert.equal(manifest.entry, undefined)
		assert.equal(manifest.dependencies, undefined)
		assert.equal(manifest.workspace, undefined)
		assert.deepEqual(
			manifest.exports,
			Object.fromEntries(Object.keys(public_exports).map(name => [name, { module: name }]))
		)
		assert.equal(
			Object.keys(files).some(name => /\.(zx|rx)$/.test(name)),
			false
		)

		for (const module of metadata.public_modules) {
			assert.match(module.path, /^public\/public_[0-9a-f]{64}\.zig$/)
			assert.ok(module.path in files)
		}

		const consumer = fixture.consumer()
		assert.equal(existsSync(fixture.source), false)
		assert.equal(existsSync(fixture.published), false)
		const application = join(consumer, process.platform === 'win32' ? 'application.exe' : 'application')
		const built = fixture.run({
			cwd: consumer,
			argv: ['build', 'main.zx', '--mode', 'app', '--out', application, '--solver', solver]
		})
		assert.equal(built.status, 0, built.stderr)

		for (const value of [0, 1, 127, 255]) {
			for (const enabled of [false, true]) {
				const result = fixture.run({
					command: application,
					cwd: consumer,
					argv: [JSON.stringify({ value, enabled })]
				})
				assert.equal(result.status, 0, result.stderr)
				assert.deepEqual(JSON.parse(result.stdout), { value, enabled: !enabled })
			}
		}

		const zig_consumer = join(fixture.root, 'zig_consumer')
		cpSync(new URL('fixtures/zig', import.meta.url), zig_consumer, { recursive: true })
		const direct = fixture.run({ command: zig, cwd: zig_consumer, argv: ['build', '--summary', 'all'] })
		assert.equal(direct.status, 0, direct.stderr)
		assert.match(direct.stderr, /3\/3 tests passed/)
	} finally {
		fixture.cleanup()
	}
})

test('type-only publication validates its interface without invoking an executable solver', () => {
	const fixture = createFixture()

	try {
		fixture.manifest({ './types': 'types.zx' })
		writeFileSync(join(fixture.source, 'unreachable.zx'), 'invalid source')
		const result = fixture.publish(join(fixture.root, 'absent-solver'))
		assert.equal(result.status, 0, result.stderr)
		const metadata = JSON.parse(readFileSync(join(fixture.published, 'library.json'), 'utf8')) as Metadata
		assert.deepEqual(
			metadata.public_modules.map(module => module.name),
			['./types']
		)
		assert.ok(readFileSync(join(fixture.published, 'library.zxcir')).length > 0)
	} finally {
		fixture.cleanup()
	}
})
