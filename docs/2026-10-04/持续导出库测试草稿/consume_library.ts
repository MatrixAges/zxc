import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

export type Manifest = {
	entry_dependencies: Array<string>
	generated_modules: Array<{ name: string; path: string; dependencies: Array<string> }>
}

export default function consume(args: { directory: string; zig: string; expected: number }) {
	const { directory, zig, expected } = args
	const manifest = JSON.parse(readFileSync(join(directory, 'library.json'), 'utf8')) as Manifest
	writeFileSync(join(directory, 'consumer_test.zig'), `const std = @import("std");\nconst library = @import("library");\n\ntest "consume watched library" {\n    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);\n    defer arena.deinit();\n\n    try std.testing.expectEqual(@as(u64, ${expected}), try library.execute(&arena, 7));\n}\n`)
	const arguments_list = ['test', '--dep', 'library', '-Mroot=consumer_test.zig', '--dep', 'zxc_abi', ...manifest.entry_dependencies.flatMap(name => ['--dep', name]), '-Mlibrary=root.zig', '-Mzxc_abi=abi.zig']

	for (const module of manifest.generated_modules) {
		arguments_list.push('--dep', 'zxc_abi', ...module.dependencies.flatMap(name => ['--dep', name]), `-M${module.name}=${module.path}`)
	}

	const result = spawnSync(zig, arguments_list, { cwd: directory, encoding: 'utf8', timeout: 120_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null)
	assert.equal(result.status, 0, result.stderr)
}
