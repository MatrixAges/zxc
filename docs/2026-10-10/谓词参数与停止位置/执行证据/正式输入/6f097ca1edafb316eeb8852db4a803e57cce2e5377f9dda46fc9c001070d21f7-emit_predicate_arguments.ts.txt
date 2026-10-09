import type { Row } from './models/predicate_arguments.ts'
import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import literal from './shared/zig_literal.ts'
import { quote } from './zig_string.ts'

const [source, harness, output] = process.argv.slice(2)
const declarations = [readFileSync(harness, 'utf8')]
const seen = new Set<string>()

for (const row of readRows<Row>(source)) {
    assert.ok(!seen.has(row.id), row.id)
    assert.ok(row.input.items.length <= 8192 && row.input.items.every(Number.isSafeInteger), row.id)
    assert.ok(['every', 'some'].includes(row.method), row.id)
    assert.ok(['source_value', 'position'].includes(row.operation), row.id)
    assert.ok(Number.isSafeInteger(row.probe.failure) && row.probe.failure >= 0, row.id)
    assert.equal('value' in row.expected !== 'error' in row.expected, true, row.id)
    assert.deepEqual(row.input, row.expected.input, row.id)
    assert.equal(row.expected.calls, row.expected.visits.length, row.id)
    assert.equal(row.expected.source_calls, 1, row.id)
    seen.add(row.id)

    const probe = `.{ .failure = ${row.probe.failure} }`
    let result: string

    if ('error' in row.expected) {
        assert.equal(row.expected.error, 'CallbackFailure', row.id)
        result = '.{ .failure = error.CallbackFailure }'
    } else {
        assert.equal(typeof row.expected.value, 'boolean', row.id)
        result = `.{ .value = ${literal(row.expected.value!)} }`
    }

    declarations.push(
        `test ${quote(row.id)} {\n    try check(.{ .input = ${literal(row.input)}, .probe = ${probe}, .expected = .{ .calls = ${row.expected.calls}, .visits = ${literal(row.expected.visits)}, .source_calls = ${row.expected.source_calls}, .result = ${result} } });\n}\n`
    )
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
