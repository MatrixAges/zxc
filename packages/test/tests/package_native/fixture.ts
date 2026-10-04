import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { stringify } from 'yaml'
import writeArchive from './archive.ts'

const executable = resolve(process.argv[2])
export const application_source = 'import left from "left"\nimport right from "right"\n\nexport type Input = i32\n\nexport type Output = { left: i32\n right: i32 }\n\nexport default function (in: Input): Output {\n  return { left: left(in), right: right(in) }\n}\n'

export default function createFixture(aggregate: boolean) {
	const root = mkdtempSync(join(tmpdir(), 'zxc-native-package-'))
	const project = join(root, 'project')
	const registry = join(root, 'registry')
	mkdirSync(project)
	mkdirSync(registry)
	const packages = ['left', 'right'].map((name, index) => {
		const increment = index === 0 ? 3 : 22
		const input = aggregate ? (index === 0 ? '{ value: in }' : '{ value: in, delta: 11 }') : 'in'
		const declaration = aggregate ? `export type Request = { value: i32
${index === 0 ? '' : ' delta: i32'} }

export declare function apply(input: Request): i32
` : 'export declare function apply(input: i32): i32\n'
		const implementation = aggregate ? `const Request = @import("zxc_abi").native.@"zig:bridge".Request;\n\npub fn apply(input: Request) i32 {\n    return input.value + ${index === 0 ? '3' : 'input.delta * 2'};\n}\n` : `pub fn apply(input: i32) i32 {\n    return input + ${increment};\n}\n`
		const manifest = { name, version: '1.0.0', entry: 'main.zx', native_interfaces: [{ specifier: 'zig:bridge', path: 'bridge.d.zx', module: 'bridge' }], native_modules: [{ name: 'bridge', path: 'bridge.zig' }] }
		const release = writeArchive(join(registry, `${name}.tgz`), {
			'pkg.yaml': stringify(manifest),
			'main.zx': `import bridge from "zig:bridge"

export type Input = i32

export type Output = i32

export default function (in: Input): Output {
  return bridge.apply(${input})
}
`,
			'bridge.d.zx': declaration,
			'bridge.zig': implementation,
		})

		return { name, versions: [{ version: '1.0.0', ...release }] }
	})
	writeFileSync(join(registry, 'index.json'), JSON.stringify({ format_version: 1, packages }))
	writeFileSync(join(project, 'pkg.yaml'), stringify({ name: 'combined', version: '1.0.0', entry: 'main.zx', dependencies: { left: '^1.0.0', right: '^1.0.0' } }))
	writeFileSync(join(project, 'main.zx'), application_source)

	function run(args: Array<string>, cwd = project): void {
		const result = spawnSync(executable, args, { cwd, env: { ...process.env, ZXC_CACHE_DIR: join(root, 'cache') }, encoding: 'utf8', timeout: 180_000 })
		assert.ifError(result.error)
		assert.equal(result.signal, null)
		assert.equal(result.status, 0, result.stderr)
	}

	function execute(output: string): void {
		for (const input of [-4, 0, 23]) {
			const result = spawnSync(output, [String(input)], { encoding: 'utf8', timeout: 10_000 })
			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.deepEqual(JSON.parse(result.stdout), { left: input + 3, right: input + 22 })
		}
	}

	return { root, project, registry, run, execute, cleanup() { rmSync(root, { recursive: true, force: true }) } }
}
