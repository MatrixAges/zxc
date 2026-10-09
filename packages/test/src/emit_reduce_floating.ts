import type { Row } from './models/reduce_floating.ts'
import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import { quote } from './zig_string.ts'

const [catalog, check_source, output] = process.argv.slice(2)
const declarations = [readFileSync(check_source, 'utf8')]
const seen = new Set<string>()

for (const row of readRows<Row>(catalog)) {
    assert.ok(!seen.has(row.id), row.id)
    seen.add(row.id)

    const width = row.input.seed.length
    const validBits = (value: string): boolean => value.length === width && /^[0-9a-f]+$/.test(value)

    assert.ok(width === 8 || width === 16, row.id)
    assert.ok(row.input.items.every(validBits) && validBits(row.input.seed), row.id)

    let expected: string

    if ('error' in row.expected) {
        assert.equal(row.expected.error, 'IndexOutOfBounds', row.id)
        expected = '.missing_initial'
    } else if (row.expected.value === 'nan') {
        expected = '.{ .value = null }'
    } else {
        assert.ok(validBits(row.expected.value), row.id)
        expected = '.{ .value = 0x' + row.expected.value + ' }'
    }

    const values = '&.{' + row.input.items.map(value => '0x' + value).join(', ') + '}'

    declarations.push(`test ${quote(row.id)} {\n    try check(${values}, 0x${row.input.seed}, ${expected});\n}\n`)
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
