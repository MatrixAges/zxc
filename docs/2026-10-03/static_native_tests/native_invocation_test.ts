import assert from 'node:assert/strict'
import { cpSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

type Run = (args: { command: string; argv: Array<string>; cwd: string; failure?: string }) => string

export default function checkNativeInvocation(args: { directory: string; executable: string; run: Run }): void {
	const { directory, executable, run } = args
	const project = join(directory, 'native_invocation')
	cpSync(new URL('./native_declarations', import.meta.url), project, { recursive: true })
	writeFileSync(
		join(project, 'zxc.json'),
		JSON.stringify({
			native_interfaces: [
				{
					specifier: 'zig:invocation',
					path: 'invocation.d.zx',
					module: 'invocation',
					namespace: ['nested', 'api']
				}
			],
			native_modules: [{ name: 'invocation', path: 'invocation.zig' }]
		})
	)
	const application = join(project, process.platform === 'win32' ? 'application.exe' : 'application')

	run({ command: executable, argv: ['build', 'invocation.zx', '--out', application], cwd: project })

	for (const left of [0, 1, 17, 255, 65535]) {
		for (const right of [0, 1, 17, 255, 65535]) {
			const output: unknown = JSON.parse(
				run({ command: application, argv: [JSON.stringify({ left, right })], cwd: project })
			)

			assert.deepEqual(output, {
				seed: 17,
				allocated_seed: 19,
				combined: left * 3 + right,
				items: [left, right, left + right]
			})
		}
	}

	console.log('Native invocation: 25 inputs passed zero/multiple arguments, allocator and namespace execution')
}
