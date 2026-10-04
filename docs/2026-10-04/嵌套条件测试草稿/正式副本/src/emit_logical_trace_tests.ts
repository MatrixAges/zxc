import type { Json } from './shared/json.ts'
import assert from 'node:assert/strict'
import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import literal from './shared/zig_literal.ts'
import { quote } from './zig_string.ts'

type Row = { id: string; input: Json; expected: { trace: string; value?: boolean | number; error?: string } }
const [source, output] = process.argv.slice(2)
const declarations = ['const check = @import("trace_check").check;\n']
const seen = new Set<string>()

for (const row of readRows<Row>(source)) {
	assert.ok(!seen.has(row.id), row.id)
	assert.ok(/^[LR]{0,8}$/.test(row.expected.trace), row.id)
	assert.equal(('error' in row.expected) !== ('value' in row.expected), true, row.id)
	seen.add(row.id)

	let expected: string

	if (row.expected.error !== undefined) {
		assert.ok(['LeftFailure', 'RightFailure', 'IndexOutOfBounds'].includes(row.expected.error), row.id)
		expected = `.{ .failure = error.${row.expected.error} }`
	} else {
		assert.ok(typeof row.expected.value === 'boolean' || (typeof row.expected.value === 'number' && Number.isFinite(row.expected.value)), row.id)
		expected = `.{ .value = ${row.expected.value} }`
	}

	declarations.push(`test ${quote(row.id)} {\n    try check(.{ .input = ${literal(row.input)}, .trace = ${quote(row.expected.trace)}, .expected = ${expected} });\n}\n`)
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
