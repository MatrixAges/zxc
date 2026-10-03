import type { StoreCase } from './models/store.ts'
import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import literal from './shared/zig_literal.ts'
import { quote } from './zig_string.ts'

const [source, output] = process.argv.slice(2)
const declarations = ['const support = @import("support");\n']
const seen = new Set<string>()

for (const row of readRows<StoreCase>(source)) {
	if (seen.has(row.id)) throw new Error('duplicate Store case: ' + row.id)
	seen.add(row.id)

	const expected = row.expected
	const failure = 'error' in expected.result ? expected.result.error : null
	if (failure && !['Conflict', 'IndexOutOfBounds'].includes(failure))
		throw new Error('unexpected Store failure: ' + failure)

	const result =
		'value' in expected.result
			? `.{ .value = ${literal(expected.result.value)} }`
			: `.{ .failure = error.${failure} }`
	const args = `.{ .initial_a = ${literal(row.initial_a)}, .initial_b = ${literal(row.initial_b)}, .input = ${literal(row.input)}, .conflict = ${row.conflict}, .expected = .{ .pending_a = ${literal(expected.pending_a)}, .pending_b = ${literal(expected.pending_b)}, .final_a = ${literal(expected.final_a)}, .final_b = ${literal(expected.final_b)}, .attempts = ${expected.attempts}, .commits = ${expected.commits}, .result = ${result} } }`
	const check = row.allocation_failures ? 'checkAllocationFailures' : 'check'
	declarations.push(`test ${quote(row.id)} {\n    try support.${check}(${args});\n}\n`)
}

if (!seen.size) throw new Error('empty Store catalog')

writeFileSync(output, declarations.join('\n'))
