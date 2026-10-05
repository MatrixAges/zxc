import type { SpawnSyncReturns } from 'node:child_process'
import { spawnSync } from 'node:child_process'
import assert from 'node:assert/strict'
import { closeSync, cpSync, mkdtempSync, openSync, readFileSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

export default function createFixture(args: { compiler: string; source: string; optimize: string }) {
	const { compiler, source, optimize } = args
	const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-stdio-')))
	const extension = process.platform === 'win32' ? '.exe' : ''

	cpSync(source, join(root, 'source'), { recursive: true })

	function build(args: { entry: string; policy: 'json' | 'discard' }) {
		const { entry, policy } = args
		const executable = join(root, `${entry}-${policy}${extension}`)
		const result = spawnSync(
			compiler,
			['build', join(root, 'source', entry), '--out', executable, '--optimize', optimize, '--result', policy],
			{ cwd: root, encoding: 'utf8', timeout: 180_000 }
		)

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, 0, result.stderr)

		return executable
	}

	function run(args: {
		executable: string
		input: Buffer
		max_bytes: number
		failure?: string
		extra?: Array<string>
		redirect?: boolean
	}) {
		const { executable, input, max_bytes, failure, extra = [], redirect = false } = args
		const stdout_path = join(root, 'stdout.bin')
		const stderr_path = join(root, 'stderr.bin')
		const descriptors = redirect ? [openSync(stdout_path, 'w'), openSync(stderr_path, 'w')] : []
		let result: SpawnSyncReturns<Buffer>

		try {
			result = spawnSync(executable, [String(max_bytes), ...extra], {
				cwd: root,
				input,
				timeout: 30_000,
				maxBuffer: 1024 * 1024,
				stdio: redirect ? ['pipe', descriptors[0], descriptors[1]] : 'pipe'
			})
		} finally {
			for (const descriptor of descriptors) closeSync(descriptor)
		}

		if (redirect) {
			result.stdout = readFileSync(stdout_path)
			result.stderr = readFileSync(stderr_path)
		}

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr.toString())

		if (failure) {
			assert.notEqual(result.status, 0)
			assert.ok(result.stderr.toString().includes(failure), result.stderr.toString())
			assert.equal(result.stdout.length, 0)
		} else assert.equal(result.status, 0, result.stderr.toString())

		return result
	}

	return {
		build,
		run,
		close() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
