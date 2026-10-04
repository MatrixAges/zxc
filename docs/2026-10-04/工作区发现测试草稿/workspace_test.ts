import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdirSync, mkdtempSync, rmSync, symlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import cases from './workspace_cases.ts'

const executable = resolve(process.argv[2])

function writeFiles(directory: string, files: Record<string, string>): void {
	for (const [path, source] of Object.entries(files)) {
		const target = join(directory, path)

		mkdirSync(dirname(target), { recursive: true })
		writeFileSync(target, source)
	}
}

for (const entry of cases) {
	test(`package workspace / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-workspace-'))
		const workspace = join(directory, 'workspace')

		try {
			const patterns = entry.patterns ? `workspace:\n  packages: ${JSON.stringify(entry.patterns)}\n` : ''

			writeFiles(workspace, { 'pkg.yaml': 'name: root\nversion: 1.0.0\n' + patterns, ...entry.files })
			writeFiles(directory, entry.external ?? {})

			for (const link of entry.links ?? []) {
				const path = join(workspace, link.path)

				mkdirSync(dirname(path), { recursive: true })
				symlinkSync(join(directory, link.target), path, link.type)
			}

			const result = spawnSync(executable, ['pkg', 'workspace'], { cwd: workspace, encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.diagnostic ? 1 : 0, result.stderr)

			if (entry.diagnostic) {
				assert.equal(result.stdout, '')
				assert.match(result.stderr, entry.diagnostic)
			} else {
				assert.equal(result.stderr, '')

				const actual = JSON.parse(result.stdout) as Array<{ path: string; manifest: { name: string } }>

				assert.deepEqual(actual.map(item => [item.path, item.manifest.name]), entry.expected)
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
