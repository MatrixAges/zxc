import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, rmSync, symlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import cases from './import_cases.ts'
import export_cases from './export_import_cases.ts'

const executable = resolve(process.argv[2])

function writeFiles(directory: string, files: Record<string, string>): void {
	for (const [path, source] of Object.entries(files)) {
		mkdirSync(dirname(join(directory, path)), { recursive: true })
		writeFileSync(join(directory, path), source)
	}
}

for (const entry of [...cases, ...export_cases]) {
	test(`package imports / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-package-import-'))
		const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')

		try {
			writeFiles(directory, { 'main.zx': entry.source, 'pkg.yaml': stringify({ name: 'root', version: '1.0.0', entry: 'main.zx', workspace: { packages: entry.patterns ?? ['pkgs/*'] }, dependencies: entry.dependencies, dev_dependencies: entry.dev_dependencies }), ...entry.files })

			for (const [path, member] of Object.entries(entry.members)) {
				const { name, dependencies, source, files } = member
				const target = member.entry === null ? undefined : member.entry ?? 'main.zx'

				writeFiles(join(directory, 'pkgs', path), { 'main.zx': source, 'pkg.yaml': stringify({ name, version: '1.2.3', entry: target, exports: member.exports, dependencies }), ...files })
			}

			for (const [path, target] of Object.entries(entry.links ?? {})) symlinkSync(join(directory, target), join(directory, path), 'file')

			const result = spawnSync(executable, ['build', entry.entry ?? 'main.zx', '--mode', 'app', '--out', application], { cwd: directory, encoding: 'utf8', timeout: 180_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)

			if (entry.diagnostic) {
				assert.equal(result.status, 1, result.stderr)
				assert.ok(result.stderr.includes(entry.diagnostic), result.stderr)
				assert.equal(existsSync(application), false)
			} else {
				assert.equal(result.status, 0, result.stderr)

				for (const input of [0, 7, 123]) {
					const execution = spawnSync(application, [String(input)], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

					assert.ifError(execution.error)
					assert.equal(execution.signal, null)
					assert.equal(execution.status, 0, execution.stderr)
					assert.equal(execution.stderr, '')
					assert.equal(execution.stdout.trim(), String(input + entry.increment!))
				}
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
