import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const source = readFileSync(join(import.meta.dirname, '上游原文.js.txt'), 'utf8')
const checks = source.match(/if \(\w!==\d+\)/g)

assert.equal(checks.length, 9)

class Test262Error extends Error {}

const executions = []

for (const strict of [false, true]) {
    const context = { Test262Error }

    runInNewContext((strict ? '"use strict";\n' : '') + source, context)
    assert.equal(context.i, 16)
    assert.equal(context.j, 2)
    executions.push({
        strict,
        completed: true,
        original_conditional_checks: checks.length,
        final: { i: context.i, j: context.j }
    })
}

writeFileSync(
    join(import.meta.dirname, '上游原文执行证据.json'),
    JSON.stringify(
        {
            sha256: createHash('sha256').update(source).digest('hex'),
            executions,
            scope: 'unmodified original source completed both modes without Test262Error; nine sequential conditional checks present; no injected assertion counters'
        },
        null,
        2
    ) + '\n'
)
console.log('PASS: unmodified original ordinary/strict source completes all five loops and nine conditional checks')
