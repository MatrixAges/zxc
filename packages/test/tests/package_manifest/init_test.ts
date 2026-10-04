import assert from 'node:assert/strict'
import { spawn, spawnSync } from 'node:child_process'
import { existsSync, lstatSync, mkdirSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { parse } from 'yaml'
import cases from './init_cases.ts'

const executable = resolve(process.argv[2])

for (const entry of cases) {
	test(`package init / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-init-'))

		try {
			const result = spawnSync(executable, ['pkg', 'init', ...entry.args], { cwd: directory, encoding: 'utf8', timeout: 10_000 })
			const path = join(directory, 'pkg.yaml')

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.diagnostic ? 1 : 0, result.stderr)
			assert.equal(result.stderr, entry.diagnostic ?? '')
			assert.equal(result.stdout, entry.diagnostic ? '' : 'Created pkg.yaml\n')

			if (entry.diagnostic) {
				assert.equal(existsSync(path), false)
			} else {
				assert.deepEqual(parse(readFileSync(path, 'utf8')), entry.expected)

				const inspected = spawnSync(executable, ['pkg', 'inspect'], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

				assert.ifError(inspected.error)
				assert.equal(inspected.status, 0, inspected.stderr)
				assert.equal(inspected.stderr, '')

				const actual = JSON.parse(inspected.stdout) as Record<string, unknown>

				for (const [key, value] of Object.entries(entry.expected!)) assert.deepEqual(actual[key], value)
				assert.equal(actual.private, entry.expected!.private ?? false)
				assert.equal(actual.entry, entry.expected!.entry ?? null)
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}

for (const kind of ['file', 'directory', 'symlink', 'dangling symlink']) {
	test(`package init / preserves existing ${kind}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-init-existing-'))
		const path = join(directory, 'pkg.yaml')
		const target = join(directory, 'target.yaml')
		const original = 'existing bytes\nnot required to be YAML\n'

		try {
			if (kind === 'file') writeFileSync(path, original)
			else if (kind === 'directory') mkdirSync(path)
			else {
				if (kind === 'symlink') writeFileSync(target, original)

				symlinkSync(target, path)
			}

			const result = spawnSync(executable, ['pkg', 'init', 'sample'], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 1)
			assert.equal(result.stdout, '')
			assert.equal(result.stderr, 'pkg.yaml: PathAlreadyExists\n')

			if (kind === 'file') assert.equal(readFileSync(path, 'utf8'), original)
			else if (kind === 'directory') assert.equal(lstatSync(path).isDirectory(), true)
			else {
				assert.equal(lstatSync(path).isSymbolicLink(), true)

				if (kind === 'symlink') assert.equal(readFileSync(target, 'utf8'), original)
				else assert.equal(existsSync(target), false)
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}

test('package init / concurrent exclusive creation', async () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-init-race-'))

	try {
		const results = await Promise.all(Array.from({ length: 8 }, (_, index) => new Promise<{ index: number; status: number | null }>((resolve, reject) => {
			const child = spawn(executable, ['pkg', 'init', `sample-${index}`], { cwd: directory, stdio: 'ignore', timeout: 10_000 })

			child.on('error', reject)
			child.on('close', (status, signal) => signal ? reject(new Error(signal)) : resolve({ index, status }))
		})))
		const winners = results.filter(result => result.status === 0)

		assert.equal(winners.length, 1)
		assert.equal(results.filter(result => result.status === 1).length, 7)
		assert.deepEqual(parse(readFileSync(join(directory, 'pkg.yaml'), 'utf8')), { name: `sample-${winners[0].index}`, version: '0.1.0' })
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
})
