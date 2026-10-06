import type { Case } from './inspect_cases.ts'
import { stringify } from 'yaml'

const fields = ['allocator_argument', 'io_argument', 'process_argument', 'expand_tuple', 'fallible']
const states = [undefined, false, true]
const cases: Array<Case> = []

for (let index = 0; index < 3 ** fields.length; index++) {
	const supplied: Record<string, boolean> = {}
	const expected: Record<string, boolean> = {}
	const labels: Array<string> = []
	let remaining = index

	for (const field of fields) {
		const value = states[remaining % states.length]

		remaining = Math.floor(remaining / states.length)
		expected[field] = value === true
		labels.push(`${field}=${value === undefined ? 'omitted' : value}`)

		if (value !== undefined) supplied[field] = value
	}

	const external = {
		specifier: 'zig:a',
		export_name: 'call',
		signature: 'export type Input = u64\n export type Output = u64\n'
	}
	const implementation = { module: 'a', member: 'nested.call' }

	cases.push({
		name: `native external flags ${labels.join('/')}`,
		source: stringify({
			name: 'sample',
			version: '1.0.0',
			externals: [{ ...external, implementation: { ...implementation, ...supplied } }]
		}),
		expected: {
			externals: [
				{ ...external, implementation: { ...implementation, concurrent: false, errors: null, ...expected } }
			]
		}
	})
}

export default cases
