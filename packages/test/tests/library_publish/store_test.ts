import assert from 'node:assert/strict'
import { cpSync, existsSync, mkdirSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import createFixture from './fixture.ts'
import consume from './store_consume.ts'

const inputs = resolve(process.argv[4])

test('published Store initializers execute after relocation and type-only republication', () => {
	const fixture = createFixture()

	try {
		rmSync(fixture.source, { recursive: true })
		cpSync(join(inputs, 'source'), fixture.source, { recursive: true })
		const published = fixture.run({ argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', fixture.published] })
		assert.equal(published.status, 0, published.stderr)
		const wrapper = join(fixture.root, 'wrapper')
		mkdirSync(join(wrapper, 'pkgs'), { recursive: true })
		const first = join(wrapper, 'pkgs/bundle')
		cpSync(fixture.published, first, { recursive: true })
		cpSync(join(inputs, 'types.zx'), join(wrapper, 'types.zx'))
		writeFileSync(
			join(wrapper, 'pkg.yaml'),
			stringify({
				name: 'wrapper',
				version: '1.0.0',
				exports: { './types': 'types.zx' },
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:*' }
			})
		)
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })
		assert.equal(existsSync(fixture.source), false)
		const original = consume({ fixture, library: first, inputs, host: true, name: 'first_consumer' })

		const second = join(fixture.root, 'republished')
		const republished = fixture.run({ cwd: wrapper, argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', second] })
		assert.equal(republished.status, 0, republished.stderr)
		const moved = join(fixture.root, 'second_library')
		cpSync(second, moved, { recursive: true })
		rmSync(wrapper, { recursive: true })
		rmSync(second, { recursive: true })
		rmSync(join(fixture.root, 'first_consumer'), { recursive: true })
		assert.equal(existsSync(first), false)
		const remapped = consume({ fixture, library: moved, inputs, host: false, name: 'second_consumer' })
		assert.notDeepEqual(remapped, original)
	} finally {
		fixture.cleanup()
	}
})

test('optional arithmetic fix does not authorize nullable operands', () => {
	const fixture = createFixture()

	try {
		const output = join(fixture.root, 'rejected.zig')
		for (const [kind, expression] of [
			['u64', 'in + 1'],
			['i64', '-in'],
			['f64', 'in * 1.5'],
			['f64', '-in']
		]) {
			writeFileSync(
				join(fixture.source, 'rejected.zx'),
				`export type Input = ${kind}?\n\nexport type Output = Input\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`
			)
			const rejected = fixture.run({ argv: ['rejected.zx', '--out', output] })
			assert.equal(rejected.status, 1, `${kind}: ${expression}: ${rejected.stderr}`)
			assert.match(rejected.stderr, /type_mismatch/)
			assert.equal(existsSync(output), false)
		}
	} finally {
		fixture.cleanup()
	}
})
