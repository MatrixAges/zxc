import type { Pattern, Row, Values } from './rx_parallel_floating/cases.ts'
import assert from 'node:assert/strict'
import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import { quote } from './zig_string.ts'

const [catalog, output] = process.argv.slice(2)
const declarations = ['const support = @import("parallel_floating");\n']
const seen = new Set<string>()

function pattern(value: Pattern): string {
    assert.ok(Number.isInteger(value.length) && value.length >= 0 && value.length <= 8192)
    assert.ok(value.values.length > 0)

    return `.{ .values = &.{${value.values.map(bits => '0x' + bits).join(', ')}}, .length = ${value.length} }`
}

function values(value: Values): string {
    return `.{ .left = ${pattern(value.left)}, .right = ${pattern(value.right)}, .marker = 0x${value.marker} }`
}

for (const row of readRows<Row>(catalog)) {
    assert.ok(!seen.has(row.id), row.id)
    seen.add(row.id)

    const width = row.input.marker.length
    const validBits = (bits: string): boolean => bits.length === width && /^[0-9a-f]+$/.test(bits)

    assert.ok(width === 8 || width === 16, row.id)
    for (const value of [row.input, row.expected])
        assert.ok(
            validBits(value.marker) && value.left.values.every(validBits) && value.right.values.every(validBits),
            row.id
        )
    assert.ok(['values', 'threads', 'allocations'].includes(row.check), row.id)

    declarations.push(`test ${quote(row.id)} {
    try support.check(.{ .input = ${values(row.input)}, .expected = ${values(row.expected)}, .owned_capture = ${row.expected.owned_capture} }, .${row.check});
}
`)
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
