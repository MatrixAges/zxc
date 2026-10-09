import type { Row } from './models/reduce_trace.ts'
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
    assert.ok(Number.isSafeInteger(row.input.seed), row.id)
    assert.ok(['none', 'source', 'seed', 'callback'].includes(row.failure), row.id)
    assert.ok(Number.isSafeInteger(row.fail_at) && row.fail_at >= 0, row.id)
    assert.equal('error' in row.expected !== 'value' in row.expected, true, row.id)
    assert.equal(row.expected.visits.length, row.expected.calls, row.id)
    assert.ok(row.expected.calls >= 0 && row.expected.calls <= row.input.items.length, row.id)
    assert.ok(/^[SIV]+$/.test(row.expected.events), row.id)
    seen.add(row.id)

    for (const visit of row.expected.visits) assert.ok(Object.values(visit).every(Number.isSafeInteger), row.id)

    let result: string

    if ('error' in row.expected) {
        assert.ok(
            ['SourceFailure', 'SeedFailure', 'CallbackFailure', 'IndexOutOfBounds'].includes(row.expected.error!),
            row.id
        )
        result = `.{ .failure = error.${row.expected.error} }`
    } else {
        assert.ok(Number.isSafeInteger(row.expected.value), row.id)
        result = `.{ .value = ${row.expected.value} }`
    }

    declarations.push(
        `test ${quote(row.id)} {\n    try check(.{ .input = ${literal(row.input)}, .failure = .${row.failure}, .fail_at = ${row.fail_at}, .expected = .{ .calls = ${row.expected.calls}, .visits = ${literal(row.expected.visits)}, .events = ${quote(row.expected.events)}, .source_calls = ${row.expected.source_calls}, .seed_calls = ${row.expected.seed_calls}, .result = ${result} } });\n}\n`
    )
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
