import assert from 'node:assert/strict'
import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { parse, stringify } from 'yaml'
import writeArchive, { readDirectory } from '../package_native/archive.ts'
import createFixture, { solver, zig } from './fixture.ts'

const inputs = resolve(process.argv[4])

test('published diamond package closure installs alone and survives offline recovery', () => {
	const fixture = createFixture()

	try {
		rmSync(fixture.source, { recursive: true })
		cpSync(join(inputs, 'source'), fixture.source, { recursive: true })
		const published = fixture.run({
			argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', fixture.published, '--solver', solver]
		})
		assert.equal(published.status, 0, published.stderr)
		const manifest = parse(readFileSync(join(fixture.published, 'pkg.yaml'), 'utf8')) as {
			dependencies?: unknown
			workspace?: unknown
		}
		assert.equal(manifest.dependencies, undefined)
		assert.equal(manifest.workspace, undefined)

		const registry = join(fixture.root, 'registry')
		mkdirSync(registry)
		const release = writeArchive(join(registry, 'bundle.tgz'), readDirectory(fixture.published))
		const index = join(registry, 'index.json')
		writeFileSync(
			index,
			JSON.stringify({
				format_version: 1,
				packages: [{ name: 'bundle', versions: [{ version: '1.0.0', ...release }] }]
			})
		)
		cpSync(fixture.published, join(fixture.root, 'zig_bundle'), { recursive: true })
		const consumer = join(fixture.root, 'consumer')
		mkdirSync(consumer)
		cpSync(join(inputs, 'consumer/main.zx'), join(consumer, 'main.zx'))
		writeFileSync(
			join(consumer, 'pkg.yaml'),
			stringify({ name: 'consumer', version: '1.0.0', entry: 'main.zx', dependencies: { bundle: '1.0.0' } })
		)
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })
		assert.equal(existsSync(fixture.source), false)
		assert.equal(existsSync(fixture.published), false)

		const installed = fixture.run({ cwd: consumer, argv: ['pkg', 'install', '--index', index] })
		assert.equal(installed.status, 0, installed.stderr)
		const lock = readFileSync(join(consumer, 'pkg.lock.json'), 'utf8')
		const graph = JSON.parse(lock) as { packages: Array<{ name: string }> }
		assert.deepEqual(graph.packages.map(entry => entry.name).sort(), ['bundle', 'consumer'])
		const application = join(consumer, process.platform === 'win32' ? 'application.exe' : 'application')

		function execute(): void {
			const built = fixture.run({
				cwd: consumer,
				argv: ['build', 'main.zx', '--out', application, '--no-cache', '--solver', solver]
			})
			assert.equal(built.status, 0, built.stderr)
			const modes = ['First', 'Second', 'Third']

			for (const [index, mode] of modes.entries()) {
				const result = fixture.run({ command: application, cwd: consumer, argv: [JSON.stringify(mode)] })
				assert.equal(result.status, 0, result.stderr)
				assert.deepEqual(JSON.parse(result.stdout), {
					main: modes[(index + 2) % 3],
					echo: modes[(index + 1) % 3],
					flow: modes[(index + 2) % 3]
				})
			}
		}

		execute()
		const zig_consumer = join(fixture.root, 'zig_consumer')
		cpSync(join(inputs, 'zig'), zig_consumer, { recursive: true })
		const direct = fixture.run({ command: zig, cwd: zig_consumer, argv: ['build', '--summary', 'all'] })
		assert.equal(direct.status, 0, direct.stderr)
		assert.match(direct.stderr, /1\/1 tests passed/)

		rmSync(registry, { recursive: true })
		rmSync(join(consumer, '.zxc/packages'), { recursive: true })
		rmSync(join(fixture.root, 'cache/packages/v1/contents'), { recursive: true })
		rmSync(application)
		const recovered = fixture.run({
			cwd: consumer,
			argv: ['pkg', 'install', '--index', index, '--offline', '--frozen-lockfile']
		})
		assert.equal(recovered.status, 0, recovered.stderr)
		assert.equal(readFileSync(join(consumer, 'pkg.lock.json'), 'utf8'), lock)
		execute()
	} finally {
		fixture.cleanup()
	}
})
