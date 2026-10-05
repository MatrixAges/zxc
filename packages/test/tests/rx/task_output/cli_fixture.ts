import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

const fixtures = resolve(process.argv[2])
const executable = resolve(process.argv[3])
const optimize = process.argv[4]

export default function fixture(source: string) {
	const directory = mkdtempSync(join(tmpdir(), 'zxc task output '))
	const originals = new Map<string, string>([['main.rx', source]])

	for (const name of readdirSync(fixtures)) originals.set(name, readFileSync(join(fixtures, name), 'utf8'))

	originals.set('task.zx', originals.get('number.zx')!)

	for (const [name, text] of originals) writeFileSync(join(directory, name), text)

	const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')

	function run(command: string, argv: Array<string>) {
		const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		application,
		build() {
			return run(executable, ['build', 'main.rx', '--out', application, '--optimize', optimize])
		},
		execute(input: unknown) {
			return run(application, [JSON.stringify(input)])
		},
		cleanup() {
			try {
				for (const [name, text] of originals) assert.equal(readFileSync(join(directory, name), 'utf8'), text)
			} finally {
				rmSync(directory, { recursive: true, force: true })
			}
		}
	}
}
