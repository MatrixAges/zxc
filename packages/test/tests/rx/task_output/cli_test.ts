import assert from 'node:assert/strict'
import { existsSync, readFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import fixture from './cli_fixture.ts'

type Case = {
	name: string
	source: string
	diagnostic?: { code: string; marker: string; last: boolean; message?: string }
	runs?: Array<{ input: unknown; output: unknown }>
}

const cases = JSON.parse(readFileSync(join(import.meta.dirname, 'cases.json'), 'utf8')) as Array<Case>

for (const entry of cases) {
	test(`RX CLI task output ${entry.name}`, () => {
		const current = fixture(entry.source)

		try {
			const built = current.build()

			if (entry.diagnostic) {
				const expected = entry.diagnostic
				const offset = expected.last
					? entry.source.lastIndexOf(expected.marker)
					: entry.source.indexOf(expected.marker)
				const prefix = entry.source.slice(0, offset).split('\n')
				const location = `main.rx:${prefix.length}:${Buffer.byteLength(prefix.at(-1)!) + 1}: ${expected.code}:`

				assert.ok(offset >= 0)
				assert.equal(built.status, 1, built.stderr)
				assert.ok(built.stderr.includes(location), built.stderr)
				if (expected.message) assert.ok(built.stderr.includes(expected.message), built.stderr)
				assert.equal(built.stdout, '')
				assert.equal(existsSync(current.application), false)

				return
			}

			assert.equal(built.status, 0, built.stderr)
			assert.equal(built.stderr, '')
			assert.ok(entry.runs && entry.runs.length > 0)

			for (const sample of entry.runs) {
				const result = current.execute(sample.input)

				assert.equal(result.status, 0, result.stderr)
				assert.equal(result.stderr, '')
				assert.deepEqual(JSON.parse(result.stdout), sample.output)
			}
		} finally {
			current.cleanup()
		}
	})
}
