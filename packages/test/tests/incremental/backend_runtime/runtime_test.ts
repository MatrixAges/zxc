import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

type Row = { succeeded: boolean; cached: boolean; new_inputs: boolean; published: boolean; errors: number; inputs: number }

const driver = resolve(process.argv[2])
const zig = resolve(process.argv[3])
const library = resolve(process.argv[4])

test('real backend preserves outputs across cache reuse compile failure and prepublication input changes', () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-backend-runtime-'))
	const source = join(directory, 'main.zig')
	const dependency = join(directory, 'value.zig')
	const output = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')
	const environment = { ...process.env, ZIG_GLOBAL_CACHE_DIR: join(directory, 'global') }

	function build(mutation?: { path: string; content: string }): Array<Row> {
		const arguments_list = [source, output, zig, library]

		if (mutation) arguments_list.push(mutation.path, mutation.content)

		const result = spawnSync(driver, arguments_list, { cwd: directory, env: environment, encoding: 'utf8', timeout: 180_000 })

		assert.equal(result.error, undefined)
		assert.equal(result.signal, null)
		assert.equal(result.status, 0, result.stderr)
		const rows = result.stdout.trim().split('\n').map(line => JSON.parse(line) as Row)
		assert.equal(rows.length, 2)
		return rows
	}

	function execute(expected: number) {
		const result = spawnSync(output, [], { encoding: 'utf8', timeout: 10_000 })

		assert.equal(result.error, undefined)
		assert.equal(result.signal, null)
		assert.equal(result.status, expected, result.stderr)
	}

	function hashes(): Array<string> {
		return [output, `${output}.s`].map(path => createHash('sha256').update(readFileSync(path)).digest('hex'))
	}

	try {
		writeFileSync(source, 'pub fn main() u8 { return @import("value.zig").value; }\n')
		writeFileSync(dependency, 'pub const value: u8 = 7;\n')
		const cold = build()

		assert.equal(cold[0].cached, false)
		assert.equal(cold[0].new_inputs, true)
		assert.equal(cold[0].published, false)
		assert.equal(cold[1].cached, true)
		assert.equal(cold[1].new_inputs, false)
		assert.equal(cold[1].published, true)
		assert.ok(cold.every(row => row.succeeded && row.errors === 0 && row.inputs >= 2))
		execute(7)

		const original = hashes()
		const warm = build()
		assert.ok(warm.every(row => row.cached && row.succeeded))
		assert.deepEqual(hashes(), original)
		execute(7)

		writeFileSync(dependency, 'pub const value: u8 = 11;\n')
		const changed = build()
		assert.equal(changed[0].cached, false)
		assert.equal(changed[1].published, true)
		execute(11)
		const updated = hashes()
		assert.notEqual(updated[0], original[0])

		let baseline = updated
		let previous = 11

		for (const mutation of [
			{ path: dependency, content: 'pub const value: u8 = 13;\n', expected: 13 },
			{ path: source, content: 'pub fn main() u8 { return @import("value.zig").value + 2; }\n', expected: 15 },
		]) {
			const interrupted = build(mutation)

			assert.equal(interrupted[1].succeeded, true)
			assert.equal(interrupted[1].cached, true)
			assert.equal(interrupted[1].errors, 0)
			assert.equal(interrupted[1].new_inputs, false)
			assert.equal(interrupted[1].published, false)
			assert.deepEqual(hashes(), baseline)
			execute(previous)

			const recovered = build()
			assert.equal(recovered[0].cached, false)
			assert.equal(recovered[1].published, true)
			execute(mutation.expected)
			const current = hashes()
			assert.notEqual(current[0], baseline[0])
			baseline = current
			previous = mutation.expected
		}

		writeFileSync(dependency, 'pub const value: u8 = missing;\n')
		const failed = build()
		assert.ok(failed.every(row => !row.succeeded && !row.published && row.errors > 0))
		assert.deepEqual(hashes(), baseline)
		execute(previous)
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
})
