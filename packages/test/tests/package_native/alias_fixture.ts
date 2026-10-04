import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { existsSync, mkdtempSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { stringify } from 'yaml'

type Alias = { name: string; specifier: string }

const executable = resolve(process.argv[2])

export default function checkAliases(args: { aliases?: Array<Alias>; access: string; second_access?: string; error?: RegExp; preserve_output?: boolean; assembly?: boolean }): void {
	const { aliases, access, second_access, error, preserve_output, assembly } = args
	const root = mkdtempSync(join(tmpdir(), 'zxc-native-alias-'))
	const output = join(root, process.platform === 'win32' ? 'application.exe' : 'application')
	const assembly_path = join(root, 'application.s')
	const output_paths = assembly ? [output, assembly_path] : [output]

	try {
		const manifest = {
			name: 'alias-sample',
			version: '1.0.0',
			native_interfaces: [{ specifier: 'zig:first', path: 'first.d.zx', module: 'first' }, { specifier: 'zig:second', path: 'second.d.zx', module: 'second' }],
			native_modules: [{ name: 'first', path: 'first.zig', ...(aliases === undefined ? {} : { abi_aliases: aliases }) }, { name: 'second', path: 'second.zig' }],
		}

		writeFileSync(join(root, 'pkg.yaml'), stringify(manifest))
		writeFileSync(join(root, 'first.d.zx'), 'export type Request = { value: i32 }\n\nexport declare function apply(input: Request): i32\n')
		writeFileSync(join(root, 'second.d.zx'), 'export type Request = { value: i32\n delta: i32 }\n\nexport declare function apply(input: Request): i32\n')
		writeFileSync(join(root, 'second.zig'), 'pub fn apply(input: anytype) i32 {\n    return input.value + input.delta;\n}\n')
		writeFileSync(join(root, 'first.zig'), `const Request = @import("zxc_abi").native.@"${access}".Request;\n${second_access ? `const Forwarded = @import("zxc_abi").native.@"${second_access}".Request;\n` : ''}\npub fn apply(input: Request) i32 {\n${second_access ? '    const forwarded: Forwarded = input;\n\n    return forwarded.value + 7;' : '    return input.value + 7;'}\n}\n`)
		writeFileSync(join(root, 'main.zx'), 'import first from "zig:first"\n\nexport type Input = i32\n\nexport type Output = i32\n\nexport default function (in: Input): Output {\n  return first.apply({ value: in })\n}\n')

		function build() {
			const result = spawnSync(executable, ['build', 'main.zx', '--out', output, ...(assembly ? ['--asm', assembly_path] : [])], { cwd: root, env: { ...process.env, ZXC_CACHE_DIR: join(root, 'cache') }, encoding: 'utf8', timeout: 180_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)

			return result
		}

		function outputHashes(): Array<string> {
			return output_paths.map(path => createHash('sha256').update(readFileSync(path)).digest('hex'))
		}

		function execute(): void {
			for (const input of [-9, 0, 31]) {
				const result = spawnSync(output, [String(input)], { encoding: 'utf8', timeout: 10_000 })
	
				assert.ifError(result.error)
				assert.equal(result.signal, null)
				assert.equal(result.status, 0, result.stderr)
				assert.equal(result.stderr, '')
				assert.equal(JSON.parse(result.stdout), input + 7)
			}
		}

		let previous_hashes: Array<string> | undefined

		if (preserve_output) {
			const initial = structuredClone(manifest)

			delete initial.native_modules[0].abi_aliases
			writeFileSync(join(root, 'pkg.yaml'), stringify(initial))

			const baseline = build()

			assert.equal(baseline.status, 0, baseline.stderr)
			execute()

			for (const path of output_paths) assert.ok(statSync(path).size > 0, path)

			previous_hashes = outputHashes()

			writeFileSync(join(root, 'pkg.yaml'), stringify(manifest))
		}

		const built = build()

		if (error) {
			assert.equal(built.status, 1, built.stderr)
			assert.match(built.stderr, error)

			if (previous_hashes === undefined) {
				for (const path of output_paths) assert.equal(existsSync(path), false, `failed build left output: ${path}`)

				return
			}

			assert.deepEqual(outputHashes(), previous_hashes, 'failed build changed previously published artifacts')
		} else {
			assert.equal(built.status, 0, built.stderr)
		}

		execute()
	} finally {
		rmSync(root, { recursive: true, force: true })
	}
}
