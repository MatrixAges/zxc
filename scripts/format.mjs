import { globSync } from 'node:fs'
import { readFile, writeFile } from 'node:fs/promises'
import { createSpacer } from 'gpu-code-spacer'

const args = process.argv.slice(2)
const check_only = args.includes('--check')
const requested_files = args.filter(arg => arg !== '--check')

const files =
	requested_files.length > 0
		? requested_files
		: globSync([
				'build.zig',
				'build.zig.zon',
				'packages/*/build.zig',
				'packages/*/build.zig.zon',
				'packages/*/src/**/*.zig',
				'packages/*/examples/**/*.zig',
				'packages/*/tests/**/*.zig',
				'legacy/build.zig',
				'legacy/build.zig.zon',
				'legacy/src/**/*.zig',
				'legacy/tests/**/*.zig'
			])

const spacer = await createSpacer()

try {
	for (const file of files) {
		const source = await readFile(file, 'utf8')
		const { text } = await spacer.format(source)

		if (text === source) continue

		console.log(file)

		if (check_only) {
			process.exitCode = 1
		} else {
			await writeFile(file, text)
		}
	}
} finally {
	await spacer.destroy()
}
