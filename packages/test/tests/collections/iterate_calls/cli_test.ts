import assert from 'node:assert/strict'
import { cpSync, existsSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture, { modes } from './cli_fixture.ts'
import { expectedResult, inputs } from './cli_cases.ts'

type Metadata = { format_version: number; public_modules: Array<{ name: string }> }

const optimize = process.argv[3]
const consumerSource = (mode: string) => `import run from "loops/${mode}"

export type Input = { count: u64, start: i64, values: i64[] }

export type Output = { initial: i64, total: i64, previous: i64, steps: u64, other: i64, values: i64[] }

export default function (in: Input): Output {
  return run(in)
}
`

test('loop public library relocation and compiled manifest republication preserve returned aliases', () => {
	const fixture = createFixture()

	try {
		fixture.publish()
		fixture.relocate()

		assert.equal(existsSync(fixture.source), false)
		assert.equal(existsSync(fixture.published), false)

		for (const route of ['compiled', 'republished']) {
			if (route === 'republished') {
				const output = join(fixture.root, 'republished')
				const result = fixture.run({
					argv: ['build', join(fixture.package_dir, 'pkg.yaml'), '--mode', 'lib', '--out', output],
					cwd: fixture.consumer,
					cache: 'republish_cache'
				})

				assert.equal(result.status, 0, result.stderr)
				rmSync(fixture.package_dir, { recursive: true })
				cpSync(output, fixture.package_dir, { recursive: true })
				rmSync(output, { recursive: true })
			}

			const before = fixture.snapshot()
			const metadata = JSON.parse(readFileSync(join(fixture.package_dir, 'library.json'), 'utf8')) as Metadata

			assert.equal(metadata.format_version, 2)
			assert.deepEqual(
				metadata.public_modules.map(module => module.name).sort(),
				modes.map(mode => `./${mode}`).sort()
			)
			assert.equal(
				Object.keys(before).some(path => /\.(zx|rx)$/.test(path)),
				false
			)

			for (const mode of modes) {
				const source = consumerSource(mode)
				const application = join(fixture.consumer, process.platform === 'win32' ? `${mode}.exe` : mode)

				writeFileSync(join(fixture.consumer, 'main.zx'), source)

				const built = fixture.run({
					argv: ['build', 'main.zx', '--out', application, '--optimize', optimize],
					cwd: fixture.consumer,
					cache: `${route}_consumer_cache`
				})

				assert.equal(built.status, 0, built.stderr)

				const cases = mode === 'list_alias' ? [...inputs, { count: 0, start: -5, values: [] }] : inputs

				for (const input of cases) {
					const result = fixture.run({
						command: application,
						argv: [JSON.stringify(input)],
						cwd: fixture.consumer
					})

					assert.equal(result.status, 0, result.stderr)
					assert.equal(result.stderr, '')
					assert.deepEqual(JSON.parse(result.stdout), expectedResult(input, mode))
				}

				if (mode === 'list_alias') {
					const result = fixture.run({
						command: application,
						argv: [JSON.stringify({ count: 1, start: -5, values: [] })],
						cwd: fixture.consumer
					})

					assert.equal(result.status, 1, result.stderr)
					assert.match(result.stderr, /IndexOutOfBounds/)
					assert.equal(result.stdout, '')
				}

				assert.equal(readFileSync(join(fixture.consumer, 'main.zx'), 'utf8'), source)
			}

			assert.deepEqual(fixture.snapshot(), before)
		}
	} finally {
		fixture.cleanup()
	}
})
