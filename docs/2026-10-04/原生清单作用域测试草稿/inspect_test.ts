import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import cases from './inspect_cases.ts'
import native_cases from './native_cases.ts'
import module_scope_cases from './module_scope_cases.ts'

const executable = resolve(process.argv[2])

for (const entry of [...cases, ...native_cases, ...module_scope_cases]) {
	test(`package manifest / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-manifest-'))

		try {
			writeFileSync(join(directory, 'pkg.yaml'), entry.source)

			const result = spawnSync(executable, ['pkg', 'inspect'], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.diagnostic ? 1 : 0, result.stderr)

			if (entry.diagnostic) {
				assert.equal(result.stdout, '')

				const { line, column, message } = entry.diagnostic

				assert.equal(result.stderr, `pkg.yaml:${line}:${column}: manifest: ${message}\n`)
			} else {
				assert.equal(result.stderr, '')

				const actual = JSON.parse(result.stdout) as Record<string, unknown>

				for (const [key, value] of Object.entries(entry.expected!)) assert.deepEqual(actual[key], value, key)
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
