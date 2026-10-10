import type { Row } from './models/predicate_order.ts'
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
    assert.ok(['every', 'some'].includes(row.method), row.id)
    assert.ok(['cursor', 'visited'].includes(row.rule), row.id)
    assert.ok(row.input.items.length <= 8192 && row.input.items.every(Number.isSafeInteger), row.id)
    assert.ok(Number.isSafeInteger(row.probe.cursor) && row.probe.cursor >= 0, row.id)
    assert.equal(row.expected.calls, row.expected.visits.length, row.id)
    assert.ok(
        row.expected.events.every(event => ['source', 'context', 'visit'].includes(event)),
        row.id
    )
    seen.add(row.id)

    const events = `&.{ ${row.expected.events.map(event => `.${event}`).join(', ')} }`
    const expected = `{ .value = ${row.expected.value}, .calls = ${row.expected.calls}, .cursor = ${row.expected.cursor}, .marked = ${literal(row.expected.marked)}, .visits = ${literal(row.expected.visits)}, .events = ${events} }`

    declarations.push(
        `test ${quote(row.id)} {\n    try check(.{ .input = ${literal(row.input)}, .rule = .${row.rule}, .cursor = ${row.probe.cursor}, .expected = .${expected} });\n}\n`
    )
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
