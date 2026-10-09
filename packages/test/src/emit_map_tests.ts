import type { Row } from './models/map_trace.ts'
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
    assert.ok(row.input.length <= 8192 && row.input.every(Number.isSafeInteger), row.id)
    assert.ok(['cursor', 'violations'].includes(row.probe.rule), row.id)
    assert.ok(Number.isSafeInteger(row.probe.cursor) && row.probe.cursor >= 0, row.id)
    assert.ok(Number.isSafeInteger(row.probe.failure) && row.probe.failure >= 0, row.id)
    assert.equal('value' in row.expected !== 'error' in row.expected, true, row.id)
    assert.deepEqual(row.input, row.expected.input, row.id)
    assert.equal(typeof row.expected.ordered, 'boolean', row.id)
    assert.equal(row.expected.calls, row.expected.visits.length, row.id)
    assert.equal(row.expected.source_calls, 1, row.id)
    seen.add(row.id)

    const probe = `.{ .rule = .${row.probe.rule}, .cursor = ${row.probe.cursor}, .failure = ${row.probe.failure} }`
    let result: string

    if ('error' in row.expected) {
        assert.equal(row.expected.error, 'CallbackFailure', row.id)
        result = '.{ .failure = error.CallbackFailure }'
    } else {
        assert.ok(
            row.expected.value!.every(value => typeof value === 'boolean'),
            row.id
        )
        result = `.{ .value = ${literal(row.expected.value!)} }`
    }

    declarations.push(
        `test ${quote(row.id)} {\n    try check(.{ .input = ${literal(row.input)}, .probe = ${probe}, .expected = .{ .ordered = ${row.expected.ordered}, .calls = ${row.expected.calls}, .visits = ${literal(row.expected.visits)}, .source_calls = ${row.expected.source_calls}, .result = ${result} } });\n}\n`
    )
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
