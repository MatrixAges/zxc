import type { Manifest } from './consume_library.ts'
import assert from 'node:assert/strict'
import { spawn } from 'node:child_process'
import { createHash } from 'node:crypto'
import { once } from 'node:events'
import { mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { setTimeout } from 'node:timers/promises'
import consume from './consume_library.ts'

const compiler = resolve(process.argv[2])
const zig = resolve(process.argv[3])

function helper(increment: number): string {
	return `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return in + ${increment}
}
`
}

test('watch library exports remain consumable preserve user files and recover after syntax failure', { timeout: 240_000 }, async () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-watch-library-'))
	const project = join(directory, 'project')
	const library = join(directory, 'library')
	mkdirSync(project)
	mkdirSync(library)
	writeFileSync(join(library, 'keep.txt'), 'user-owned content\n')
	writeFileSync(join(project, 'pkg.yaml'), 'name: watch-library\nversion: 0.0.0\n')
	writeFileSync(join(project, 'main.zx'), 'import helper from "./helper.zx"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return helper(in)\n}\n')
	const dependency = join(project, 'helper.zx')
	writeFileSync(dependency, helper(2))
	const child = spawn(compiler, ['build', 'main.zx', '--watch', '--mode', 'lib', '--out', library], { cwd: project, stdio: 'pipe' })
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

	function snapshot(): Array<string> {
		const manifest = JSON.parse(readFileSync(join(library, 'library.json'), 'utf8')) as Manifest
		const files = ['root.zig', 'abi.zig', 'library.json', ...manifest.generated_modules.map(module => module.path)]

		return files.map(path => `${path}:${createHash('sha256').update(readFileSync(join(library, path))).digest('hex')}`)
	}

	function check(expected: number) {
		consume({ directory: library, zig, expected })
		assert.equal(readFileSync(join(library, 'keep.txt'), 'utf8'), 'user-owned content\n')
	}

	try {
		await waitFor(() => built() >= 1)
		check(9)
		const original = snapshot()
		let count = built()
		writeFileSync(dependency, helper(5))
		await waitFor(() => built() > count)
		check(12)
		const updated = snapshot()
		assert.notDeepEqual(updated, original)
		const offset = stderr.length
		writeFileSync(dependency, 'export type Input = \n')
		await waitFor(() => /syntax/.test(stderr.slice(offset)))
		assert.deepEqual(snapshot(), updated)
		check(12)

		count = built()
		writeFileSync(dependency, helper(9))
		await waitFor(() => built() > count)
		check(16)
		assert.notDeepEqual(snapshot(), updated)
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
