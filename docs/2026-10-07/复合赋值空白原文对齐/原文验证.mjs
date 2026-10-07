import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import vm from 'node:vm'

const corpus = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const directory = import.meta.dirname
const originals = JSON.parse(readFileSync(join(directory, '上游原文清单.json'), 'utf8'))
const hash = bytes => createHash('sha256').update(bytes).digest('hex')
const harness = ['sta.js', 'assert.js'].map(name => ({ name, bytes: readFileSync(join(corpus, 'harness', name)) }))
const executions = []

for (const original of originals) {
    const bytes = readFileSync(join(directory, '上游原文', original.path.split('/').at(-1) + '.txt'))

    assert.equal(hash(bytes), original.sha256)

    for (const strict of [false, true]) {
        const context = vm.createContext({})

        for (const file of harness)
            new vm.Script(file.bytes.toString('utf8'), { filename: file.name }).runInContext(context, { timeout: 1000 })

        new vm.Script(
            `var observedAssertions = 0; var savedSameValue = assert.sameValue; assert.sameValue = function (...args) { observedAssertions++; return savedSameValue(...args); };`
        ).runInContext(context)
        new vm.Script((strict ? '"use strict";\n' : '') + bytes.toString('utf8'), {
            filename: original.path
        }).runInContext(context, { timeout: 1000 })

        const assertions = new vm.Script('observedAssertions').runInContext(context)
        const final = new vm.Script('x').runInContext(context)
        const bits = Buffer.alloc(8)

        bits.writeDoubleBE(final)
        assert.equal(assertions, 20)
        assert.equal(bits.toString('hex'), original.expected_bits)
        executions.push({
            path: original.path,
            sha256: original.sha256,
            strict,
            assertions,
            final_bits: bits.toString('hex'),
            passed: true
        })
    }
}

const engine = process.versions.bun ? 'Bun' : 'Node'
const output = {
    engine,
    version: process.versions.bun ?? process.version,
    harness: harness.map(file => ({ name: file.name, sha256: hash(file.bytes) })),
    executions
}

writeFileSync(join(directory, `上游原文执行证据-${engine}.json`), JSON.stringify(output, null, 2) + '\n')
console.log(
    JSON.stringify({
        engine,
        executions: executions.length,
        assertions: executions.reduce((sum, item) => sum + item.assertions, 0),
        passed: true
    })
)
