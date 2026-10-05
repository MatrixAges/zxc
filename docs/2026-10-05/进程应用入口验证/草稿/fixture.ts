import type { SpawnSyncReturns } from 'node:child_process'
import { spawnSync } from 'node:child_process'
import assert from 'node:assert/strict'
import { cpSync, mkdirSync, mkdtempSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

export default function createFixture(args: { compiler: string; source: string; optimize: string }) {
	const { compiler, source, optimize } = args
	const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-process-entry-')))
	const project = join(root, 'project')
	const cwd = join(root, 'runtime 目录')
	const extension = process.platform === 'win32' ? '.exe' : ''
	const environment = { ...process.env, ZXC_PROCESS_CONTEXT_VALUE: 'controlled value 🌿' }
	let sequence = 0

	cpSync(source, project, { recursive: true })
	mkdirSync(cwd)

	function run(args: {
		command: string
		argv: Array<string>
		failure?: string
		env?: NodeJS.ProcessEnv
		directory?: string
	}): SpawnSyncReturns<string> {
		const { command, argv, failure, env = environment, directory = cwd } = args
		const result = spawnSync(command, argv, { cwd: directory, env, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)

		if (failure) {
			assert.notEqual(result.status, 0)
			assert.ok(result.stderr.includes(failure), result.stderr)
		} else assert.equal(result.status, 0, result.stderr)

		return result
	}

	function buildApp(args: { entry: string; policy?: 'json' | 'discard'; output?: string }): string {
		const { entry, policy, output } = args
		const executable = output ?? join(root, `application-${sequence++}${extension}`)
		const argv = ['build', join(project, entry), '--out', executable, '--optimize', optimize]

		if (policy) argv.push('--result', policy)

		run({ command: compiler, argv, directory: project })

		return executable
	}

	return {
		root,
		project,
		cwd,
		environment,
		compiler,
		buildApp,
		run,
		close() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
