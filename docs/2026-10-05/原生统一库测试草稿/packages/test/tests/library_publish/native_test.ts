import assert from 'node:assert/strict'
import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import createFixture, { snapshot, zig } from './fixture.ts'
import checkResources from './native_resources.ts'

const inputs = resolve(process.argv[4])

test('native unified libraries preserve scoped ABI resources and rollback across republication', () => {
	const fixture = createFixture()

	try {
		rmSync(fixture.source, { recursive: true })
		cpSync(join(inputs, 'source'), fixture.source, { recursive: true })
		const published = fixture.run({ argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', fixture.published] })
		assert.equal(published.status, 0, published.stderr)
		checkResources(fixture.published)

		const wrapper = join(fixture.root, 'wrapper')
		mkdirSync(join(wrapper, 'pkgs'), { recursive: true })
		const first = join(wrapper, 'pkgs/bundle')
		cpSync(fixture.published, first, { recursive: true })
		cpSync(join(inputs, 'consumer.zx'), join(wrapper, 'main.zx'))
		writeFileSync(
			join(wrapper, 'pkg.yaml'),
			stringify({
				name: 'wrapper',
				version: '1.0.0',
				exports: { '.': 'main.zx' },
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:*' }
			})
		)
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })
		assert.equal(existsSync(fixture.source), false)

		function execute(directory: string): void {
			const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')
			const built = fixture.run({
				cwd: directory,
				argv: ['build', 'main.zx', '--out', application, '--no-cache']
			})
			assert.equal(built.status, 0, built.stderr)

			for (const value of [-20, 0, 27, 1000]) {
				const result = fixture.run({ command: application, cwd: directory, argv: [String(value)] })
				assert.equal(result.status, 0, result.stderr)
				const pair = { left: value + 3, right: value + 22 }
				assert.deepEqual(JSON.parse(result.stdout), { ...pair, pair })
			}
		}

		execute(wrapper)
		const second = join(fixture.root, 'republished')
		const republished = fixture.run({ cwd: wrapper, argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', second] })
		assert.equal(republished.status, 0, republished.stderr)
		checkResources(second)
		const previous = snapshot(second)
		const asset = join(first, checkResources(first)[0])
		const content = readFileSync(asset)
		rmSync(asset)
		const rejected = fixture.run({
			cwd: wrapper,
			argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', second, '--no-cache']
		})
		assert.equal(rejected.status, 1, rejected.stderr)
		assert.notEqual(rejected.stderr.trim(), '')
		assert.deepEqual(snapshot(second), previous)
		writeFileSync(asset, content)

		const consumer = join(fixture.root, 'consumer')
		mkdirSync(join(consumer, 'pkgs'), { recursive: true })
		cpSync(second, join(consumer, 'pkgs/bundle'), { recursive: true })
		cpSync(join(inputs, 'final.zx'), join(consumer, 'main.zx'))
		writeFileSync(
			join(consumer, 'pkg.yaml'),
			stringify({
				name: 'consumer',
				version: '1.0.0',
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:wrapper@*' }
			})
		)
		rmSync(wrapper, { recursive: true })
		rmSync(second, { recursive: true })
		assert.equal(existsSync(first), false)
		execute(consumer)

		const direct = join(fixture.root, 'zig_consumer')
		cpSync(join(inputs, 'zig'), direct, { recursive: true })
		const consumed = fixture.run({ command: zig, cwd: direct, argv: ['build', '--summary', 'all'] })
		assert.equal(consumed.status, 0, consumed.stderr)
		assert.match(consumed.stderr, /1\/1 tests passed/)
	} finally {
		fixture.cleanup()
	}
})
