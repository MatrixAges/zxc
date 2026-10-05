import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import cases from './cli_cases.ts'

const executable = resolve(process.argv[2])
const optimize = process.argv[3]
const helper = `import process from "std:process"

export type Input = string[][]

export type Output = string[][]

export default function (in: Input): Output {
  process.writeStdoutText("source\\n")

  return in
}
`

function run(args: { command: string; argv: Array<string>; directory: string }) {
	const { command, argv, directory } = args
	const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null)

	return result
}

for (const once of [false, true]) {
	test(`forEach CLI / ${once ? 'receiver evaluated once' : 'direct receiver'} / ordered effects and early failure`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc forEach '))
		const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')
		const source = `import process from "std:process"
${once ? '\nimport source from "./source"\n' : ''}
export type Input = string[][]

export type Output = void

export default function (in: Input): Output {
  ${once ? 'source(in)' : 'in'}.forEach(row => process.writeStdoutText(row[0]))

  process.writeStdoutText("done\\n")
}
`

		try {
			writeFileSync(join(directory, 'main.zx'), source)
			if (once) writeFileSync(join(directory, 'source.zx'), helper)

			const built = run({
				command: executable,
				argv: ['build', 'main.zx', '--out', application, '--optimize', optimize, '--result', 'discard'],
				directory
			})

			assert.equal(built.status, 0, built.stderr)

			for (const entry of cases) {
				const result = run({ command: application, argv: [JSON.stringify(entry.input)], directory })

				assert.equal(result.status, entry.failure ? 1 : 0, entry.name + ': ' + result.stderr)
				assert.equal(result.stdout, (once ? 'source\n' : '') + entry.output, entry.name)

				if (entry.failure) assert.ok(result.stderr.includes(entry.failure), entry.name + ': ' + result.stderr)
				else assert.equal(result.stderr, '', entry.name)
			}

			assert.equal(readFileSync(join(directory, 'main.zx'), 'utf8'), source)
			if (once) assert.equal(readFileSync(join(directory, 'source.zx'), 'utf8'), helper)
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}

test('forEach RX / void callback result is evaluated and failures propagate', () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc RX forEach '))
	const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')
	const source =
		'<Module>\n  <Call fn="./noop" in={$in.forEach(row => row[0] + 1)}/>\n  <Return value={$in.length}/>\n</Module>\n'

	try {
		writeFileSync(join(directory, 'main.rx'), source)
		writeFileSync(
			join(directory, 'noop.zx'),
			'export type Input = void\n\nexport type Output = void\n\nexport default function (in: Input): Output {\n  return\n}\n'
		)

		const built = run({
			command: executable,
			argv: ['build', 'main.rx', '--out', application, '--optimize', optimize],
			directory
		})

		assert.equal(built.status, 0, built.stderr)

		for (const input of [[], [[3]], [[0], [7]], [[]], [[2], []]]) {
			const failing = input.some(row => row.length === 0)
			const result = run({ command: application, argv: [JSON.stringify(input)], directory })

			assert.equal(result.status, failing ? 1 : 0, result.stderr)

			if (failing) {
				assert.equal(result.stdout, '')
				assert.match(result.stderr, /IndexOutOfBounds/)
			} else {
				assert.equal(result.stdout.trim(), String(input.length))
				assert.equal(result.stderr, '')
			}
		}

		assert.equal(readFileSync(join(directory, 'main.rx'), 'utf8'), source)
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
})
