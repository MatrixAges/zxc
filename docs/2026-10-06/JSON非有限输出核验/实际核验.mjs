import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import createFixture from '../../../packages/test/tests/targets/application_json/fixture.ts'
import createHost from '../../../packages/test/tests/targets/wasm/host.ts'

const directory = dirname(fileURLToPath(import.meta.url))
const compiler = resolve(process.argv[2])
const targets = ['native', 'wasm32-freestanding', 'wasm32-wasi']

const groups = [
	{ source: 'scalar.zx', inputs: ['1', '1e400', '-1e400'] },
	{
		source: 'division.zx',
		inputs: [
			'{"numerator":1,"denominator":1}',
			'{"numerator":1,"denominator":0}',
			'{"numerator":-1,"denominator":0}',
			'{"numerator":0,"denominator":0}'
		]
	}
]

const results = []

for (const group of groups) {
	const fixture = createFixture({ compiler, source: resolve(directory, group.source), optimize: 'debug' })
	const observations = []

	try {
		const paths = new Map(targets.map(target => [target, fixture.build(target)]))
		const host = createHost(paths.get('wasm32-freestanding'))

		try {
			for (const input of group.inputs) {
				for (const target of targets) {
					const memory = target === 'wasm32-freestanding' ? host.invoke(input) : null

					const response = memory
						? { status: memory.status, output: memory.result, stderr: '' }
						: fixture.execute({ path: paths.get(target), target, text: input })

					let parsed = null
					let parse_error = null

					try {
						parsed = JSON.parse(response.output)
					} catch (error) {
						parse_error = { name: error.name, message: error.message }
					}

					observations.push({
						input,
						input_utf8_hex: Buffer.from(input).toString('hex'),
						target,
						response,
						parsed,
						parse_error
					})
				}
			}
		} finally {
			host.api.zxc_deinit()
		}
	} finally {
		results.push({ source: group.source, commands: fixture.commands, artifacts: fixture.artifacts, observations })
		fixture.close()

		writeFileSync(
			resolve(directory, '实际结果.json'),
			JSON.stringify(
				{
					compiler,
					compiler_sha256: createHash('sha256').update(readFileSync(compiler)).digest('hex'),
					optimize: 'debug',
					results
				},
				null,
				2
			) + '\n'
		)
	}

	const controls = observations.filter(row => row.input === group.inputs[0])

	assert.equal(controls.length, 3)
	assert.ok(controls.every(row => row.response.status === 0 && row.parse_error === null && row.parsed === 1))
}

console.log(
	JSON.stringify(
		results.map(group => ({ source: group.source, observations: group.observations })),
		null,
		2
	)
)
