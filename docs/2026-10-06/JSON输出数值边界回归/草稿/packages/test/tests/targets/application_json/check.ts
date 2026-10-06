import type { Case, Response, Target } from './model.ts'
import assert from 'node:assert/strict'

export default function checkCase(args: { test_case: Case; response: Response; target: Target }): void {
	const { test_case, response, target } = args

	if ('error' in test_case.expected) {
		if (target === 'wasm32-freestanding') {
			assert.equal(response.status, 1)
			assert.equal(response.output, test_case.expected.error)
		} else {
			assert.notEqual(response.status, 0)
			assert.equal(response.output, '')

			const error_name = response.stderr.match(/^error: ([A-Za-z][A-Za-z0-9]*)\b/m)

			assert.ok(error_name, response.stderr)
			assert.equal(error_name[1], test_case.expected.error)
		}

		return
	}

	assert.equal(response.status, 0, response.stderr)

	const actual: unknown = JSON.parse(response.output)

	assert.deepEqual(actual, test_case.expected.value)
}
