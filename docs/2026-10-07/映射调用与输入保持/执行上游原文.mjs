import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const source = readFileSync(join(import.meta.dirname, '上游原文.js.txt'), 'utf8')
const executions = []

for (const strict of [false, true]) {
    const observations = []

    runInNewContext((strict ? '"use strict";\n' : '') + source, {
        assert: {
            sameValue(actual, expected, message) {
                assert.ok(Object.is(actual, expected), message)
                observations.push({ actual, expected, message })
            }
        }
    })

    assert.equal(observations.length, 5)
    executions.push({ strict, assertions: observations })
}

writeFileSync(
    join(import.meta.dirname, '上游原文执行证据.json'),
    JSON.stringify(
        {
            sha256: createHash('sha256').update(source).digest('hex'),
            executions,
            assertion_count: executions.flatMap(item => item.assertions).length
        },
        null,
        2
    ) + '\n'
)
console.log('PASS: original ordinary/strict executions; all 10 SameValue assertions')
