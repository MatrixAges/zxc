import assert from 'node:assert/strict'
import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { parse, stringify } from 'yaml'
import createFixture, { snapshot, solver, zig } from './fixture.ts'

type Case = {
	name: string
	input: string
	config: Record<string, unknown>
	kind: 'u8' | 'bool'
	public_name: 'library' | '.'
}
type Metadata = { format_version: number; public_modules: Array<{ name: string; path: string }> }

const inputs = resolve(process.argv[4])
const cases: Array<Case> = [
	{ name: 'ZX file without entry declaration', input: 'identity.zx', config: {}, kind: 'u8', public_name: 'library' },
	{
		name: 'RX file overrides a different manifest entry',
		input: 'main.rx',
		config: { entry: 'identity.zx' },
		kind: 'bool',
		public_name: 'library'
	},
	{
		name: 'ZX manifest entry',
		input: 'pkg.yaml',
		config: { entry: 'identity.zx' },
		kind: 'u8',
		public_name: 'library'
	},
	{
		name: 'RX manifest entry',
		input: 'pkg.yaml',
		config: { entry: 'main.rx' },
		kind: 'bool',
		public_name: 'library'
	},
	{
		name: 'explicit default exports retains its public name',
		input: 'pkg.yaml',
		config: { exports: { '.': 'identity.zx' } },
		kind: 'u8',
		public_name: '.'
	}
]

for (const entry of cases) {
	test(`unified entry publication / ${entry.name}`, () => {
		const fixture = createFixture()

		try {
			cpSync(join(inputs, 'flow.rx'), join(fixture.source, 'main.rx'))
			writeFileSync(
				join(fixture.source, 'pkg.yaml'),
				stringify({ name: 'bundle', version: '1.0.0', ...entry.config })
			)
			const published = fixture.run({
				argv: ['build', entry.input, '--mode', 'lib', '--out', fixture.published, '--solver', solver]
			})
			assert.equal(published.status, 0, published.stderr)
			const metadata = JSON.parse(readFileSync(join(fixture.published, 'library.json'), 'utf8')) as Metadata
			const manifest = parse(readFileSync(join(fixture.published, 'pkg.yaml'), 'utf8')) as {
				entry?: string
				library: string
				exports: unknown
			}
			assert.equal(metadata.format_version, 2)
			assert.equal(metadata.public_modules.length, 1)
			assert.equal(metadata.public_modules[0].name, entry.public_name)
			if (entry.public_name === 'library') assert.equal(metadata.public_modules[0].path, 'root.zig')
			else assert.match(metadata.public_modules[0].path, /^public\/public_[0-9a-f]{64}\.zig$/)
			assert.equal(manifest.entry, undefined)
			assert.equal(manifest.library, 'library.zxcir')
			assert.deepEqual(manifest.exports, { '.': { module: '.' } })
			assert.equal(
				Object.keys(snapshot(fixture.published)).some(path => /\.(zx|rx)$/.test(path)),
				false
			)

			const consumer = join(fixture.root, 'consumer')
			mkdirSync(join(consumer, 'pkgs'), { recursive: true })
			cpSync(fixture.published, join(consumer, 'pkgs/bundle'), { recursive: true })
			cpSync(join(inputs, entry.kind + '.zx'), join(consumer, 'main.zx'))
			writeFileSync(
				join(consumer, 'pkg.yaml'),
				stringify({
					name: 'consumer',
					version: '1.0.0',
					workspace: { packages: ['pkgs/*'] },
					dependencies: { bundle: 'workspace:*' }
				})
			)
			rmSync(fixture.source, { recursive: true })
			rmSync(fixture.published, { recursive: true })
			assert.equal(existsSync(fixture.source), false)
			const application = join(consumer, process.platform === 'win32' ? 'application.exe' : 'application')
			const built = fixture.run({
				cwd: consumer,
				argv: ['build', 'main.zx', '--out', application, '--solver', solver]
			})
			assert.equal(built.status, 0, built.stderr)

			for (const value of entry.kind === 'bool' ? [false, true] : [0, 7, 255]) {
				const result = fixture.run({ command: application, cwd: consumer, argv: [JSON.stringify(value)] })
				assert.equal(result.status, 0, result.stderr)
				assert.deepEqual(JSON.parse(result.stdout), entry.kind === 'bool' ? !value : value)
			}

			const direct = join(fixture.root, 'zig_consumer')
			cpSync(join(inputs, 'zig'), direct, { recursive: true })
			cpSync(join(inputs, entry.kind + '_test.zig'), join(direct, 'consumer_test.zig'))
			writeFileSync(join(direct, 'public_name.zig'), `pub const value = ${JSON.stringify(entry.public_name)};\n`)
			const consumed = fixture.run({ command: zig, cwd: direct, argv: ['build', '--summary', 'all'] })
			assert.equal(consumed.status, 0, consumed.stderr)
			assert.match(consumed.stderr, /1\/1 tests passed/)
		} finally {
			fixture.cleanup()
		}
	})
}
