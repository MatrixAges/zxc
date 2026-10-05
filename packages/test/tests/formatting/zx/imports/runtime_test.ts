import assert from 'node:assert/strict'
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture from './cli_fixture.ts'

const optimize = process.argv[3]
const identity = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return in
}
`

test('ZX import order / compiler gate and static execution preserve call order', () => {
	const fixture = createFixture()
	const source =
		'import twice from "./twice"\nimport increment from "@/shared/increment"\n\n' +
		identity.replace('return in', 'return twice(increment(in))')
	const expected =
		'import increment from "@/shared/increment"\n\nimport twice from "./twice"\n\n' +
		identity.replace('return in', 'return twice(increment(in))')
	const application = join(fixture.root, process.platform === 'win32' ? 'application.exe' : 'application')
	const main = join(fixture.root, 'main.zx')
	const files = {
		'twice.zx': identity.replace('return in', 'return in * 2'),
		'shared/increment.zx': identity.replace('return in', 'return in + 1')
	}

	try {
		mkdirSync(join(fixture.root, 'shared'))
		writeFileSync(main, source)

		for (const [path, content] of Object.entries(files)) writeFileSync(join(fixture.root, path), content)

		const rejected = fixture.run(['build', 'main.zx', '--out', application, '--optimize', optimize])

		assert.equal(rejected.status, 1, rejected.stderr)
		assert.match(rejected.stderr, /spacing: import order or blank lines do not match built-in rules; run zxc fmt/)
		assert.equal(existsSync(application), false)
		assert.equal(readFileSync(main, 'utf8'), source)

		const written = fixture.run(['fmt', 'main.zx', '--write'])

		assert.equal(written.status, 0, written.stderr)
		assert.equal(readFileSync(main, 'utf8'), expected)

		const built = fixture.run(['build', 'main.zx', '--out', application, '--optimize', optimize])

		assert.equal(built.status, 0, built.stderr)

		for (const input of [0, 7, 123]) {
			const result = fixture.run([String(input)], application)

			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.equal(result.stdout.trim(), String(2 * (input + 1)))
		}

		assert.equal(readFileSync(main, 'utf8'), expected)

		for (const [path, content] of Object.entries(files))
			assert.equal(readFileSync(join(fixture.root, path), 'utf8'), content)
	} finally {
		fixture.cleanup()
	}
})
