import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

const executable = resolve(process.argv[2])

export default function createFixture() {
	const root = mkdtempSync(join(tmpdir(), 'zxc import order '))

	function run(argv: Array<string>, command = executable) {
		const result = spawnSync(command, argv, {
			cwd: root,
			encoding: 'utf8',
			timeout: 180_000,
			env: { ...process.env, ZXC_CACHE_DIR: join(root, 'cache') }
		})

		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		root,
		run,
		cleanup() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
