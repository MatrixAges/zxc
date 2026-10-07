import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const doc = import.meta.dirname
const hashes = {}
const context = vm.createContext({ observations: [] })

for (const name of ['sta.js', 'assert.js', 'yield-non-strict-access.js']) {
    const source = readFileSync(resolve(doc, '上游原文', `${name}.txt`))

    hashes[name] = createHash('sha256').update(source).digest('hex')

    if (name === 'yield-non-strict-access.js') {
        vm.runInContext(
            `
            const original_same_value = assert.sameValue

            assert.sameValue = function (...args) {
                observations.push({ actual: args[0], expected: args[1] })

                return Reflect.apply(original_same_value, this, args)
            }
        `,
            context
        )
    }

    vm.runInContext(source.toString(), context, { filename: name, timeout: 5000 })
}

const observations = JSON.parse(JSON.stringify(context.observations))

assert.deepEqual(observations, [{ actual: 1, expected: 1 }])
assert.equal(hashes['yield-non-strict-access.js'], 'b3cd9a45bf610907cb8f1c8c2cd27882bc7dc3ac75e7084baf8f21ecfe335175')

const evidence = {
    revision: '7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd',
    mode: 'unmodified original noStrict script with official harness',
    node_version: process.version,
    exit_code: 0,
    hashes,
    observations
}

writeFileSync(resolve(doc, '上游原文执行证据.json'), JSON.stringify(evidence, null, 2) + '\n')
console.log('PASS: original noStrict SameValue assertion', observations.length)
