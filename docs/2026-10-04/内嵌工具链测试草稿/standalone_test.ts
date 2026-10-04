import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { copyFileSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, renameSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

const original = resolve(process.argv[2])
const extension = process.platform === 'win32' ? '.exe' : ''

test('embedded toolchain / isolated executable lifecycle', async context => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-standalone-'))
	const executable = join(directory, 'zxc' + extension)
	const project = join(directory, 'project')
	const cache = join(directory, 'cache with spaces')
	const environment = { ...process.env, PATH: '', ZIG_LIB_DIR: join(directory, 'absent-library'), ZXC_CACHE_DIR: cache, ZIG_GLOBAL_CACHE_DIR: join(directory, 'zig-global') }

	function run(args: { argv: Array<string>; command?: string; env?: NodeJS.ProcessEnv; failure?: string }): string {
		const { argv, command = executable, env = environment, failure } = args
		const result = spawnSync(command, argv, { cwd: project, env, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.equal(result.status, failure ? 1 : 0, result.stderr)

		if (failure) {
			assert.equal(result.stdout, '')
			assert.equal(result.stderr, failure)
		}

		return result.stdout
	}

	try {
		mkdirSync(project)
		copyFileSync(original, executable)
		writeFileSync(join(project, 'main.zx'), 'export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return in + 3;\n}\n')
		writeFileSync(join(project, 'encoding.zx'), 'import encoding from "std:encoding";\n\nexport type Input = u8[];\n\nexport type Output = string;\n\nexport default function (in: Input): Output {\n  return encoding.encodeHex(in);\n}\n')

		await context.test('embedded index without installation neighbors', () => {
			const index = JSON.parse(run({ argv: ['pkg', 'index'] })) as { format_version: number; packages: Array<unknown> }

			assert.equal(index.format_version, 1)
			assert.ok(Array.isArray(index.packages))
			assert.equal(existsSync(cache), false)
		})

		await context.test('cold cache builds and runs an application', () => {
			const application = join(directory, 'cold' + extension)

			run({ argv: ['build', 'main.zx', '--mode', 'app', '--out', application] })

			for (const input of [0, 7, 123]) assert.equal(run({ command: application, argv: [String(input)] }).trim(), String(input + 3))
		})

		const digest = readdirSync(join(cache, 'toolchains')).find(name => /^[a-f0-9]{64}$/.test(name))

		assert.ok(digest)

		const root = join(cache, 'toolchains', digest)
		const marker = join(root, 'ready')
		const ready = readFileSync(marker, 'utf8')

		assert.equal(ready, digest)

		await context.test('warm cache builds and runs the embedded standard library', () => {
			const application = join(directory, 'standard' + extension)

			run({ argv: ['build', 'encoding.zx', '--mode', 'app', '--out', application] })
			assert.equal(JSON.parse(run({ command: application, argv: [JSON.stringify([104, 105])] })), '6869')
			assert.equal(readFileSync(marker, 'utf8'), ready)
		})

		await context.test('relative cache location is rejected before building', () => {
			const application = join(directory, 'relative' + extension)

			run({ argv: ['build', 'main.zx', '--out', application], env: { ...environment, ZXC_CACHE_DIR: 'relative-cache' }, failure: 'zxc toolchain cache: InvalidZxcCacheDirectory\n' })
			assert.equal(existsSync(application), false)
			assert.equal(existsSync(join(project, 'relative-cache')), false)
		})

		for (const damage of ['missing marker', 'wrong marker', 'missing executable']) {
			await context.test(`incomplete cache / ${damage}`, () => {
				const target = damage === 'missing executable' ? join(root, 'zig', 'zig' + extension) : marker
				const backup = target + '.saved'
				const application = join(directory, damage.replaceAll(' ', '-') + extension)

				renameSync(target, backup)

				try {
					if (damage === 'wrong marker') writeFileSync(marker, '0'.repeat(64))

					run({ argv: ['build', 'main.zx', '--out', application], failure: 'zxc toolchain cache: IncompleteToolchainCache\n' })
					assert.equal(existsSync(application), false)
				} finally {
					if (damage === 'wrong marker') rmSync(marker)

					renameSync(backup, target)
				}
			})
		}
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
})
