import { spawn, spawnSync } from 'node:child_process'
import assert from 'node:assert/strict'
import { cpSync, mkdtempSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

export default function createApplication(args: { compiler: string; source: string; optimize: string }) {
	const { compiler, source, optimize } = args
	const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-http-')))

	cpSync(source, root, { recursive: true })

	function build(entry: string) {
		const executable = join(root, `${entry}${process.platform === 'win32' ? '.exe' : '.app'}`)
		const result = spawnSync(compiler, ['build', join(root, entry), '--out', executable, '--optimize', optimize], {
			cwd: root,
			timeout: 180_000,
			encoding: 'utf8'
		})

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, 0, result.stderr)

		return executable
	}

	async function run(args: { executable: string; input: unknown; failure?: string }) {
		const { executable, input, failure } = args
		const result = await new Promise<{ stdout: string; stderr: string; code: number | null }>((resolve, reject) => {
			const child = spawn(executable, [JSON.stringify(input)], { cwd: root, stdio: ['ignore', 'pipe', 'pipe'] })
			const stdout: Array<Buffer> = []
			const stderr: Array<Buffer> = []
			const timer = setTimeout(() => {
				child.kill()
				reject(new Error('HTTP test application timed out'))
			}, 30_000)

			child.stdout.on('data', bytes => stdout.push(bytes))
			child.stderr.on('data', bytes => stderr.push(bytes))
			child.on('error', error => {
				clearTimeout(timer)
				reject(error)
			})
			child.on('close', (code, signal) => {
				clearTimeout(timer)

				if (signal) return reject(new Error(`HTTP application stopped by ${signal}`))

				resolve({ stdout: Buffer.concat(stdout).toString(), stderr: Buffer.concat(stderr).toString(), code })
			})
		})

		if (failure) {
			assert.notEqual(result.code, 0)
			assert.ok(result.stderr.includes(failure), result.stderr)
			assert.equal(result.stdout, '')

			return null
		}

		assert.equal(result.code, 0, result.stderr)
		assert.equal(result.stderr, '')

		return JSON.parse(result.stdout) as {
			status: number
			headers: Array<{ name: string; value: string | Array<number> }>
			body: string | Array<number>
		}
	}

	return {
		build,
		run,
		close() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
