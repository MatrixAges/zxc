import assert from 'node:assert/strict'
import { spawn, spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { once } from 'node:events'
import { mkdirSync, mkdtempSync, readFileSync, rmSync, unlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import { setTimeout } from 'node:timers/promises'
import { files, helper } from './project_cases.ts'

const compiler = resolve(process.argv[2])

test('RX watch tracks transitive ZX edits and recovers from RX errors and deleted imports', { timeout: 240_000 }, async () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-rx-watch-'))
	const project = join(directory, 'project')
	const output = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')

	mkdirSync(project)

	for (const [name, source] of Object.entries(files)) {
		const path = join(project, name)

		mkdirSync(dirname(path), { recursive: true })
		writeFileSync(path, source)
	}

	const dependency = join(project, 'functions/helper.zx')
	const service = join(project, 'flows/forward.rx')
	const child = spawn(compiler, ['build', 'main.rx', '--watch', '--out', output], { cwd: project, stdio: 'pipe' })
	let stderr = ''
	let failure: Error | undefined
	let closed = false
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
		for (const input of [0, 7, 19]) {
			const result = spawnSync(output, [String(input)], { encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(JSON.parse(result.stdout), (input + increment) * 2)
		}
	}

	function hash(): string {
		return createHash('sha256').update(readFileSync(output)).digest('hex')
	}

	try {
		await waitFor(() => built() >= 1)
		execute(3)
		let count = built()
		writeFileSync(dependency, helper(5))
		await waitFor(() => built() > count)
		execute(5)
		let baseline = hash()
		let offset = stderr.length
		writeFileSync(service, "<Module><Return value='missing'/></Module>")
		await waitFor(() => /forward\.rx:1:\d+: name:/.test(stderr.slice(offset)))
		assert.equal(hash(), baseline)
		execute(5)

		count = built()
		writeFileSync(dependency, helper(8))
		writeFileSync(service, files['flows/forward.rx'])
		await waitFor(() => built() > count)
		execute(8)
		baseline = hash()
		offset = stderr.length
		unlinkSync(dependency)
		await waitFor(() => /module: import target is missing from the source set/.test(stderr.slice(offset)))
		assert.equal(hash(), baseline)
		execute(8)

		count = built()
		writeFileSync(dependency, helper(2))
		await waitFor(() => built() > count)
		execute(2)
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
