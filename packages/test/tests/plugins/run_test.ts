import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import checkBridge from './bridge_test.ts'

const fixtures = dirname(fileURLToPath(import.meta.url))
const compiler_dir = resolve(process.argv[2])
const runtime = join(compiler_dir, 'src/runtime/root.zig')
const directory = mkdtempSync(join(tmpdir(), 'zxc-plugin-protocol-'))
const extension = process.platform === 'darwin' ? '.dylib' : process.platform === 'win32' ? '.dll' : '.so'
const kinds = ['good', 'version', 'size', 'flags', 'empty', 'large', 'duplicate', 'empty_name', 'no_entry']

function run(argv: Array<string>): void {
	const result = spawnSync('zig', argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stderr)

	if (result.stderr) process.stdout.write(result.stderr)
}

try {
	run(['test', '--dep', 'runtime', `-Mroot=${join(fixtures, 'wire_test.zig')}`, `-Mruntime=${runtime}`])

	const paths: Array<string> = []

	for (const kind of kinds) {
		const library = join(directory, kind + extension)
		const config = join(directory, kind + '.zig')

		writeFileSync(config, `pub const kind = "${kind}";\n`)
		run([
			'build-lib',
			'-dynamic',
			'-lc',
			'-O',
			'ReleaseSafe',
			`-femit-bin=${library}`,
			'--dep',
			'runtime',
			'--dep',
			'config',
			`-Mroot=${join(fixtures, 'fixtures/plugin.zig')}`,
			`-Mruntime=${runtime}`,
			`-Mconfig=${config}`
		])
		paths.push(`pub const ${kind} = ${JSON.stringify(library)};`)
	}

	const path_module = join(directory, 'paths.zig')

	writeFileSync(path_module, paths.join('\n') + '\n')
	run([
		'test',
		'-lc',
		'--dep',
		'runtime',
		'--dep',
		'paths',
		`-Mroot=${join(fixtures, 'protocol_test.zig')}`,
		`-Mruntime=${runtime}`,
		`-Mpaths=${path_module}`
	])
	checkBridge({ directory, compiler_dir, library: join(directory, 'good' + extension) })
	console.log('Plugin protocol: real dynamic libraries, descriptors, JSON values and allocation failures passed')
} finally {
	rmSync(directory, { recursive: true, force: true })
}
