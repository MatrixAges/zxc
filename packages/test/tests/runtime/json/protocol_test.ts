import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { after, before, test } from 'node:test'
import cases from './protocol_cases.ts'

const executable = resolve(process.argv[2])
const directory = mkdtempSync(join(tmpdir(), 'zxc-app-protocol-'))
const extension = process.platform === 'win32' ? '.exe' : ''

before(() => {
	for (const [name, input, output, body] of [
		['no_input', 'void', 'u64', '  return 7\n'],
		['void_output', 'bool', 'void', '  if (in) { return }'],
		['fallible', '{ items: u64[]\n index: u64 }', 'u64', '  return in.items[in.index]\n'],
	]) {
		const source = `export type Input = ${input}

export type Output = ${output}

export default function (in: Input): Output {
${body.trimEnd()}\n}\n`

		writeFileSync(join(directory, name + '.zx'), source)

		const result = spawnSync(executable, ['build', name + '.zx', '--mode', 'app', '--out', join(directory, name + extension)], { cwd: directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, 0, result.stderr)
	}
})

after(() => rmSync(directory, { recursive: true, force: true }))

for (const entry of cases) {
	test(`application protocol / ${entry.name}`, () => {
		const result = spawnSync(join(directory, entry.program + extension), entry.argv, { cwd: directory, encoding: 'utf8', timeout: 10_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, entry.error ? 1 : 0, result.stderr)

		if (entry.error) {
			assert.equal(result.stdout, '')
			assert.equal(result.stderr.split(/\r?\n/)[0], 'error: ' + entry.error)
		} else {
			assert.equal(result.stderr, '')
			assert.equal(result.stdout, entry.expected)
		}
	})
}
