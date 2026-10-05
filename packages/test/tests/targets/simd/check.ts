import assert from 'node:assert/strict'
import expected from './expected.ts'

export default function check(args: { actual: unknown; input: Array<number>; type: string; json?: boolean }): void {
	const { actual, input, type, json = false } = args
	const result = expected({ values: input, type })

	assert.ok(typeof actual === 'object' && actual !== null)
	assert.deepEqual(Object.keys(actual).sort(), Object.keys(result).sort())

	for (const [key, values] of Object.entries(result)) {
		const output: unknown = (actual as Record<string, unknown>)[key]

		assert.ok(Array.isArray(output))
		assert.equal(output.length, values.length, `${type}/${key}`)

		for (let index = 0; index < values.length; index += 1) {
			assert.equal(typeof output[index], 'number')

			const value = json && type === 'f32' ? Math.fround(output[index]) : output[index]

			assert.ok(
				Object.is(value, values[index]),
				`${type}/${key}/${input.length}/${index}: ${String(value)} != ${String(values[index])}`
			)
		}
	}
}
