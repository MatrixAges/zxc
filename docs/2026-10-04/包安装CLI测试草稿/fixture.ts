import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { stringify } from 'yaml'
import createRegistry, { source } from './registry.ts'

const executable = resolve(process.argv[2])

export default function createFixture() {
	const root = mkdtempSync(join(tmpdir(), 'zxc-package-install-'))
	const project = join(root, 'project')
	const cache = join(root, 'cache')
	const registry = join(root, 'registry')
	const index = createRegistry(registry)
	const environment = { ...process.env, ZXC_CACHE_DIR: cache }
	mkdirSync(project)
	writeFileSync(join(project, 'pkg.yaml'), stringify({ name: 'root', version: '1.0.0', workspace: { packages: ['apps/*'] } }))

	for (const [name, requirement] of [['left', '^1.0.0'], ['right', '^2.0.0']]) {
		mkdirSync(join(project, 'apps', name), { recursive: true })
		writeMember(name, requirement)
		writeFileSync(join(project, 'apps', name, 'main.zx'), source(0, 'calc'))
	}

	function writeMember(name: string, requirement: string): void {
		writeFileSync(join(project, 'apps', name, 'pkg.yaml'), stringify({ name, version: '1.0.0', entry: 'main.zx', dependencies: { calc: requirement } }))
	}

	function run(args: Array<string>) {
		const result = spawnSync(executable, args, { cwd: project, env: environment, encoding: 'utf8', timeout: 180_000 })
		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	function install(args: Array<string> = []): void {
		const result = run(['pkg', 'install', '--index', index, ...args])
		assert.equal(result.status, 0, result.stderr)
		assert.equal(result.stderr, '')
		assert.equal(result.stdout, 'Installed 7 packages; pkg.lock.json is up to date.\n')
	}

	function metadata(): Record<string, string> {
		const entries: Record<string, string> = { 'pkg.lock.json': readFileSync(join(project, 'pkg.lock.json'), 'utf8') }
		for (const name of readdirSync(join(project, '.zxc/packages'))) entries[name] = readFileSync(join(project, '.zxc/packages', name), 'utf8')

		return entries
	}

	function execute(name: string, increment: number): void {
		const output = join(root, name + (process.platform === 'win32' ? '.exe' : ''))
		rmSync(output, { force: true })
		const built = run(['build', `apps/${name}/main.zx`, '--mode', 'app', '--out', output])
		assert.equal(built.status, 0, built.stderr)

		for (const input of [0, 7, 123]) {
			const result = spawnSync(output, [String(input)], { encoding: 'utf8', timeout: 10_000 })
			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.equal(result.stdout.trim(), String(input + increment))
		}
	}

	return { root, project, cache, registry, index, run, install, metadata, execute, writeMember, cleanup() { rmSync(root, { recursive: true, force: true }) } }
}
