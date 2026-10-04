import assert from 'node:assert/strict'
import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { parse, stringify } from 'yaml'
import createFixture from './fixture.ts'
import openArtifact from './store_artifact.ts'

const inputs = resolve(process.argv[4])
const source = resolve(process.argv[5])

test('compiled Store transaction authorization and required initializers remain separate boundaries', async context => {
	const fixture = createFixture()

	try {
		rmSync(fixture.source, { recursive: true })
		cpSync(source, fixture.source, { recursive: true })
		const published = fixture.run({ argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', fixture.published] })
		assert.equal(published.status, 0, published.stderr)
		const consumer = join(fixture.root, 'consumer')
		mkdirSync(join(consumer, 'pkgs'), { recursive: true })
		const bundle = join(consumer, 'pkgs/bundle')
		cpSync(fixture.published, bundle, { recursive: true })
		cpSync(inputs, consumer, { recursive: true })
		const source_package = join(consumer, 'pkgs/source')
		mkdirSync(source_package)
		cpSync(join(inputs, 'identity.zx'), join(source_package, 'main.zx'))
		writeFileSync(
			join(source_package, 'pkg.yaml'),
			stringify({ name: 'source', version: '1.0.0', entry: 'main.zx' })
		)
		writeFileSync(
			join(consumer, 'pkg.yaml'),
			stringify({
				name: 'consumer',
				version: '1.0.0',
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:*', source: 'workspace:*' }
			})
		)
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })

		const artifact = openArtifact(join(bundle, 'library.zxcir'))
		artifact.exposeTransaction()
		artifact.save()
		const manifest_path = join(bundle, 'pkg.yaml')
		const manifest = parse(readFileSync(manifest_path, 'utf8')) as { exports: Record<string, unknown> }
		manifest.exports['./raw'] = { module: './raw' }
		writeFileSync(manifest_path, stringify(manifest))
		const application = join(consumer, process.platform === 'win32' ? 'application.exe' : 'application')
		const loaded = fixture.run({ cwd: consumer, argv: ['build', 'load.zx', '--out', application, '--no-cache'] })
		assert.equal(loaded.status, 0, loaded.stderr)
		const previous = readFileSync(application)

		function unchanged(): void {
			assert.deepEqual(readFileSync(application), previous)
			const result = fixture.run({ command: application, cwd: consumer, argv: ['37'] })
			assert.equal(result.status, 0, result.stderr)
			assert.equal(JSON.parse(result.stdout), 37)
		}
		unchanged()

		function reject(file: string, diagnostic: RegExp): void {
			const result = fixture.run({ cwd: consumer, argv: ['build', file, '--out', application, '--no-cache'] })
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, diagnostic)
			unchanged()
		}

		for (const entry of [
			{
				name: 'RX cannot call a public bare transaction',
				file: 'raw.rx',
				diagnostic: /compiled Store transactions require an explicit authorized RX module/
			},
			{
				name: 'ZX cannot call a public bare transaction',
				file: 'call.zx',
				diagnostic: /Store functions require an explicitly authorized orchestration Call/
			},
			{
				name: 'source package cannot act as a compiled module',
				file: 'source.rx',
				diagnostic: /Call.module requires a public compiled package module/
			}
		])
			await context.test(entry.name, () => reject(entry.file, entry.diagnostic))

		const initializers = artifact.payload.store_initializers
		assert.equal(initializers.length, 2)
		for (const mode of ['all', 'counter']) {
			await context.test(`missing ${mode} initializers remains loadable but cannot start Store app`, () => {
				artifact.payload.store_initializers =
					mode === 'all' ? [] : initializers.filter(initial => !initial.identity.endsWith(':counter'))
				artifact.save()
				const loaded = fixture.run({
					cwd: consumer,
					argv: ['load.zx', '--out', join(consumer, 'loaded.zig'), '--no-cache']
				})
				assert.equal(loaded.status, 0, loaded.stderr)
				reject('read.rx', /MissingInitializer/)
			})
		}

		for (const mode of ['unused settings omitted', 'all declarations restored']) {
			await context.test(mode, () => {
				artifact.payload.store_initializers =
					mode === 'unused settings omitted'
						? initializers.filter(initial => initial.identity.endsWith(':counter'))
						: initializers
				artifact.save()
				const built = fixture.run({
					cwd: consumer,
					argv: ['build', 'read.rx', '--out', application, '--no-cache']
				})
				assert.equal(built.status, 0, built.stderr)
				const result = fixture.run({ command: application, cwd: consumer, argv: [] })
				assert.equal(result.status, 0, result.stderr)
				assert.equal(JSON.parse(result.stdout), 3)
			})
		}
	} finally {
		fixture.cleanup()
	}
})
