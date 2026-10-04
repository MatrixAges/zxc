import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import Fixture, { stats } from './fixture.ts'

test('independent CLI processes persist reuse and execute the generated program', () => {
	const fixture = new Fixture()

	try {
		const cold = fixture.compile()

		stats(cold.stderr, [2, 0, 0, 2, 0, 0])
		assert.equal(fixture.files().length, 2)

		const warm = fixture.compile()

		stats(warm.stderr, [0, 2, 2, 0, 0, 0])
		assert.equal(warm.stdout, cold.stdout)
		writeFileSync(join(fixture.directory, 'program.zig'), warm.stdout)
		writeFileSync(join(fixture.directory, 'run.zig'), 'const std = @import("std");\nconst program = @import("program.zig");\ntest "cached CLI result" {\n    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);\n    defer arena.deinit();\n    try std.testing.expectEqual(@as(u64, 8), try program.execute(&arena, 7));\n}\n')

		const execution = spawnSync(process.argv[3], ['test', 'run.zig'], { cwd: fixture.directory, encoding: 'utf8', timeout: 60_000 })

		assert.ifError(execution.error)
		assert.equal(execution.status, 0, execution.stderr)
	} finally {
		fixture.close()
	}
})

test('helper body change updates output while reusing the caller', () => {
	const fixture = new Fixture()

	try {
		const original = fixture.compile()

		fixture.writeHelper(2)

		const changed = fixture.compile()

		stats(changed.stderr, [1, 1, 2, 1, 0, 0])
		assert.notEqual(changed.stdout, original.stdout)
		assert.equal(changed.stdout, fixture.compile(['--no-cache']).stdout)
		stats(fixture.compile().stderr, [0, 2, 2, 0, 0, 0])
	} finally {
		fixture.close()
	}
})

test('corrupted on disk entry is discarded and repaired', () => {
	const fixture = new Fixture()

	try {
		const expected = fixture.compile().stdout
		const file = fixture.files()[0]

		writeFileSync(file, 'truncated cache')

		const repaired = fixture.compile()

		stats(repaired.stderr, [1, 1, 1, 1, 1, 0])
		assert.equal(repaired.stdout, expected)
		assert.ok(readFileSync(file, 'utf8').startsWith('zxc.module.v1\n'))
		stats(fixture.compile().stderr, [0, 2, 2, 0, 0, 0])
	} finally {
		fixture.close()
	}
})

test('disabled cache neither consumes nor rewrites corrupted entries', () => {
	const fixture = new Fixture()

	try {
		const expected = fixture.compile().stdout
		const files = fixture.files()

		for (const file of files) writeFileSync(file, 'corrupt sentinel')

		const disabled = fixture.compile(['--no-cache'])

		assert.match(disabled.stderr, /zxc cache: disabled/)
		assert.equal(disabled.stdout, expected)

		for (const file of files) assert.equal(readFileSync(file, 'utf8'), 'corrupt sentinel')
	} finally {
		fixture.close()
	}
})

test('cache payload stored under a different module path is discarded', () => {
	const fixture = new Fixture()

	try {
		const expected = fixture.compile().stdout
		const files = fixture.files()
		const first = readFileSync(files[0])
		const second = readFileSync(files[1])

		writeFileSync(files[0], second)
		writeFileSync(files[1], first)

		const repaired = fixture.compile()

		stats(repaired.stderr, [2, 0, 0, 2, 2, 0])
		assert.equal(repaired.stdout, expected)
	} finally {
		fixture.close()
	}
})
