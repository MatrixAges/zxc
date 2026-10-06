import type { Command } from './fixture.ts'
import assert from 'node:assert/strict'
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import createFixture from './fixture.ts'
import checkScalar from './scalar.ts'

const [compiler_path, fixture_path, optimize, report_path] = process.argv.slice(2)
const compiler = resolve(compiler_path)
const source = resolve(fixture_path)
const reports: Array<{ name: string; passed: boolean; commands: Array<Command> }> = []
const targets = [null, 'wasm32-freestanding', 'wasm32-wasi'] as const
const policies = ['json', 'discard'] as const

for (const entry of [
	'input/leaf.zx',
	'input/optional.zx',
	'input/list.zx',
	'input/object.zx',
	'input/tuple.zx',
	'output/identity.zx',
	'output/optional.zx',
	'output/nested.zx',
	'control/scalar.zx'
]) {
	test(`native reference application boundary ${entry} (${optimize})`, () => {
		const fixture = createFixture({ compiler, source, entry, optimize })
		let passed = false

		try {
			const generated = join(fixture.root, 'accepted.zig')

			fixture.run({ argv: ['main.zx', '--out', generated] })
			assert.ok(readFileSync(generated).length > 0)

			const library = fixture.publish()

			for (const route of ['source', 'library'] as const) {
				const directory = route === 'source' ? fixture.project : library
				const application_entry = route === 'source' ? 'main.zx' : 'consumer.zx'

				for (const target of targets) {
					for (const policy of policies) {
						const output = join(
							fixture.root,
							`${route}-${target ?? 'native'}-${policy}${target ? '.wasm' : process.platform === 'win32' ? '.exe' : ''}`
						)

						const args = { directory, entry: application_entry, target, policy, output }

						if (entry === 'control/scalar.zx') {
							fixture.build(args)
							checkScalar({ fixture, path: output, target, policy })
						} else {
							fixture.build({ ...args, failure: true })
							assert.equal(existsSync(output), false)

							const previous = Buffer.from([0, 255, 17, 42])

							writeFileSync(output, previous)
							fixture.build({ ...args, failure: true })
							assert.deepEqual(readFileSync(output), previous)
						}
					}
				}
			}

			passed = true
		} finally {
			reports.push({ name: entry, passed, commands: fixture.commands })
			mkdirSync(dirname(report_path), { recursive: true })
			writeFileSync(report_path, JSON.stringify({ optimize, reports }, null, 2) + '\n')
			fixture.close()
		}
	})
}
