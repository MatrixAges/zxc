import assert from 'node:assert/strict'
import { spawn, spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { once } from 'node:events'
import { existsSync, readFileSync, rmSync, unlinkSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { setTimeout } from 'node:timers/promises'
import createFixture from './fixture.ts'

const executable = resolve(process.argv[2])

test('package watch / missing installation version update and offline mapping recovery', { timeout: 240_000 }, async () => {
	const fixture = createFixture()
	const output = join(fixture.root, process.platform === 'win32' ? 'watched.exe' : 'watched')
	const assembly = join(fixture.root, 'watched.s')
	const child = spawn(executable, ['build', 'apps/left/main.zx', '--watch', '--mode', 'app', '--out', output, '--asm', assembly], { cwd: fixture.project, env: { ...process.env, ZXC_CACHE_DIR: fixture.cache } })
	let stderr = ''
	let failure: Error | undefined
	let closed = false
	child.stdout.resume()
	child.stderr.setEncoding('utf8').on('data', chunk => { stderr += chunk })
	child.on('error', error => { failure = error })
	child.on('close', () => { closed = true })

	async function waitFor(predicate: () => boolean) {
		const deadline = Date.now() + 120_000

		while (!predicate()) {
			if (failure) throw failure
			assert.equal(closed, false, stderr)
			assert.ok(Date.now() < deadline, stderr)
			await setTimeout(100)
		}
	}

	function built(): number {
		return stderr.split('zxc watch: built ').length - 1
	}

	function execute(increment: number): void {
		for (const input of [0, 7, 123]) {
			const result = spawnSync(output, [String(input)], { encoding: 'utf8', timeout: 10_000 })
			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.equal(result.stdout.trim(), String(input + increment))
		}
	}

	function hashes(): Array<string> {
		return [output, assembly].map(path => createHash('sha256').update(readFileSync(path)).digest('hex'))
	}

	try {
		await waitFor(() => stderr.includes('external dependency is not installed; run zxc pkg install'))
		assert.equal(existsSync(output), false)
		assert.equal(existsSync(assembly), false)
		fixture.install()
		await waitFor(() => built() >= 1)
		execute(9)

		let offset = stderr.length
		let baseline = hashes()
		let count = built()
		fixture.writeMember('left', '^2.0.0')
		await waitFor(() => stderr.slice(offset).includes('LockFileOutdated'))
		assert.deepEqual(hashes(), baseline)
		execute(9)
		const updated = fixture.run(['pkg', 'install', '--index', fixture.index])
		assert.equal(updated.status, 0, updated.stderr)
		assert.equal(updated.stdout, 'Installed 5 packages; pkg.lock.json is up to date.\n')
		await waitFor(() => built() > count)
		execute(24)

		const lock = readFileSync(join(fixture.project, 'pkg.lock.json'))
		const digest = createHash('sha256').update(lock).digest('hex')
		const mapping_path = join(fixture.project, '.zxc/packages', digest + '.json')
		const mapping = readFileSync(mapping_path)
		offset = stderr.length
		baseline = hashes()
		count = built()
		unlinkSync(mapping_path)
		await waitFor(() => stderr.slice(offset).includes('external dependency is not installed; run zxc pkg install'))
		assert.deepEqual(hashes(), baseline)
		execute(24)
		rmSync(fixture.registry, { recursive: true })
		const restored = fixture.run(['pkg', 'install', '--offline', '--frozen-lockfile'])
		assert.equal(restored.status, 0, restored.stderr)
		assert.equal(restored.stdout, 'Installed 5 packages; pkg.lock.json is up to date.\n')
		assert.deepEqual(readFileSync(join(fixture.project, 'pkg.lock.json')), lock)
		assert.deepEqual(readFileSync(mapping_path), mapping)
		await waitFor(() => built() > count)
		execute(24)
		assert.equal(closed, false)
	} finally {
		if (!closed) {
			const completion = once(child, 'close')
			child.kill('SIGTERM')
			await completion
		}
		fixture.cleanup()
	}
})
