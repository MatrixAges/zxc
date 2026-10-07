import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import vm from 'node:vm'

const source = readFileSync(join(import.meta.dirname, '上游原文.js.txt'), 'utf8')
const harness = ['sta.js', 'assert.js']
    .map(name => readFileSync(join(import.meta.dirname, '配套资源', name + '.txt'), 'utf8'))
    .join('\n')
const executions = []

for (const strict of [false, true]) {
    const observations = []
    const context = vm.createContext({})

    new vm.Script(harness).runInContext(context)

    const original_assert = context.assert

    context.assert = new Proxy(original_assert, {
        apply(target, receiver, args) {
            Reflect.apply(target, receiver, args)
            observations.push({ method: 'assert', actual: args[0], expected: true, message: args[1] })
        },
        get(target, name, receiver) {
            const value = Reflect.get(target, name, receiver)

            if (name !== 'sameValue') return value

            return (...args) => {
                Reflect.apply(value, target, args)
                observations.push({ method: 'sameValue', actual: args[0], expected: args[1], message: args[2] })
            }
        }
    })

    new vm.Script((strict ? '"use strict";\n' : '') + source).runInContext(context, { timeout: 10000 })
    assert.equal(observations.length, 2)
    assert.equal(context.callbackfn.length, 0)
    executions.push({ strict, callback_formal_parameters: context.callbackfn.length, assertions: observations })
}

writeFileSync(
    join(import.meta.dirname, '上游原文执行证据.json'),
    JSON.stringify(
        {
            node: process.version,
            sha256: createHash('sha256').update(source).digest('hex'),
            harness_sha256: createHash('sha256').update(harness).digest('hex'),
            executions,
            assertion_count: executions.flatMap(item => item.assertions).length
        },
        null,
        2
    ) + '\n'
)
console.log('PASS: original zero-formal callback; ordinary/strict executions; four original assertions')
