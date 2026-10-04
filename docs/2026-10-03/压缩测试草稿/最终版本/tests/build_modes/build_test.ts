import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, renameSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import checkCompression from '../standard/zlib/compression_test.ts'
import checkNativeBundle from './native_bundle_test.ts'
import checkNativeDeclaration from './native_declaration_test.ts'
import checkNativeInvocation from './native_invocation_test.ts'

const compiler_dir = resolve(process.argv[2])
const directory = mkdtempSync(join(tmpdir(), 'zxc-build-modes-'))
const extension = process.platform === 'win32' ? '.exe' : ''

function run(args: { command: string; argv: Array<string>; cwd: string; failure?: string }): string {
	const { command, argv, cwd, failure } = args
	const result = spawnSync(command, argv, { cwd, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	if (failure) {
		assert.notEqual(result.status, 0)
		assert.ok(result.stderr.includes(failure), result.stderr)
	} else assert.equal(result.status, 0, `${command} ${argv.join(' ')}\n${result.stderr}`)

	return result.stdout
}

try {
	const installation = join(directory, 'installed')

	run({ command: 'zig', argv: ['build', '--prefix', installation, '-Doptimize=ReleaseSafe'], cwd: compiler_dir })

	const executable = join(installation, 'bin', 'zxc' + extension)
	const project = join(directory, 'original')

	mkdirSync(join(project, 'nested'), { recursive: true })
	writeFileSync(join(project, 'nested', 'increment.zx'), 'export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return in + 3;\n}\n')
	writeFileSync(join(project, 'main.zx'), 'import increment from "./nested/increment.zx";\n\nexport type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return increment(in);\n}\n')

	const application = join(directory, 'application' + extension)

	run({ command: executable, argv: ['build', 'main.zx', '--mode', 'app', '--out', application], cwd: project })
	assert.equal(run({ command: application, argv: ['7'], cwd: directory }).trim(), '10')

	const library = join(directory, 'library')
	const moved = join(directory, 'relocated library')

	run({ command: executable, argv: ['build', 'main.zx', '--mode', 'lib', '--out', library], cwd: project })
	renameSync(library, moved)
	rmSync(project, { recursive: true })

	const manifest = JSON.parse(readFileSync(join(moved, 'library.json'), 'utf8')) as { format_version: number; native_sources_bundled: boolean }

	assert.equal(manifest.format_version, 1)
	assert.equal(manifest.native_sources_bundled, false)
	assert.equal(existsSync(join(moved, 'runtime')), false)
	run({ command: 'zig', argv: ['build'], cwd: moved })

	writeFileSync(join(moved, 'consumer_test.zig'), 'const std = @import("std");\nconst library = @import("library");\n\ntest "consume relocated library" {\n    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);\n    defer arena.deinit();\n\n    try std.testing.expectEqual(@as(u64, 10), try library.execute(&arena, 7));\n}\n')
	run({ command: 'zig', argv: ['test', '--dep', 'library', '-Mroot=consumer_test.zig', '-Mlibrary=root.zig'], cwd: moved })

	writeFileSync(join(moved, 'consumer.zx'), 'import increment from "library";\n\nexport type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return increment(in);\n}\n')
	const consumer = join(directory, 'consumer' + extension)

	run({ command: executable, argv: ['build', 'consumer.zx', '--out', consumer], cwd: moved })
	assert.equal(run({ command: consumer, argv: ['9'], cwd: directory }).trim(), '12')
	assert.equal(run({ command: application, argv: ['0'], cwd: directory }).trim(), '3')

	checkNativeBundle({ directory, executable, run })
	checkNativeDeclaration({ directory, executable, run })
	checkNativeInvocation({ directory, executable, run })
	checkCompression({ directory, executable, run })
	console.log('Build modes: app, relocated Zig library and relocated ZX library passed')
} finally {
	rmSync(directory, { recursive: true, force: true })
}
