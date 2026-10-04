import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import cases from './cases.ts'

const executable = resolve(process.argv[2])

for (const entry of cases) {
	test(`package index / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-index-'))

		try {
			writeFileSync(join(directory, 'index.json'), JSON.stringify(entry.index))

			const result = spawnSync(executable, ['pkg', ...entry.args, 'index.json'], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.diagnostic ? 1 : 0, result.stderr)
			assert.equal(result.stderr, entry.diagnostic ?? '')

			if (entry.diagnostic) assert.equal(result.stdout, '')
			else assert.deepEqual(JSON.parse(result.stdout), entry.expected)
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
