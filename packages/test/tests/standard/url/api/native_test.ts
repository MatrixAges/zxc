import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { copyFileSync, mkdtempSync, readdirSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { readRows } from '../../../../src/shared/json.ts'

const [compiler_path, source_path, zig_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const source = realpathSync(source_path)
const zig = realpathSync(zig_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-url-native-')))
const emitter = fileURLToPath(new URL('../../../../src/emit_control_tests.ts', import.meta.url))
let total = 0

function run(command: string, argv: Array<string>): void {
	const result = spawnSync(command, argv, { cwd: root, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stderr)
}

try {
	copyFileSync(join(source, 'native_build.zig'), join(root, 'build.zig'))
	copyFileSync(join(source, 'native_build.zig.zon'), join(root, 'build.zig.zon'))
	copyFileSync(new URL('../../../support/collections.zig', import.meta.url), join(root, 'support.zig'))

	for (const directory of readdirSync(source, { withFileTypes: true }).filter(entry => entry.isDirectory())) {
		const path = join(source, directory.name, 'cases')

		rmSync(join(root, 'library'), { recursive: true, force: true })
		run(compiler, ['build', `${path}.zx`, '--mode', 'lib', '--out', join(root, 'library')])
		run(process.execPath, [emitter, `${path}.jsonl`, join(root, 'cases.zig')])
		run(zig, [
			'build',
			'--build-file',
			join(root, 'build.zig'),
			`-Doptimize=${optimize}`,
			'-j2',
			'--summary',
			'all'
		])

		const count = readRows(`${path}.jsonl`).length

		total += count
		console.log(`${directory.name}: ${count} native library cases passed`)
	}

	assert.equal(total, 6193)
	console.log(`${total} URL cases passed through standalone Zig library consumers (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
