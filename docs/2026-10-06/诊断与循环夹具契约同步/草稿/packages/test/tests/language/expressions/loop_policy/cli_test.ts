import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

const executable = resolve(process.argv[2])
const optimize = process.argv[3]
const header = 'export type Input = u64[]\n\nexport type Output = u64\n\n'
const cases = [
	{
		file: 'main.zx',
		source:
			header +
			'export default function (in: Input): Output {\n  in.forEach(item => item)\n\n  return in.length\n}\n',
		message: 'unknown list operation'
	},
	{
		file: 'main.zx',
		source: header + 'export default function (in: Input): Output {\n  return in.forEach(item => item)\n}\n',
		message: 'unknown list operation'
	},
	{
		file: 'main.rx',
		source: '<Module>\n  <Return value={$in.forEach(item => item)}/>\n</Module>\n',
		message: 'RX values cannot contain calls or callbacks'
	},
	{
		file: 'main.zx',
		source: 'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return iterate(in)\n}\n',
		message: 'unknown imported function'
	},
	{
		file: 'main.rx',
		source: '<Module>\n  <Return value={iterate($in)}/>\n</Module>\n',
		message: 'RX values cannot contain calls or callbacks'
	}
]

function fixture() {
	const directory = mkdtempSync(join(tmpdir(), 'zxc loop policy '))

	function run(args: { argv: Array<string>; command?: string }) {
		const { argv, command = executable } = args
		const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		directory,
		run,
		cleanup() {
			rmSync(directory, { recursive: true, force: true })
		}
	}
}

test('ZX and RX reject removed APIs without producing applications or modifying input files', () => {
	const current = fixture()

	try {
		for (const [index, entry] of cases.entries()) {
			const source = join(current.directory, entry.file)
			const application = join(current.directory, `rejected_${index}`)

			writeFileSync(source, entry.source)

			const result = current.run({ argv: ['build', entry.file, '--out', application, '--optimize', optimize] })

			assert.equal(result.status, 1, result.stderr)
			assert.ok(result.stderr.includes(entry.message), result.stderr)
			assert.equal(result.stdout, '')
			assert.equal(existsSync(application), false)
			assert.equal(readFileSync(source, 'utf8'), entry.source)
		}
	} finally {
		current.cleanup()
	}
})

test('ordinary imported names loop and iterate remain callable and independent void calls still execute', () => {
	const current = fixture()
	const helper =
		'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in + 1\n}\n'

	try {
		writeFileSync(join(current.directory, 'helper.zx'), helper)

		for (const name of ['loop', 'iterate', 'void']) {
			const source =
				name === 'void'
					? 'import process from "std:process"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  process.writeStdoutText("V|")\n\n  return in\n}\n'
					: `import ${name} from "./helper"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return ${name}(in)\n}\n`
			const application = join(current.directory, process.platform === 'win32' ? `${name}.exe` : name)

			writeFileSync(join(current.directory, 'main.zx'), source)

			const built = current.run({ argv: ['build', 'main.zx', '--out', application, '--optimize', optimize] })

			assert.equal(built.status, 0, built.stderr)

			for (const input of [0, 7, 123]) {
				const result = current.run({ command: application, argv: [JSON.stringify(input)] })

				assert.equal(result.status, 0, result.stderr)
				assert.equal(result.stderr, '')
				assert.equal(result.stdout, name === 'void' ? `V|${input}\n` : `${input + 1}\n`)
			}

			assert.equal(readFileSync(join(current.directory, 'main.zx'), 'utf8'), source)
			assert.equal(readFileSync(join(current.directory, 'helper.zx'), 'utf8'), helper)
		}
	} finally {
		current.cleanup()
	}
})
