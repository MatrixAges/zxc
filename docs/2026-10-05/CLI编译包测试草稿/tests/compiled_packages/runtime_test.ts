import assert from 'node:assert/strict'
import { readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture, { exports_map, mixed_artifact, program } from './fixture.ts'

test('compiled package public entries compose through exported type imports without sources', () => {
	const fixture = createFixture({
		source: readFileSync(new URL('fixtures/composed.zx', import.meta.url), 'utf8')
	})

	try {
		fixture.write('types.zx', readFileSync(new URL('fixtures/types.zx', import.meta.url), 'utf8'))
		assert.deepEqual(readdirSync(fixture.member).sort(), ['library.zxcir', 'pkg.yaml'])
		const built = fixture.build(['--cache-stats'])
		assert.equal(built.status, 0, built.stderr)
		assert.match(built.stderr, /compiled library inputs bypass semantic artifacts/)

		for (const input of [0, 1, 7, 123, 65535]) {
			const result = fixture.execute(input)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stdout.trim(), String(input * 12 + 117))
		}
	} finally {
		fixture.cleanup()
	}
})

test('compiled package public selection changes invalidate cached output and corruption preserves last application', () => {
	const fixture = createFixture()

	try {
		const first = fixture.build()
		assert.equal(first.status, 0, first.stderr)
		assert.equal(fixture.execute(7).stdout.trim(), '27')
		fixture.manifest({ exports: { ...exports_map, '.': { module: 'beta' } } })
		const second = fixture.build()
		assert.equal(second.status, 0, second.stderr)
		assert.equal(fixture.execute(7).stdout.trim(), '34')
		const previous = readFileSync(fixture.application)
		writeFileSync(join(fixture.member, 'library.zxcir'), 'corrupt library')
		const rejected = fixture.build()
		assert.equal(rejected.status, 1, rejected.stderr)
		assert.deepEqual(readFileSync(fixture.application), previous)
		assert.equal(fixture.execute(7).stdout.trim(), '34')
	} finally {
		fixture.cleanup()
	}
})

test('compiled RX package preserves runtime branch selection and failure propagation', () => {
	const source = readFileSync(new URL('fixtures/branch.zx', import.meta.url), 'utf8')
	const fixture = createFixture({ artifact: mixed_artifact, source })

	try {
		const built = fixture.build()
		assert.equal(built.status, 0, built.stderr)

		for (const [input, expected] of [
			[{ choose: true, left: [11], right: [] }, 13],
			[{ choose: false, left: [], right: [41] }, 43]
		] as const) {
			const result = fixture.execute(input)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stdout.trim(), String(expected))
		}

		const failed = fixture.execute({ choose: true, left: [], right: [41] })
		assert.equal(failed.status, 1)
		assert.match(failed.stderr, /IndexOutOfBounds/)
	} finally {
		fixture.cleanup()
	}
})

test('compiled scoped workspace package resolves through dependency alias', () => {
	const fixture = createFixture({
		package_name: '@scope/calc',
		dependency_name: 'local',
		source: program('run(in)', 'import run from "local/nested/beta"\n')
	})

	try {
		const built = fixture.build()
		assert.equal(built.status, 0, built.stderr)

		for (const input of [0, 7, 123]) {
			const result = fixture.execute(input)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stdout.trim(), String(input * 3 + 13))
		}
	} finally {
		fixture.cleanup()
	}
})
