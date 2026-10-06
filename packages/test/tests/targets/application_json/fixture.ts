import type { Command, Response, Target } from './model.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { copyFileSync, mkdirSync, mkdtempSync, readFileSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { fileURLToPath } from 'node:url'

export default function createFixture(args: { compiler: string; source: string; optimize: string }) {
	const { compiler, source, optimize } = args
	const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-application-json-')))
	const project = join(root, 'project')
	const commands: Array<Command> = []
	const artifacts: Array<{ target: Target; path: string; sha256: string }> = []
	const wasi_host = fileURLToPath(new URL('../wasm/wasi_host.ts', import.meta.url))

	mkdirSync(project)
	copyFileSync(source, join(project, 'main.zx'))

	function run(args: { command: string; argv: Array<string> }): Response {
		const { command, argv } = args
		const result = spawnSync(command, argv, { cwd: project, encoding: 'utf8', timeout: 180_000 })

		commands.push({
			command,
			argv,
			status: result.status,
			signal: result.signal,
			error: result.error?.message ?? null,
			stdout: result.stdout,
			stderr: result.stderr
		})

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.ok(result.status !== null, result.stderr)

		return { status: result.status, output: result.stdout, stderr: result.stderr }
	}

	function build(target: Target): string {
		const output = join(
			root,
			target + (target === 'native' ? (process.platform === 'win32' ? '.exe' : '') : '.wasm')
		)
		const argv = ['build', 'main.zx', '--optimize', optimize, '--result', 'json', '--out', output]

		if (target !== 'native') argv.push('--target', target)

		const result = run({ command: compiler, argv })

		assert.equal(result.status, 0, result.stderr)
		artifacts.push({
			target,
			path: output,
			sha256: createHash('sha256').update(readFileSync(output)).digest('hex')
		})

		return output
	}

	function execute(args: { path: string; target: Target; text: string }): Response {
		const { path, target, text } = args

		return target === 'wasm32-wasi'
			? run({ command: process.execPath, argv: [wasi_host, path, text] })
			: run({ command: path, argv: [text] })
	}

	function close(): void {
		rmSync(root, { recursive: true, force: true })
	}

	return { commands, artifacts, build, execute, close }
}
