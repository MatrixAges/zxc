import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

const executable = resolve(process.argv[2])
const optimize = process.argv[3]

export default function fixture() {
	const directory = mkdtempSync(join(tmpdir(), 'zxc RX value policy '))
	const originals = new Map<string, string>()
	const fixtures = join(import.meta.dirname, 'fixtures')

	for (const name of readdirSync(fixtures)) {
		const source = readFileSync(join(fixtures, name), 'utf8')

		writeFileSync(join(directory, name), source)
		originals.set(name, source)
	}

	function run(command: string, argv: Array<string>) {
		const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		directory,
		build(entry: string, application: string) {
			return run(executable, ['build', entry, '--out', application, '--optimize', optimize])
		},
		execute(application: string, input: unknown) {
			return run(application, [JSON.stringify(input)])
		},
		cleanup() {
			try {
				for (const [name, source] of originals)
					assert.equal(readFileSync(join(directory, name), 'utf8'), source)
			} finally {
				rmSync(directory, { recursive: true, force: true })
			}
		}
	}
}
