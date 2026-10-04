import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { stringify } from 'yaml'

const executable = resolve(process.argv[2])
export const pure_artifact = resolve(process.argv[3])
export const mixed_artifact = resolve(process.argv[4])
export const exports_map = {
	'.': { module: 'alpha' },
	'./nested/beta': { module: 'beta' },
	'./again': { module: 'repeat' }
}

export function program(expression: string, imports = 'import run from "calc"\n'): string {
	return `${imports}\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output { return ${expression} }\n`
}

export default function createFixture(
	args: { artifact?: string; source?: string; package_name?: string; dependency_name?: string } = {}
) {
	const {
		artifact = pure_artifact,
		source = program('run(in)'),
		package_name = 'calc',
		dependency_name = package_name
	} = args
	const root = mkdtempSync(join(tmpdir(), 'zxc compiled package '))
	const member = join(root, 'pkgs', 'calc')
	const application = join(root, process.platform === 'win32' ? 'application.exe' : 'application')
	const environment = { ...process.env, ZXC_CACHE_DIR: join(root, 'cache') }
	mkdirSync(member, { recursive: true })
	cpSync(artifact, join(member, 'library.zxcir'))
	write('main.zx', source)
	write(
		'pkg.yaml',
		stringify({
			name: 'consumer',
			version: '1.0.0',
			entry: 'main.zx',
			workspace: { packages: ['pkgs/*'] },
			dependencies: { [dependency_name]: `workspace:${package_name}@*` }
		})
	)
	manifest({ exports: exports_map })

	function write(path: string, source: string | Uint8Array): void {
		mkdirSync(dirname(join(root, path)), { recursive: true })
		writeFileSync(join(root, path), source)
	}

	function manifest(fields: Record<string, unknown>): void {
		write(
			'pkgs/calc/pkg.yaml',
			stringify({ name: package_name, version: '1.0.0', library: 'library.zxcir', ...fields })
		)
	}

	function build(extra: Array<string> = []) {
		const result = spawnSync(executable, ['build', 'main.zx', '--mode', 'app', '--out', application, ...extra], {
			cwd: root,
			env: environment,
			encoding: 'utf8',
			timeout: 180_000
		})
		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	function execute(input: unknown) {
		const result = spawnSync(application, [JSON.stringify(input)], { cwd: root, encoding: 'utf8', timeout: 10_000 })
		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		root,
		member,
		application,
		write,
		manifest,
		build,
		execute,
		cleanup() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
