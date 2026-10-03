import type { Command } from './command'
import type Migration from './migration'
import { spawn, spawnSync } from 'node:child_process'
import { mkdirSync, rmSync, writeFileSync } from 'node:fs'
import { delimiter, resolve } from 'node:path'
import { canonical } from './values'

export function describe(args: { migration: Migration; command: Command; input?: string }) {
	const { migration, command, input } = args
	const argv = command.argv.map(item => migration.expand(item, input))
	const cwd = canonical(resolve(migration.base, migration.expand(command.cwd)))
	const executable = argv[0]!
	const search = (
		Object.entries(migration.environment).find(([name]) =>
			process.platform === 'win32' ? name.toUpperCase() === 'PATH' : name === 'PATH'
		)?.[1] ?? ''
	)
		.split(delimiter)
		.map(path => resolve(cwd, path))
		.join(delimiter)
	const found = /[/\\]/.test(executable) ? resolve(cwd, executable) : Bun.which(executable, { PATH: search, cwd })

	if (!found) throw new Error(`Command executable not found: ${executable}`)

	argv[0] = canonical(found)

	return { argv, cwd, timeout_seconds: command.timeout_seconds }
}

export async function locked<T>(directory: string, execute: () => Promise<T>): Promise<T> {
	mkdirSync(directory, { recursive: true })

	const lock = resolve(directory, 'execution.lock')

	mkdirSync(lock)

	try {
		writeFileSync(
			resolve(lock, 'owner.json'),
			JSON.stringify({ pid: process.pid, started: new Date().toISOString() })
		)

		return await execute()
	} finally {
		rmSync(lock, { recursive: true })
	}
}

export async function run(args: { migration: Migration; command: Command; input?: string }) {
	const { migration, command, input } = args
	const { argv, cwd, timeout_seconds } = describe({ migration, command, input })
	const killer = process.platform === 'win32' ? Bun.which('taskkill') : null

	if (process.platform === 'win32' && !killer) throw new Error('taskkill is required to stop timed-out process trees')

	return await new Promise<{
		argv: Array<string>
		cwd: string
		exit_code: number | null
		signal: string | null
		timed_out: boolean
		stdout: Buffer
		stderr: Buffer
	}>((resolveResult, reject) => {
		const child = spawn(argv[0]!, argv.slice(1), {
			cwd,
			env: migration.environment,
			detached: true,
			stdio: ['ignore', 'pipe', 'pipe'],
			windowsHide: true
		})
		const stdout: Array<Buffer> = []
		const stderr: Array<Buffer> = []
		let timed_out = false
		const timer = setTimeout(() => {
			timed_out = true

			if (!child.pid) return
			if (killer)
				spawnSync(killer, ['/PID', String(child.pid), '/T', '/F'], { stdio: 'ignore', windowsHide: true })
			else {
				try {
					process.kill(-child.pid, 'SIGKILL')
				} catch (error) {
					if (!(error instanceof Error && 'code' in error && error.code === 'ESRCH')) reject(error)
				}
			}
		}, timeout_seconds * 1000)

		child.stdout.on('data', (block: Buffer) => stdout.push(block))
		child.stderr.on('data', (block: Buffer) => stderr.push(block))
		child.on('error', error => {
			clearTimeout(timer)
			reject(error)
		})
		child.on('close', (exit_code, signal) => {
			clearTimeout(timer)
			resolveResult({
				argv,
				cwd,
				exit_code,
				signal,
				timed_out,
				stdout: Buffer.concat(stdout),
				stderr: Buffer.concat(stderr)
			})
		})
	})
}
