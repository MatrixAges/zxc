import assert from 'node:assert/strict'
import { spawn, spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { once } from 'node:events'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, unlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { setTimeout } from 'node:timers/promises'

const compiler = resolve(process.argv[2])

function header(increment: number): string {
	return `static inline double bump(double value) { return value + ${increment}.0; }\n`
}

test('watch discovers initially missing C header and preserves outputs through deletion and recovery', { timeout: 300_000 }, async () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-watch-header-'))
	const project = join(directory, 'project')
	const include = join(project, 'include')
	const output = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')
	const assembly = join(directory, 'app.s')
	mkdirSync(include, { recursive: true })
	writeFileSync(join(project, 'pkg.yaml'), 'name: watch-header\nversion: 0.0.0\ninclude_paths: [include]\nnative_modules:\n  - name: bridge\n    header: late.h\nnative_interfaces:\n  - specifier: c:bridge\n    path: bridge.d.zx\n    module: bridge\n    namespace: [c]\n')
	writeFileSync(join(project, 'bridge.d.zx'), 'export declare function bump(value: f64): f64\n')
	writeFileSync(join(project, 'main.zx'), 'import bridge from "c:bridge"\n\nexport type Input = f64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n  return bridge.bump(in)\n}\n')
	const path = join(include, 'late.h')
	const child = spawn(compiler, ['build', 'main.zx', '--watch', '--out', output, '--asm', assembly], { cwd: project, stdio: 'pipe' })
	let stderr = ''
	let closed = false
	let failure: Error | undefined
	child.stderr.setEncoding('utf8').on('data', chunk => { stderr += chunk })
	child.stdout.resume()
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

	function execute(increment: number) {
		for (const input of [-2, 0, 9]) {
			const result = spawnSync(output, [String(input)], { encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(JSON.parse(result.stdout), input + increment)
		}
	}

	function hashes(): Array<string> {
		return [output, assembly].map(file => createHash('sha256').update(readFileSync(file)).digest('hex'))
	}

	try {
		await waitFor(() => /late\.h.*(?:not found|No such file)/.test(stderr))
		assert.equal(existsSync(output), false)
		assert.equal(existsSync(assembly), false)
		const initial = stderr
		await setTimeout(5_000)
		assert.equal(stderr, initial, 'unchanged backend diagnostics should remain quiet')
		assert.equal(closed, false)
		writeFileSync(path, header(2))
		await waitFor(() => built() >= 1)
		execute(2)

		let count = built()
		writeFileSync(path, header(5))
		await waitFor(() => built() > count)
		execute(5)
		const baseline = hashes()
		const offset = stderr.length
		unlinkSync(path)
		await waitFor(() => /late\.h.*(?:not found|No such file)/.test(stderr.slice(offset)))
		assert.deepEqual(hashes(), baseline)
		execute(5)

		count = built()
		writeFileSync(path, header(9))
		await waitFor(() => built() > count)
		execute(9)
		assert.equal(closed, false)
	} finally {
		if (!closed) {
			const completion = once(child, 'close')
			child.kill('SIGTERM')
			await completion
		}

		rmSync(directory, { recursive: true, force: true })
	}
})
