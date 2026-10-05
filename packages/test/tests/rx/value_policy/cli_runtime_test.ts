import assert from 'node:assert/strict'
import { join } from 'node:path'
import { test } from 'node:test'
import fixture from './cli_fixture.ts'

for (const mode of ['call', 'module']) {
	test(`RX ${mode} composes ZX loop and preserves original input`, () => {
		const current = fixture()
		const application = join(current.directory, process.platform === 'win32' ? `${mode}.exe` : mode)

		try {
			const built = current.build(`${mode}.rx`, application)

			assert.equal(built.status, 0, built.stderr)

			for (const values of [[], [0], [1, 2, 3], [7, 7, 0]]) {
				const result = current.execute(application, { values, count: values.length })
				const adjusted = values.map(value => value + 1)

				assert.equal(result.status, 0, result.stderr)
				assert.equal(result.stderr, '')
				assert.deepEqual(
					JSON.parse(result.stdout),
					mode === 'call'
						? { original: values, result: { values: adjusted, count: values.length, index: values.length } }
						: { original: values, values: adjusted.map(value => value * 2) }
				)
			}
		} finally {
			current.cleanup()
		}
	})
}

test('RX simple expressions and literal call text remain valid data', () => {
	const current = fixture()
	const application = join(current.directory, process.platform === 'win32' ? 'simple.exe' : 'simple')

	try {
		const built = current.build('simple.rx', application)

		assert.equal(built.status, 0, built.stderr)

		for (const input of [
			{ value: 0, values: [7], flag: false },
			{ value: 7, values: [1, 2], flag: true },
			{ value: 123, values: [0], flag: false }
		]) {
			const result = current.execute(application, input)

			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.deepEqual(JSON.parse(result.stdout), {
				text: 'number(1)',
				loopText: 'loop(0, { while: state => true })',
				value: input.value + 1,
				first: input.values[0],
				selected: input.flag ? input.value : 0,
				label: `N${input.value}`
			})
		}
	} finally {
		current.cleanup()
	}
})
