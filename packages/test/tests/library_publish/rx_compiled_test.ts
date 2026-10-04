import assert from 'node:assert/strict'
import { cpSync, existsSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { parse, stringify } from 'yaml'
import createFixture from './fixture.ts'
import reject from './rx_rejections.ts'

const inputs = resolve(process.argv[4])
const source = resolve(process.argv[5])
const values = [
	{ left: 0, right: 0 },
	{ left: 1, right: 2 },
	{ left: 4, right: 0 },
	{ left: 3, right: 7 }
]

function expected(input: { left: number; right: number }, round: number) {
	const start = 3 + round * (input.left + input.right)
	const other = 3 + round * input.right

	return {
		before: { value: start, history: [8 + round * 2] },
		first: start + input.left,
		second: start + input.left + input.right,
		after: { value: start + input.left + input.right, history: [10 + round * 2] },
		other_before: { value: other, history: [8 + round] },
		other: other + input.right,
		other_after: { value: other + input.right, history: [9 + round] }
	}
}

test('RX compiled Store calls share aliases isolate instances and survive republication', async context => {
	const fixture = createFixture()

	try {
		rmSync(fixture.source, { recursive: true })
		cpSync(source, fixture.source, { recursive: true })
		for (const name of ['snapshot.rx', 'snapshot.zx', 'types.zx'])
			cpSync(join(inputs, name), join(fixture.source, name))
		const manifest = parse(readFileSync(join(fixture.source, 'pkg.yaml'), 'utf8')) as {
			exports: Record<string, string>
		}
		manifest.exports['./snapshot'] = 'snapshot.rx'
		manifest.exports['./types'] = 'types.zx'
		writeFileSync(join(fixture.source, 'pkg.yaml'), stringify(manifest))
		const published = fixture.run({ argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', fixture.published] })
		assert.equal(published.status, 0, published.stderr)

		const consumer = join(fixture.root, 'consumer')
		mkdirSync(join(consumer, 'pkgs'), { recursive: true })
		cpSync(fixture.published, join(consumer, 'pkgs/bundle'), { recursive: true })
		cpSync(fixture.published, join(consumer, 'pkgs/other'), { recursive: true })
		const other_manifest = join(consumer, 'pkgs/other/pkg.yaml')
		writeFileSync(
			other_manifest,
			stringify({ ...(parse(readFileSync(other_manifest, 'utf8')) as Record<string, unknown>), name: 'other' })
		)
		cpSync(join(inputs, 'main.rx'), join(consumer, 'main.rx'))
		writeFileSync(
			join(consumer, 'pkg.yaml'),
			stringify({
				name: 'relay',
				version: '1.0.0',
				exports: { '.': 'main.rx' },
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:*', same: 'workspace:bundle@*', other: 'workspace:*' }
			})
		)
		rmSync(fixture.source, { recursive: true })
		rmSync(fixture.published, { recursive: true })
		assert.equal(existsSync(fixture.source), false)
		const execution = join(fixture.root, 'execution')
		mkdirSync(execution)

		async function execute(directory: string, twice: boolean): Promise<string> {
			const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')
			const built = fixture.run({
				cwd: directory,
				argv: ['build', 'main.rx', '--out', application, '--no-cache']
			})
			assert.equal(built.status, 0, built.stderr)
			for (const input of values) {
				await context.test(`${twice ? 'republished' : 'direct'} calls ${JSON.stringify(input)}`, () => {
					const result = fixture.run({ command: application, cwd: execution, argv: [JSON.stringify(input)] })
					assert.equal(result.status, 0, result.stderr)
					assert.equal(result.stderr, '')
					assert.deepEqual(
						JSON.parse(result.stdout),
						twice ? { first: expected(input, 0), second: expected(input, 1) } : expected(input, 0)
					)
				})
			}
			assert.deepEqual(readdirSync(execution), [])
			return application
		}

		const application = await execute(consumer, false)
		await reject({ fixture, consumer, context, application })
		const second = join(fixture.root, 'republished')
		const republished = fixture.run({
			cwd: consumer,
			argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', second]
		})
		assert.equal(republished.status, 0, republished.stderr)
		const final = join(fixture.root, 'final')
		mkdirSync(join(final, 'pkgs'), { recursive: true })
		cpSync(second, join(final, 'pkgs/relay'), { recursive: true })
		cpSync(join(inputs, 'final.rx'), join(final, 'main.rx'))
		writeFileSync(
			join(final, 'pkg.yaml'),
			stringify({
				name: 'final',
				version: '1.0.0',
				workspace: { packages: ['pkgs/*'] },
				dependencies: { relay: 'workspace:*' }
			})
		)
		rmSync(consumer, { recursive: true })
		rmSync(second, { recursive: true })
		assert.equal(existsSync(consumer), false)
		await execute(final, true)
	} finally {
		fixture.cleanup()
	}
})
