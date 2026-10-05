import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import cases from './cli_cases.ts'

const executable = resolve(process.argv[2])
const optimize = process.argv[3]

for (const entry of cases) {
	test(`ZX import paths / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-import-paths-'))
		const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')

		try {
			for (const [path, source] of Object.entries(entry.files)) {
				const destination = join(directory, path)

				mkdirSync(dirname(destination), { recursive: true })
				writeFileSync(destination, source)
			}

			const result = spawnSync(
				executable,
				['build', 'app/main.zx', '--out', application, '--optimize', optimize],
				{
					cwd: directory,
					encoding: 'utf8',
					timeout: 180_000
				}
			)

			assert.ifError(result.error)
			assert.equal(result.signal, null)

			if ('diagnostic' in entry.outcome) {
				assert.equal(result.status, 1, result.stderr)
				assert.match(result.stderr, entry.outcome.diagnostic)
				assert.equal(existsSync(application), false)
			} else {
				assert.equal(result.status, 0, result.stderr)

				for (const input of [0, 7, 123]) {
					const execution = spawnSync(application, [String(input)], {
						cwd: directory,
						encoding: 'utf8',
						timeout: 10_000
					})

					assert.ifError(execution.error)
					assert.equal(execution.signal, null)
					assert.equal(execution.status, 0, execution.stderr)
					assert.equal(execution.stderr, '')
					assert.equal(execution.stdout.trim(), String(input + entry.outcome.increment))
				}
			}

			for (const [path, source] of Object.entries(entry.files))
				assert.equal(readFileSync(join(directory, path), 'utf8'), source)
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
