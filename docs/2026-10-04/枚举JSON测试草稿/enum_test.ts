import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { after, before, test } from 'node:test'
import cases from './enum_cases.ts'

const executable = resolve(process.argv[2])
const directory = mkdtempSync(join(tmpdir(), 'zxc-json-enum-'))
const extension = process.platform === 'win32' ? '.exe' : ''

before(() => {
	for (const [name, input] of [['scalar', 'State?'], ['nested', '{ value: State?; values: State[]; }']]) {
		const source = `export enum State { First, Second, Third }\n\nexport type Input = ${input};\n\nexport type Output = Input;\n\nexport default function (in: Input): Output {\n  return in;\n}\n`

		writeFileSync(join(directory, name + '.zx'), source)

		const result = spawnSync(executable, ['build', name + '.zx', '--mode', 'app', '--out', join(directory, name + extension)], { cwd: directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, 0, result.stderr)
	}
})

after(() => rmSync(directory, { recursive: true, force: true }))

for (const entry of cases) {
	test(`JSON enum / ${entry.name}`, () => {
		const result = spawnSync(join(directory, entry.program + extension), [JSON.stringify(entry.input)], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, entry.error ? 1 : 0, result.stderr)

		if (entry.error) {
			assert.equal(result.stdout, '')
			assert.equal(result.stderr.split(/\r?\n/)[0], 'error: ' + entry.error)
		} else {
			assert.equal(result.stderr, '')
			assert.deepEqual(JSON.parse(result.stdout), entry.expected)
		}
	})
}
