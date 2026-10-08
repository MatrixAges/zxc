import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const doc = import.meta.dirname
const root = '/Users/xiewendao/.codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const originals = JSON.parse(readFileSync(resolve(doc, '原文身份.json'), 'utf8'))
const records = []

for (const original of originals) {
    const source = readFileSync(resolve(root, original.path))

    assert.equal(createHash('sha256').update(source).digest('hex'), original.sha256)
    assert.deepEqual(source, readFileSync(resolve(doc, original.saved)))

    for (const strict of [false, true]) {
        const observed = []
        const context = vm.createContext({ observed })

        for (const harness of ['sta.js', 'assert.js']) {
            vm.runInContext(readFileSync(resolve(root, 'harness', harness), 'utf8'), context, { filename: harness })
        }

        vm.runInContext(
            `
const originalAssert = assert;
const wrappedAssert = function (...args) {
    originalAssert(...args);
    observed.push({ kind: 'assert', actual: args[0] });
};
Object.assign(wrappedAssert, originalAssert);
wrappedAssert.sameValue = function (...args) {
    originalAssert.sameValue(...args);
    observed.push({ kind: 'sameValue', actual: args[0], expected: args[1] });
};
assert = wrappedAssert;
`,
            context
        )

        vm.runInContext((strict ? '"use strict";\n' : '') + source.toString('utf8'), context, {
            filename: original.path,
            timeout: 1000
        })
        assert.equal(observed.length, 1)
        records.push({ path: original.path, sha256: original.sha256, strict, observed })
    }
}

const harness = Object.fromEntries(
    ['sta.js', 'assert.js'].map(name => [
        name,
        createHash('sha256')
            .update(readFileSync(resolve(root, 'harness', name)))
            .digest('hex')
    ])
)

writeFileSync(
    resolve(doc, '原文执行证据.json'),
    JSON.stringify({ node: process.version, harness, records }, null, 2) + '\n'
)
console.log('PASS: ten original executions, ten real harness assertions')
