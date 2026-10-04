import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, readdirSync } from 'node:fs'
import { join, resolve } from 'node:path'
import Project from '../persistent_cache/fixture.ts'

export default class Fixture extends Project {
	application = join(this.directory, process.platform === 'win32' ? 'application.exe' : 'application')

	build(flags: Array<string> = []) {
		const result = spawnSync(resolve(process.argv[2]), ['build', 'main.zx', '--out', this.application, '--cache-stats', ...flags], { cwd: this.directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null)
		assert.equal(result.status, 0, result.stderr)

		return result.stderr
	}

	execute(increment: number) {
		for (const input of [0, 7, 65535]) {
			const result = spawnSync(this.application, [String(input)], { cwd: this.directory, encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(JSON.parse(result.stdout), input + increment)
		}
	}

	generationFiles() {
		const root = join(this.directory, '.zxc', 'cache', 'zig')
		const versions = readdirSync(root)

		assert.equal(versions.length, 1)

		return readdirSync(join(root, versions[0])).map(name => join(root, versions[0], name)).sort()
	}

	snapshot() {
		return this.generationFiles().map(path => ({ path, content: readFileSync(path, 'hex') }))
	}
}

export function stats(stderr: string, expected: Array<number>) {
	const match = stderr.match(/zxc generation: generated=(\d+) reused=(\d+) loaded=(\d+) written=(\d+) discarded=(\d+) io_errors=(\d+)/)

	assert.ok(match, stderr)
	assert.deepEqual(match.slice(1).map(Number), expected)
}
