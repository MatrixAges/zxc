import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { stripTypeScriptTypes } from 'node:module'
import final_cases from './草稿/packages/test/tests/verification/enumeration/cases.ts'

const original_source = readFileSync(new URL('./草稿/原始枚举案例.ts.txt', import.meta.url), 'utf8')
const original_module = await import(
    `data:text/javascript;base64,${Buffer.from(stripTypeScriptTypes(original_source)).toString('base64')}`
)
const original_cases = original_module.default

assert.equal(original_cases.length, 74)
assert.equal(final_cases.length, original_cases.length)

for (const [index, entry] of final_cases.entries()) {
    const original = original_cases[index]
    const metadata = ({ name, count, result, files }) => ({ name, count, result, files })

    assert.deepEqual(metadata(entry), metadata(original))
    assert.equal(
        entry.source.match(/export default function[^\n]+/)[0],
        original.source.match(/export default function[^\n]+/)[0]
    )
}

console.log('PASS: all 74 enum case names, domains, result classes, module sources and proof contracts preserved')
