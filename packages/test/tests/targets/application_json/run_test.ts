import type { Case, Observation, Response, Target } from './model.ts'
import assert from 'node:assert/strict'
import { mkdirSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { test } from 'node:test'
import { readRows } from '../../../src/shared/json.ts'
import createHost from '../wasm/host.ts'
import checkCase from './check.ts'
import createFixture from './fixture.ts'

const [compiler_path, source_path, catalog_path, optimize, report_path] = process.argv.slice(2)
const source = resolve(source_path)
const cases = readRows<Case>(resolve(catalog_path))
const targets: Array<Target> = ['native', 'wasm32-freestanding', 'wasm32-wasi']
const fixture = createFixture({ compiler: resolve(compiler_path), source, optimize })
const observations: Array<Observation> = []

assert.ok(cases.length > 0)

try {
	const paths = new Map(targets.map(target => [target, fixture.build(target)]))
	const host = createHost(paths.get('wasm32-freestanding')!)

	try {
		for (const test_case of cases) {
			await test(`application JSON ${test_case.id} (${optimize})`, () => {
				const input_utf8_hex = Buffer.from(test_case.json_text).toString('hex')

				for (const target of targets) {
					if (target !== 'wasm32-freestanding' && test_case.json_text.includes('\0')) {
						observations.push({
							id: test_case.id,
							target,
							input_utf8_hex,
							executed: false,
							reason: 'argv cannot transport NUL'
						})

						continue
					}

					const memory = target === 'wasm32-freestanding' ? host.invoke(test_case.json_text) : null

					const response: Response = memory
						? { status: memory.status, output: memory.result, stderr: '' }
						: fixture.execute({ path: paths.get(target)!, target, text: test_case.json_text })

					let passed = false

					try {
						checkCase({ test_case, response, target })

						passed = true
					} finally {
						observations.push({
							id: test_case.id,
							target,
							input_utf8_hex,
							executed: true,
							response,
							passed
						})
					}
				}
			})
		}
	} finally {
		host.api.zxc_deinit()
	}
} finally {
	mkdirSync(dirname(report_path), { recursive: true })

	writeFileSync(
		report_path,
		JSON.stringify(
			{
				source,
				catalog: resolve(catalog_path),
				optimize,
				commands: fixture.commands,
				artifacts: fixture.artifacts,
				observations
			},
			null,
			2
		) + '\n'
	)

	fixture.close()
}
