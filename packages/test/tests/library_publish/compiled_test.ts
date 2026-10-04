import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { cpSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import createFixture, { snapshot, solver } from './fixture.ts'

const inputs = resolve(process.argv[4])

test('relocated compiled manifest verifies and rebuilds renamed selected exports', async context => {
	const fixture = createFixture()

	try {
		const published = fixture.publish()
		assert.equal(published.status, 0, published.stderr)
		const relocated = join(fixture.root, 'relocated')
		mkdirSync(relocated)
		cpSync(join(fixture.published, 'library.zxcir'), join(relocated, 'library.zxcir'))
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })
		const exports = {
			'./value': { module: '.' },
			'./same': { module: '.' },
			'./negate': { module: './toggle' },
			'./types': { module: './types' }
		}
		const manifest_path = join(relocated, 'pkg.yaml')
		const manifest = { name: 'bundle', version: '1.0.0', library: 'library.zxcir', exports }
		writeFileSync(manifest_path, stringify(manifest))
		const proof = join(fixture.root, 'proof')
		const verified = fixture.run({
			cwd: relocated,
			argv: ['verify', 'pkg.yaml', '--out', proof, '--solver', solver]
		})
		assert.equal(verified.status, 0, verified.stderr)

		for (const name of Object.keys(exports)) {
			assert.ok(verified.stderr.includes(`public module ${name}:`))

			if (name !== './types') {
				const digest = createHash('sha256').update(name).digest('hex')
				const path = `${proof}.${digest}.smt2`
				assert.match(readFileSync(path, 'utf8'), /\(check-sat\)/)
				assert.equal(readFileSync(path + '.result.txt', 'utf8').trim(), 'unsat')
				assert.match(readFileSync(path + '.solver.txt', 'utf8'), /Z3 version/)
			}
		}
		assert.match(verified.stderr, /type interface validated; no executable proof obligation/)
		assert.equal(readdirSync(fixture.root).filter(name => /^proof\.[0-9a-f]{64}\.smt2$/.test(name)).length, 3)

		const consumer = join(fixture.root, 'consumer')
		const rebuilt = join(consumer, 'pkgs/bundle')
		mkdirSync(join(consumer, 'pkgs'), { recursive: true })
		const build_args = ['build', 'pkg.yaml', '--mode', 'lib', '--out', rebuilt, '--no-cache', '--solver', solver]
		const built = fixture.run({ cwd: relocated, argv: build_args })
		assert.equal(built.status, 0, built.stderr)
		const metadata = JSON.parse(readFileSync(join(rebuilt, 'library.json'), 'utf8')) as {
			public_modules: Array<{ name: string }>
		}
		assert.deepEqual(metadata.public_modules.map(module => module.name).sort(), Object.keys(exports).sort())
		const previous = snapshot(rebuilt)
		const encoded_path = join(relocated, 'library.zxcir')
		const encoded = readFileSync(encoded_path)

		for (const mode of ['missing public module', 'damaged digest']) {
			await context.test(mode, () => {
				writeFileSync(
					manifest_path,
					stringify(
						mode === 'missing public module'
							? { ...manifest, exports: { './missing': { module: './missing' } } }
							: manifest
					)
				)
				writeFileSync(encoded_path, encoded)

				if (mode === 'damaged digest') {
					const damaged = Buffer.from(encoded)
					const offset = damaged.indexOf(10) + 1
					damaged[offset] = damaged[offset] === 48 ? 49 : 48
					writeFileSync(encoded_path, damaged)
				}

				for (const argv of [['verify', 'pkg.yaml', '--solver', solver], build_args]) {
					const rejected = fixture.run({ cwd: relocated, argv })
					assert.equal(rejected.status, 1, rejected.stderr)
					assert.match(
						rejected.stderr,
						mode === 'missing public module' ? /MissingPublicModule/ : /InvalidLibrary/
					)
					assert.deepEqual(snapshot(rebuilt), previous)
				}
			})
		}

		rmSync(relocated, { recursive: true })
		cpSync(join(inputs, 'main.zx'), join(consumer, 'main.zx'))
		writeFileSync(
			join(consumer, 'pkg.yaml'),
			stringify({
				name: 'consumer',
				version: '1.0.0',
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:*' }
			})
		)
		const application = join(consumer, process.platform === 'win32' ? 'application.exe' : 'application')
		const consumed = fixture.run({
			cwd: consumer,
			argv: ['build', 'main.zx', '--out', application, '--solver', solver]
		})
		assert.equal(consumed.status, 0, consumed.stderr)

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
	} finally {
		fixture.cleanup()
	}
})

test('compiled type-only manifest verifies and rebuilds without an executable solver', () => {
	const fixture = createFixture()

	try {
		fixture.manifest({ './types': 'types.zx' })
		const missing_solver = join(fixture.root, 'absent-solver')
		const published = fixture.publish(missing_solver)
		assert.equal(published.status, 0, published.stderr)
		rmSync(fixture.source, { recursive: true })
		const rebuilt = join(fixture.root, 'rebuilt')

		for (const argv of [
			['verify', 'pkg.yaml', '--solver', missing_solver],
			['build', 'pkg.yaml', '--mode', 'lib', '--out', rebuilt, '--solver', missing_solver]
		]) {
			const result = fixture.run({ cwd: fixture.published, argv })
			assert.equal(result.status, 0, result.stderr)
		}

		const verified = fixture.run({ cwd: rebuilt, argv: ['verify', 'pkg.yaml', '--solver', missing_solver] })
		assert.equal(verified.status, 0, verified.stderr)
		assert.match(
			verified.stderr,
			/public module .\/types: type interface validated; no executable proof obligation/
		)
	} finally {
		fixture.cleanup()
	}
})
