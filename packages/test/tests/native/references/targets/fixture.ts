import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdtempSync, realpathSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

export type Command = {
	command: string
	argv: Array<string>
	cwd: string
	status: number | null
	signal: NodeJS.Signals | null
	error: string | null
	stdout: string
	stderr: string
}

export default function createFixture(args: { compiler: string; source: string; entry: string; optimize: string }) {
	const { compiler, source, entry, optimize } = args
	const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-reference-targets-')))
	const project = join(root, 'project')
	const commands: Array<Command> = []

	cpSync(source, project, { recursive: true })
	cpSync(join(source, entry), join(project, 'main.zx'))

	function run(args: { command?: string; argv: Array<string>; cwd?: string; failure?: boolean }) {
		const { command = compiler, argv, cwd = project, failure = false } = args
		const result = spawnSync(command, argv, { cwd, encoding: 'utf8', timeout: 180_000 })

		commands.push({
			command,
			argv,
			cwd,
			status: result.status,
			signal: result.signal,
			error: result.error?.message ?? null,
			stdout: result.stdout ?? '',
			stderr: result.stderr ?? ''
		})
		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)

		if (failure) {
			assert.notEqual(result.status, 0, result.stderr)
			assert.match(result.stderr, /error: UnsupportedHostReference\b/)
		} else assert.equal(result.status, 0, result.stderr)

		return result
	}

	function publish() {
		const library = join(root, 'library')

		run({ argv: ['build', 'main.zx', '--mode', 'lib', '--out', library] })
		writeFileSync(
			join(library, 'consumer.zx'),
			'import run from "references"\n\nimport type { SharedInput, SharedOutput } from "./consumer_types"\n\nexport type Input = SharedInput\n\nexport type Output = SharedOutput\n\nexport default function (in: Input): Output {\n  return run(in)\n}\n'
		)
		writeFileSync(
			join(library, 'consumer_types.zx'),
			'import type { Input, Output } from "references"\n\nexport type SharedInput = Input\n\nexport type SharedOutput = Output\n'
		)

		return library
	}

	function build(args: {
		directory: string
		entry: string
		target: string | null
		policy: 'json' | 'discard'
		output: string
		failure?: boolean
	}) {
		const { directory, entry, target, policy, output, failure = false } = args
		const argv = ['build', entry, '--out', output, '--optimize', optimize, '--result', policy]

		if (target) argv.push('--target', target)

		return run({ argv, cwd: directory, failure })
	}

	function close() {
		rmSync(root, { recursive: true, force: true })
	}

	return { root, project, commands, run, publish, build, close }
}
