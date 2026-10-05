import assert from 'node:assert/strict'
import { existsSync } from 'node:fs'
import { join, resolve } from 'node:path'
import createFixture from './fixture.ts'

const fixture = createFixture({
	compiler: resolve(process.argv[2]),
	source: resolve(process.argv[3]),
	optimize: process.argv[4]
})
let checks = 0

function check(name: string, body: () => void) {
	body()
	checks += 1
	console.log(`ok ${checks}: ${name}`)
}

function checkSnapshot(entry: string) {
	for (const policy of [undefined, 'json', 'discard'] as const) {
		const executable = fixture.buildApp({ entry, policy })
		const argv = ['', 'two words', '中文 🌿', '--result', 'discard', '{"raw":1}']

		check(
			`${entry} ${policy ?? 'default'} ${policy === 'discard' ? 'accepts raw argv and discards result' : 'transfers raw argv, environment and cwd'}`,
			() => {
				const result = fixture.run({ command: executable, argv })

				assert.equal(result.stderr, '')

				if (policy === 'discard') {
					assert.equal(result.stdout, '')
				} else {
					const snapshot = {
						argv: [executable, ...argv],
						env: fixture.environment.ZXC_PROCESS_CONTEXT_VALUE,
						cwd: fixture.cwd
					}
					const expected = entry === 'state.rx' ? { snapshot, count: 7 } : snapshot

					assert.deepEqual(JSON.parse(result.stdout), expected)
					assert.ok(result.stdout.endsWith('\n'))
				}
			}
		)

		if (policy !== 'discard') {
			check(`${entry} ${policy ?? 'default'} uses current explicit environment`, () => {
				const env = { ...fixture.environment }
				delete env.ZXC_PROCESS_CONTEXT_VALUE
				const result = fixture.run({ command: executable, argv: [], env })
				const snapshot = { argv: [executable], env: null, cwd: fixture.cwd }

				assert.deepEqual(JSON.parse(result.stdout), entry === 'state.rx' ? { snapshot, count: 7 } : snapshot)
			})
		}
	}
}

try {
	checkSnapshot('snapshot.zx')

	for (const policy of ['json', 'discard'] as const) {
		const typed = fixture.buildApp({ entry: 'typed.zx', policy })
		const raw = JSON.stringify('ZXC_PROCESS_CONTEXT_VALUE')

		check(
			`typed ${policy} ${policy === 'discard' ? 'accepts JSON input and discards result' : 'keeps raw JSON argument in Process argv'}`,
			() => {
				const result = fixture.run({ command: typed, argv: [raw] })

				if (policy === 'discard') assert.equal(result.stdout, '')
				else
					assert.deepEqual(JSON.parse(result.stdout), {
						argv: [typed, raw],
						env: fixture.environment.ZXC_PROCESS_CONTEXT_VALUE
					})
			}
		)

		check(`typed ${policy} rejects absent JSON input`, () => {
			fixture.run({ command: typed, argv: [], failure: 'ExpectedJsonInput' })
		})

		check(`typed ${policy} rejects multiple inputs despite Process capability`, () => {
			fixture.run({ command: typed, argv: [raw, 'extra'], failure: 'ExpectedJsonInput' })
		})

		check(`typed ${policy} does not suppress application failure`, () => {
			const result = fixture.run({ command: typed, argv: ['"BAD=KEY"'], failure: 'InvalidEnvironmentKey' })

			assert.equal(result.stdout, '')
		})

		for (const entry of ['pure.zx', 'cwd.zx']) {
			const executable = fixture.buildApp({ entry, policy })

			check(`${entry} ${policy} accepts no business arguments`, () => {
				const result = fixture.run({ command: executable, argv: [] })

				if (policy === 'discard') assert.equal(result.stdout, '')
				else assert.deepEqual(JSON.parse(result.stdout), entry === 'pure.zx' ? 7 : fixture.cwd)
			})

			check(`${entry} ${policy} rejects extra argv without Process capability`, () => {
				fixture.run({ command: executable, argv: ['extra'], failure: 'ExpectedNoArguments' })
			})
		}

		for (const stream of ['stdout', 'stderr']) {
			const executable = fixture.buildApp({ entry: `${stream}.zx`, policy })

			check(`${stream} ${policy} preserves business output separately from void result`, () => {
				const result = fixture.run({ command: executable, argv: ['"marker\\n"'] })

				assert.equal(result.stderr, stream === 'stderr' ? 'marker\n' : '')
				assert.equal(
					result.stdout,
					(stream === 'stdout' ? 'marker\n' : '') + (policy === 'json' ? 'null\n' : '')
				)
			})
		}
	}

	check('same application path changes json to discard and back without stale policy', () => {
		let executable = fixture.buildApp({ entry: 'pure.zx', policy: 'json' })

		assert.equal(fixture.run({ command: executable, argv: [] }).stdout, '7\n')
		executable = fixture.buildApp({ entry: 'pure.zx', policy: 'discard', output: executable })
		assert.equal(fixture.run({ command: executable, argv: [] }).stdout, '')
		executable = fixture.buildApp({ entry: 'pure.zx', policy: 'json', output: executable })
		assert.equal(fixture.run({ command: executable, argv: [] }).stdout, '7\n')
	})

	for (const args of [
		['--result', 'yaml'],
		['--result'],
		['--result', 'json', '--result', 'discard'],
		['--mode', 'lib', '--result', 'json']
	]) {
		check(`build rejects invalid result options ${args.join(' ')}`, () => {
			fixture.run({
				command: fixture.compiler,
				argv: ['build', join(fixture.project, 'pure.zx'), '--out', join(fixture.root, 'invalid'), ...args],
				failure: '[--result json|discard]'
			})
			assert.equal(existsSync(join(fixture.root, 'invalid')), false)
		})
	}

	check('compile command rejects app result policy', () => {
		fixture.run({
			command: fixture.compiler,
			argv: [join(fixture.project, 'pure.zx'), '--out', join(fixture.root, 'invalid.zig'), '--result', 'json'],
			failure: '[--result json|discard]'
		})
	})

	assert.equal(existsSync(join(fixture.root, 'invalid.zig')), false)

	checkSnapshot('workflow.rx')
	checkSnapshot('service.rx')
	checkSnapshot('state.rx')

	console.log(`Process application entry: ${checks} checks passed`)
} finally {
	fixture.close()
}
