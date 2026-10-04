import assert from 'node:assert/strict'
import { cpSync, existsSync, readFileSync, rmSync, symlinkSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture, { exports_map, program } from './fixture.ts'

type Fixture = ReturnType<typeof createFixture>
type Case = { name: string; change(fixture: Fixture): void; diagnostic: RegExp }

const cases: Array<Case> = [
	{
		name: 'missing artifact never falls back to package sources',
		change(fixture) {
			rmSync(join(fixture.member, 'library.zxcir'))
			fixture.write('pkgs/calc/main.zx', program('in + 999', ''))
		},
		diagnostic: /FileNotFound/
	},
	{
		name: 'payload corruption fails integrity verification',
		change(fixture) {
			const bytes = readFileSync(join(fixture.member, 'library.zxcir'))
			bytes[bytes.length - 1] ^= 1
			fixture.write('pkgs/calc/library.zxcir', bytes)
		},
		diagnostic: /InvalidLibrary/
	},
	{
		name: 'unknown selected public module',
		change(fixture) {
			fixture.manifest({ exports: { '.': { module: 'missing' } } })
		},
		diagnostic: /MissingPublicModule/
	},
	{
		name: 'default import requires explicit default export',
		change(fixture) {
			fixture.manifest({ exports: { './nested/beta': { module: 'beta' } } })
		},
		diagnostic: /ZX package is not declared in the project dependencies/
	},
	{
		name: 'artifact symlink cannot escape the package physical path',
		change(fixture) {
			cpSync(join(fixture.member, 'library.zxcir'), join(fixture.root, 'outside.zxcir'))
			rmSync(join(fixture.member, 'library.zxcir'))
			symlinkSync(join(fixture.root, 'outside.zxcir'), join(fixture.member, 'library.zxcir'), 'file')
		},
		diagnostic: /PackageSourceMustUsePhysicalPath/
	},
	{
		name: 'library path cannot escape with parent segment',
		change(fixture) {
			fixture.manifest({ library: '../outside.zxcir', exports: exports_map })
		},
		diagnostic: /library must be a package-relative artifact path/
	},
	{
		name: 'library requires explicit exports',
		change(fixture) {
			fixture.manifest({})
		},
		diagnostic: /library requires exports and cannot use entry/
	},
	{
		name: 'compiled library cannot use source export paths',
		change(fixture) {
			fixture.manifest({ exports: { '.': 'main.zx' } })
		},
		diagnostic: /library exports require module selections/
	},
	{
		name: 'source package cannot select compiled public modules',
		change(fixture) {
			fixture.manifest({ library: undefined, exports: exports_map })
		},
		diagnostic: /source packages require implementation paths/
	}
]

for (const entry of cases) {
	test(`compiled package rejects ${entry.name}`, () => {
		const fixture = createFixture()

		try {
			entry.change(fixture)
			const result = fixture.build()
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, entry.diagnostic)
			assert.equal(existsSync(fixture.application), false)
		} finally {
			fixture.cleanup()
		}
	})
}
