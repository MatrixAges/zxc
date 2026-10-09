import type { Operation, Row } from './immutable_list/cases.ts'
import assert from 'node:assert/strict'
import { writeFileSync } from 'node:fs'
import expectation from './immutable_list/cases.ts'
import { readRows } from './shared/json.ts'
import literal from './shared/zig_literal.ts'
import { quote } from './zig_string.ts'

const [source, operation, output] = process.argv.slice(2)
const declarations = ['const support = @import("support");\n']
const seen = new Set<string>()

assert.ok(['reverse', 'sort', 'splice', 'with'].includes(operation))

for (const row of readRows<Row>(source)) {
    assert.ok(!seen.has(row.id))
    seen.add(row.id)

    for (const input of [row.input, row.later]) {
        assert.ok(input.items.length <= 1024 && input.replacement.length <= 3)
        assert.ok([...input.items, ...input.replacement, input.value].every(Number.isSafeInteger))
        assert.ok(Number.isSafeInteger(input.index) && input.index >= 0 && input.index <= input.items.length)
        assert.ok(
            Number.isSafeInteger(input.count) && input.count >= 0 && input.count <= input.items.length - input.index
        )
        if (operation === 'with') assert.ok(input.index < input.items.length)
    }

    assert.deepEqual(row.expected.value, expectation(operation as Operation, row.input))
    assert.deepEqual(row.expected.later, expectation(operation as Operation, row.later))
    assert.deepEqual(row.input.items, row.later.items)
    assert.deepEqual(row.input.replacement, row.later.replacement)
    assert.equal(row.expected.unchanged, true)
    assert.equal(row.expected.new_storage, row.expected.value.length > 0)
    assert.equal(row.expected.later_new_storage, row.expected.later.length > 0)
    assert.ok(['values', 'allocations'].includes(row.check))
    const input = literal(row.input).slice(1)
    const later = literal(row.later).slice(1)

    declarations.push(
        `test ${quote(row.id)} {\n    try support.check(.${row.check}, .{ .input = ${input}, .later = ${later}, .expected = ${literal(row.expected.value)}, .following = ${literal(row.expected.later)} });\n}\n`
    )
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
