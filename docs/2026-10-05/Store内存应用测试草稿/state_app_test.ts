import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { cpSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

const compiler = resolve(process.argv[2])

function files(directory: string): Record<string, string> {
	const result: Record<string, string> = {}

	for (const entry of readdirSync(directory, { withFileTypes: true })) {
		const path = join(directory, entry.name)

		if (entry.isDirectory()) {
			for (const [name, digest] of Object.entries(files(path))) result[`${entry.name}/${name}`] = digest
		} else result[entry.name] = createHash('sha256').update(readFileSync(path)).digest('hex')
	}

	return result
}

function run(args: { command: string; argv: Array<string>; directory: string }): string {
	const { command, argv, directory } = args
	const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stderr)

	return result.stdout
}

test('RX native Store uses application memory and fresh process initialization', async context => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc store memory '))
	const project = join(directory, 'source project')
	const execution = join(directory, 'execution directory')
	const application = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')

	try {
		mkdirSync(project)

		for (const name of [
			'main.rx',
			'write_left.rx',
			'write_right.rx',
			'left.store.rx',
			'right.store.rx',
			'advance.zx',
			'snapshot.zx'
		]) {
			cpSync(new URL(`../runtime/store/dual/fixtures/${name}`, import.meta.url), join(project, name))
		}
		mkdirSync(execution)
		run({ command: compiler, argv: ['build', 'main.rx', '--out', application], directory: project })

		const baseline = files(directory)

		for (const increment of [0, 1, 7, 42, 65535]) {
			await context.test(`two Object calls with increment ${increment}`, () => {
				const output: unknown = JSON.parse(
					run({ command: application, argv: [String(increment)], directory: execution })
				)

				assert.deepEqual(output, {
					before_left: { value: 3, history: [8] },
					before_right: { value: 100, history: [50] },
					untouched: { value: 100, history: [50] },
					after_left: { value: 3 + increment, history: [9] },
					after_right: { value: 100 + increment, history: [51] },
					first: 3 + increment,
					second: 100 + increment
				})
			})
		}

		await context.test('restart uses declarations and does not restore the previous process', () => {
			const first = run({ command: application, argv: ['7'], directory: execution })

			run({ command: application, argv: ['42'], directory: execution })
			assert.equal(run({ command: application, argv: ['7'], directory: execution }), first)
		})

		await context.test('execution creates no state artifacts and changes no project files', () => {
			assert.deepEqual(readdirSync(execution), [])
			assert.deepEqual(files(directory), baseline)
		})
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
})
