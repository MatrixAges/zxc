import assert from 'node:assert/strict'
import { writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { readRows } from '../../../packages/test/src/shared/json.ts'

const root = resolve(import.meta.dirname, '../../..')
const records = []

for (const scalar of ['u8', 'u16', 'u32', 'u64', 'i32', 'i64']) {
    const plain = readRows(resolve(root, `packages/test/tests/runtime/safety/integer/${scalar}.jsonl`))
    const updates = readRows(
        resolve(root, `packages/test/tests/runtime/safety/compound_integer/${scalar}/scalar.jsonl`)
    )
    const single = new Map(
        updates
            .filter(row => row.arguments[3] === '1' && row.arguments[4] === '0' && row.arguments[5] === 'false')
            .map(row => [row.arguments.slice(0, 3).join('/'), row])
    )
    let checked = 0

    for (const row of plain) {
        if (Number(row.arguments[0]) > 4) continue

        const update = single.get(row.arguments.join('/'))

        if (!update) continue

        if ('panic' in row.expected) {
            assert.equal(update.expected.status, 86)
            assert.ok(update.expected.stderr.startsWith(`ZX_PANIC=${row.expected.panic}\n`))
        } else {
            const value = BigInt(row.expected.value)

            assert.equal(update.expected.status, 0)
            assert.ok(update.expected.stderr.startsWith(`ZX_RESULT=${value},${row.arguments[1]},1\n`))
        }

        checked++
    }

    assert.ok(checked > 0)
    records.push({ scalar, checked })
}

writeFileSync(resolve(import.meta.dirname, '普通表达式对照.json'), JSON.stringify(records, null, 2) + '\n')
console.log(JSON.stringify({ checked: records.reduce((sum, row) => sum + row.checked, 0), records }))
