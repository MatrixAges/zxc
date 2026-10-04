import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { stringify } from 'yaml'

const executable = resolve(process.argv[2])
export const zig = resolve(process.argv[3])
export const solver = process.env.ZXC_TEST_SOLVER ?? 'z3'
export const public_exports = {
	'.': 'identity.zx',
	'./alias': 'identity.zx',
	'./workflow': 'flow.rx',
	'./toggle': 'invert.zx',
	'./types': 'types.zx'
}

export function snapshot(directory: string): Record<string, string> {
	return Object.fromEntries(
		readdirSync(directory, { recursive: true, withFileTypes: true })
			.filter(entry => entry.isFile())
			.map(entry => {
				const path = join(entry.parentPath, entry.name)
				return [path.slice(directory.length + 1), readFileSync(path).toString('base64')]
			})
	)
}

export default function createFixture() {
	const root = mkdtempSync(join(tmpdir(), 'zxc unified publication '))
	const source = join(root, 'source')
	const published = join(root, 'published')
	const environment = { ...process.env, ZXC_CACHE_DIR: join(root, 'cache') }
	cpSync(new URL('fixtures/source', import.meta.url), source, { recursive: true })
	manifest(public_exports)

	function manifest(exports: Record<string, string>): void {
		writeFileSync(join(source, 'pkg.yaml'), stringify({ name: 'bundle', version: '1.0.0', exports }))
	}

	function run(args: { command?: string; argv: Array<string>; cwd?: string }) {
		const { command = executable, argv, cwd = source } = args
		const result = spawnSync(command, argv, { cwd, env: environment, encoding: 'utf8', timeout: 180_000 })
		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	function publish(solver_path = solver) {
		return run({ argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', published, '--solver', solver_path] })
	}

	function consumer() {
		const directory = join(root, 'consumer')
		mkdirSync(join(directory, 'pkgs'), { recursive: true })
		cpSync(published, join(directory, 'pkgs', 'bundle'), { recursive: true })
		cpSync(new URL('fixtures/consumer/main.zx', import.meta.url), join(directory, 'main.zx'))
		writeFileSync(
			join(directory, 'pkg.yaml'),
			stringify({
				name: 'consumer',
				version: '1.0.0',
				entry: 'main.zx',
				workspace: { packages: ['pkgs/*'] },
				dependencies: { bundle: 'workspace:*' }
			})
		)
		rmSync(source, { recursive: true })
		rmSync(published, { recursive: true })

		return directory
	}

	return {
		root,
		source,
		published,
		run,
		publish,
		manifest,
		consumer,
		cleanup() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
