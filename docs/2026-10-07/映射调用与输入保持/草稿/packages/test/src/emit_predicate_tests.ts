import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import literal from './shared/zig_literal.ts'
import { quote } from './zig_string.ts'

type Probe = { rule: string; threshold: number; value: boolean; failure: number }
type Row = {
    id: string
    input: Array<number>
    probe: Probe
    expected: {
        value?: boolean | Array<boolean>
        error?: string
        calls: number
        visited: Array<number>
        input: Array<number>
    }
}

const [source, harness, output] = process.argv.slice(2)
const declarations = [readFileSync(harness, 'utf8')]
const seen = new Set<string>()

for (const row of readRows<Row>(source)) {
    assert.ok(!seen.has(row.id), row.id)
    assert.ok(['above', 'equal', 'always', 'before', 'after'].includes(row.probe.rule), row.id)
    assert.ok(row.input.length <= 8192 && row.input.every(Number.isSafeInteger), row.id)
    assert.ok(Number.isSafeInteger(row.probe.threshold) && Number.isSafeInteger(row.probe.failure), row.id)
    assert.ok(row.probe.failure >= 0 && typeof row.probe.value === 'boolean', row.id)
    assert.equal('error' in row.expected !== 'value' in row.expected, true, row.id)
    assert.deepEqual(row.expected.input, row.input, row.id)
    assert.ok(row.expected.calls >= 0 && row.expected.calls <= row.input.length, row.id)
    assert.equal(row.expected.visited.length, row.expected.calls, row.id)
    seen.add(row.id)

    const probe = `.{ .rule = .${row.probe.rule}, .threshold = ${row.probe.threshold}, .value = ${row.probe.value}, .failure = ${row.probe.failure} }`
    let result: string

    if ('error' in row.expected) {
        assert.equal(row.expected.error, 'NativeFailure', row.id)
        result = '.{ .failure = error.NativeFailure }'
    } else {
        const value = row.expected.value

        assert.ok(
            typeof value === 'boolean' || (Array.isArray(value) && value.every(item => typeof item === 'boolean')),
            row.id
        )
        result = `.{ .value = ${literal(value!)} }`
    }

    declarations.push(
        `test ${quote(row.id)} {\n    try check(.{ .input = ${literal(row.input)}, .probe = ${probe}, .expected = .{ .calls = ${row.expected.calls}, .visited = ${literal(row.expected.visited)}, .input = ${literal(row.expected.input)}, .result = ${result} } });\n}\n`
    )
}

assert.ok(seen.size > 0)
writeFileSync(output, declarations.join('\n'))
