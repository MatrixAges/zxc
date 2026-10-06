import type { Case } from '../model.ts'
import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { copyFileSync, mkdirSync, mkdtempSync, readFileSync, realpathSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { basename, dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import { readRows } from '../../../../src/shared/json.ts'
import createApplication from '../../../runtime/gateway/application.ts'

type Suite = { name: string; path: string; kind: string }

const [compiler_path, catalog_path, optimize, report_path] = process.argv.slice(2)
const compiler = resolve(compiler_path)
const package_dir = dirname(resolve(catalog_path))
const catalog: { runtime: Array<Suite> } = JSON.parse(readFileSync(catalog_path, 'utf8'))
const suites = catalog.runtime.filter(suite => suite.name.startsWith('application-json-output-'))
const source = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-json-gateway-source-')))
const observations: Array<unknown> = []
const errors = new Map<string, number>()
let application: ReturnType<typeof createApplication> | undefined
let gateway: Awaited<ReturnType<ReturnType<typeof createApplication>['start']>> | undefined
let executable_sha256: string | undefined
let stderr: string | undefined
let stdout: string | undefined

assert.ok(suites.length > 0)

try {
	for (const suite of suites) {
		const name = basename(suite.path)

		copyFileSync(join(package_dir, 'tests', suite.path + '.zx'), join(source, name + '.zx'))
		writeFileSync(
			join(source, name + '.rx'),
			`<Module>\n  <Call fn="${name}" in={$in}/>\n  <Return value={$ctx.${name}}/>\n</Module>\n`
		)
	}

	writeFileSync(
		join(source, 'main.gateway.rx'),
		'<Gateway name="json_output" listen="127.0.0.1:0">\n' +
			suites
				.map(
					suite =>
						`  <Route method="POST" path="/${basename(suite.path)}" service="${basename(suite.path)}"/>\n`
				)
				.join('') +
			'</Gateway>\n'
	)

	application = createApplication({ compiler, source, optimize })
	gateway = await application.start()
	executable_sha256 = createHash('sha256').update(readFileSync(gateway.executable)).digest('hex')

	for (const suite of suites) {
		const cases = readRows<Case>(join(package_dir, 'tests', suite.path + '.jsonl'))

		for (const test_case of cases) {
			await test(`Gateway JSON ${test_case.id} (${optimize})`, async () => {
				const response = await gateway!.request({
					path: '/' + basename(suite.path),
					method: 'POST',
					body: test_case.json_text
				})
				let passed = false

				try {
					if ('error' in test_case.expected) {
						assert.equal(response.status, 500)
						assert.equal(response.body.toString(), 'service failed')
						assert.notEqual(response.headers.get('content-type'), 'application/json')
						errors.set(test_case.expected.error, (errors.get(test_case.expected.error) ?? 0) + 1)
					} else {
						assert.equal(response.status, 200)
						assert.equal(response.headers.get('content-type'), 'application/json')
						assert.deepEqual(JSON.parse(response.body.toString()), test_case.expected.value)
					}

					passed = true
				} finally {
					observations.push({
						id: test_case.id,
						target: 'gateway-http',
						input_utf8_hex: Buffer.from(test_case.json_text).toString('hex'),
						status: response.status,
						headers: Object.fromEntries(response.headers),
						body: response.body.toString(),
						wire_hex: response.raw.toString('hex'),
						passed
					})
				}
			})
		}
	}
} finally {
	await gateway?.stop()
	stderr = gateway?.stderr()
	stdout = gateway?.stdout()
	application?.close()
	rmSync(source, { recursive: true, force: true })
	mkdirSync(dirname(report_path), { recursive: true })
	writeFileSync(
		report_path,
		JSON.stringify({ optimize, compiler, executable_sha256, observations, stderr, stdout }, null, 2) + '\n'
	)
}

assert.equal(stdout, '')

for (const [name, count] of errors) {
	assert.equal([...stderr!.matchAll(new RegExp('Gateway service failed: ' + name, 'g'))].length, count)
}
