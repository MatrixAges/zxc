import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { test } from 'node:test'
import Fixture, { stats } from './fixture.ts'

test('split app executes cold warm changed and disabled generation', () => {
	const fixture = new Fixture()

	try {
		stats(fixture.build(), [3, 0, 0, 3, 0, 0])
		fixture.execute(1)
		assert.equal(fixture.generationFiles().length, 3)

		stats(fixture.build(), [0, 3, 3, 0, 0, 0])
		fixture.execute(1)
		fixture.writeHelper(2)

		stats(fixture.build(), [1, 2, 2, 1, 0, 0])
		fixture.execute(2)

		const before = fixture.snapshot()
		const disabled = fixture.build(['--no-cache'])

		assert.match(disabled, /zxc generation: disabled/)
		fixture.execute(2)
		assert.deepEqual(fixture.snapshot(), before)
	} finally {
		fixture.close()
	}
})

test('corrupt generation files regenerate and execute correctly', () => {
	const fixture = new Fixture()

	try {
		fixture.build()

		for (const file of fixture.generationFiles()) writeFileSync(file, 'broken generation')

		stats(fixture.build(), [3, 0, 0, 3, 3, 0])
		fixture.execute(1)

		for (const file of fixture.generationFiles()) assert.ok(readFileSync(file, 'utf8').startsWith('zxc.zig.source.v1\n'))
	} finally {
		fixture.close()
	}
})

test('generation payload stored under another key is rejected before compilation', () => {
	const fixture = new Fixture()

	try {
		fixture.build()

		const files = fixture.generationFiles()
		const first = readFileSync(files[0])
		const second = readFileSync(files[1])

		writeFileSync(files[0], second)
		writeFileSync(files[1], first)

		stats(fixture.build(), [2, 1, 1, 2, 2, 0])
		fixture.execute(1)
	} finally {
		fixture.close()
	}
})
