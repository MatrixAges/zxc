import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { createContext, runInContext } from 'node:vm'

const doc = import.meta.dirname
const freeze = JSON.parse(readFileSync(resolve(doc, '输入冻结.json'), 'utf8'))
const records = []

for (const sample of freeze.samples) {
    const source = readFileSync(resolve(freeze.reference_root, sample.path), 'utf8')

    assert.equal(createHash('sha256').update(source).digest('hex'), sample.sha256)

    for (const strict of [false, true]) {
        const context = createContext({})

        for (const name of ['sta.js', 'assert.js']) {
            runInContext(readFileSync(resolve(freeze.reference_root, 'harness', name), 'utf8'), context)
        }

        runInContext(
            `globalThis.assertion_count = 0;
const original_same_value = assert.sameValue;
assert.sameValue = function (...args) {
    assertion_count += 1;
    return original_same_value(...args);
};`,
            context
        )
        runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: sample.path, timeout: 1000 })
        const assertions = runInContext('assertion_count', context)

        assert.equal(assertions, 6)
        records.push({ path: sample.path, sha256: sample.sha256, strict, assertions, passed: true })
    }
}

writeFileSync(
    resolve(doc, '原文执行证据.json'),
    JSON.stringify(
        { records, executions: records.length, assertions: records.reduce((sum, row) => sum + row.assertions, 0) },
        null,
        2
    ) + '\n'
)
console.log('PASS: four locked original executions and 24 original assertions')
