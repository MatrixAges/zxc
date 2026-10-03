import assert from 'node:assert/strict'
import { cpSync, existsSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { stringify } from 'yaml'

type Run = (args: { command: string; argv: Array<string>; cwd: string; failure?: string }) => string

export default function checkNativeDeclaration(args: { directory: string; executable: string; run: Run }): void {
	const { directory, executable, run } = args
	const project = join(directory, 'native_declarations')
	cpSync(new URL('./native_declarations', import.meta.url), project, { recursive: true })
	writeFileSync(
		join(project, 'pkg.yaml'),
		stringify({
			name: 'library',
			version: '0.0.0',
			...{
				native_interfaces: [{ specifier: 'zig:bridge', path: 'bridge.d.zx', module: 'bridge' }],
				native_modules: [{ name: 'bridge', path: 'bridge.zig' }]
			}
		})
	)

	const application = join(project, process.platform === 'win32' ? 'application.exe' : 'application')

	run({ command: executable, argv: ['build', 'main.zx', '--out', application], cwd: project })

	for (const size of [0, 1, 9]) {
		for (const offset of [0, 3]) {
			for (const mode of [null, 'Add', 'Keep']) {
				for (const baseline_size of [0, 2]) {
					const items = Array.from({ length: size }, (_, index) => ({ value: index * 7 - 12 }))
					const baseline = Array.from({ length: baseline_size }, (_, index) => ({ value: index + 91 }))
					const input = { items, baseline, offset, mode }
					const expected = {
						items: items.map(item => ({ value: item.value + (mode === 'Add' ? offset : 0) })),
						baseline,
						mode
					}
					const output: unknown = JSON.parse(
						run({ command: application, argv: [JSON.stringify(input)], cwd: project })
					)

					assert.deepEqual(output, expected)
				}
			}
		}
	}

	const rejected = { items: [{ value: 1 }], baseline: [{ value: 2 }], offset: -1, mode: 'Add' }
	const output = run({
		command: application,
		argv: [JSON.stringify(rejected)],
		cwd: project,
		failure: 'NegativeOffset'
	})

	assert.equal(output, '')

	const library = join(project, 'library')

	run({ command: executable, argv: ['build', 'main.zx', '--mode', 'lib', '--out', library], cwd: project })
	assert.equal(existsSync(join(library, 'runtime')), false)
	cpSync(join(project, 'resources_test.zig'), join(library, 'resources_test.zig'))
	run({
		command: 'zig',
		argv: [
			'test',
			'--dep',
			'library',
			'-Mroot=resources_test.zig',
			'--dep',
			'bridge',
			'--dep',
			'zxc_abi',
			'-Mlibrary=root.zig',
			'--dep',
			'zxc_abi',
			'-Mbridge=native/bridge/source/bridge.zig',
			'-Mzxc_abi=abi.zig'
		],
		cwd: library
	})
	console.log(
		'Native declarations: 72 aggregate reference calls, native error propagation and two allocation failure traversals passed'
	)
}
