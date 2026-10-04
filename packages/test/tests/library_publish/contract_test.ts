import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import breakIdentity from './contract_artifact.ts'
import createFixture, { snapshot, solver } from './fixture.ts'

const inputs = resolve(process.argv[4])

test('valid digest cannot bypass compiled public contract verification or replace a valid publication', async context => {
	const fixture = createFixture()

	try {
		const published = fixture.publish()
		assert.equal(published.status, 0, published.stderr)
		const relocated = join(fixture.root, 'relocated')
		mkdirSync(relocated)
		const encoded_path = join(relocated, 'library.zxcir')
		cpSync(join(fixture.published, 'library.zxcir'), encoded_path)
		const original = readFileSync(encoded_path)
		const modified = breakIdentity(original)
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })
		const selections = [
			['./value', '.'],
			['./same', '.'],
			['./negate', './toggle'],
			['./types', './types']
		]

		function manifest(reverse: boolean): void {
			const entries = reverse ? [...selections].reverse() : selections
			writeFileSync(
				join(relocated, 'pkg.yaml'),
				stringify({
					name: 'bundle',
					version: '1.0.0',
					library: 'library.zxcir',
					exports: Object.fromEntries(entries.map(([name, module]) => [name, { module }]))
				})
			)
		}
		manifest(false)
		const consumer = join(fixture.root, 'consumer')
		const rebuilt = join(consumer, 'pkgs/bundle')
		mkdirSync(join(consumer, 'pkgs'), { recursive: true })
		const build_args = ['build', 'pkg.yaml', '--mode', 'lib', '--out', rebuilt, '--no-cache', '--solver', solver]
		const initial = fixture.run({ cwd: relocated, argv: build_args })
		assert.equal(initial.status, 0, initial.stderr)
		const previous = snapshot(rebuilt)
		writeFileSync(encoded_path, modified)

		for (const reverse of [false, true]) {
			await context.test(`contract revalidation with reversed export order ${reverse}`, () => {
				manifest(reverse)
				const proof = join(fixture.root, `proof-${reverse}`)
				const verified = fixture.run({
					cwd: relocated,
					argv: ['verify', 'pkg.yaml', '--out', proof, '--solver', solver]
				})
				assert.equal(verified.status, 1, verified.stderr)
				assert.doesNotMatch(verified.stderr, /InvalidLibrary|MissingPublicModule|FileNotFound/)

				for (const [name] of selections) {
					assert.ok(verified.stderr.includes(`public module ${name}:`))

					if (name === './types') continue

					const digest = createHash('sha256').update(name).digest('hex')
					const path = `${proof}.${digest}.smt2`
					assert.match(readFileSync(path, 'utf8'), /\(check-sat\)/)
					assert.equal(
						readFileSync(path + '.result.txt', 'utf8').trim(),
						name === './negate' ? 'unsat' : 'sat'
					)
					assert.match(readFileSync(path + '.solver.txt', 'utf8'), /Z3 version/)
				}

				const rejected = fixture.run({ cwd: relocated, argv: build_args })
				assert.equal(rejected.status, 1, rejected.stderr)
				assert.match(rejected.stderr, /verification did not succeed/)
				assert.deepEqual(snapshot(rebuilt), previous)
			})
		}

		writeFileSync(encoded_path, original)
		const recovered = fixture.run({ cwd: relocated, argv: build_args })
		assert.equal(recovered.status, 0, recovered.stderr)
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
		const built = fixture.run({
			cwd: consumer,
			argv: ['build', 'main.zx', '--out', application, '--solver', solver]
		})
		assert.equal(built.status, 0, built.stderr)

		for (const value of [0, 1, 127, 255]) {
			const result = fixture.run({
				command: application,
				cwd: consumer,
				argv: [JSON.stringify({ value, enabled: false })]
			})
			assert.equal(result.status, 0, result.stderr)
			assert.deepEqual(JSON.parse(result.stdout), { value, enabled: true })
		}
	} finally {
		fixture.cleanup()
	}
})
