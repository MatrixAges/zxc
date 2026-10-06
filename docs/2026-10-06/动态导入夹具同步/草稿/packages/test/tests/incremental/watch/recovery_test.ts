import assert from 'node:assert/strict'
import { spawn, spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { once } from 'node:events'
import { mkdirSync, mkdtempSync, readFileSync, rmSync, unlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { setTimeout } from 'node:timers/promises'

const compiler = resolve(process.argv[2])

function helper(increment: number): string {
	return `export type Input = f64

export type Output = f64

export default function (in: Input): Output {
  return in + ${increment}
}
`
}

test(
	'watch CLI preserves published artifacts and recovers from edited invalid and missing dependencies',
	{ timeout: 240_000 },
	async () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-watch-recovery-'))
		const project = join(directory, 'project')
		const output = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')
		const assembly = join(directory, 'app.s')
		mkdirSync(project)
		writeFileSync(join(project, 'pkg.yaml'), 'name: watch-recovery\nversion: 0.0.0\n')
		writeFileSync(
			join(project, 'main.zx'),
			'import helper from "./helper"\n\nexport type Input = f64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n  return helper(in)\n}\n'
		)
		const dependency = join(project, 'helper.zx')
		writeFileSync(dependency, helper(1))
		const child = spawn(compiler, ['build', 'main.zx', '--watch', '--out', output, '--asm', assembly], {
			cwd: project,
			stdio: 'pipe'
		})
		let stderr = ''
		let failure: Error | undefined
		let closed = false
		child.stderr.setEncoding('utf8').on('data', chunk => {
			stderr += chunk
		})
		child.stdout.resume()
		child.on('error', error => {
			failure = error
		})
		child.on('close', () => {
			closed = true
		})

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
			return [output, assembly].map(path => createHash('sha256').update(readFileSync(path)).digest('hex'))
		}

		try {
			await waitFor(() => built() >= 1)
			execute(1)
			let count = built()
			writeFileSync(dependency, helper(3))
			await waitFor(() => built() > count)
			execute(3)
			let baseline = hashes()
			let offset = stderr.length
			writeFileSync(dependency, 'export type Input = \n')
			await waitFor(() => /syntax/.test(stderr.slice(offset)))
			assert.deepEqual(hashes(), baseline)
			execute(3)

			count = built()
			writeFileSync(dependency, helper(8))
			await waitFor(() => built() > count)
			execute(8)
			baseline = hashes()
			offset = stderr.length
			unlinkSync(dependency)
			await waitFor(() => /module: import target is missing from the source set/.test(stderr.slice(offset)))
			assert.deepEqual(hashes(), baseline)
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
	}
)
