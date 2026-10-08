import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const doc = import.meta.dirname
const root = '/Users/xiewendao/.codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const paths = ['15.4.4.20-5-29.js', '15.4.4.20-6-1.js', '15.4.4.20-9-c-ii-9.js']
const records = []

for (const name of paths) {
    const path = `test/built-ins/Array/prototype/filter/${name}`
    const source = readFileSync(resolve(root, path))
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
            filename: path,
            timeout: 1000
        })
        assert.equal(observed.length, name.includes('-5-29') ? 1 : 2)
        records.push({ path, sha256: createHash('sha256').update(source).digest('hex'), strict, observed })
    }
}

writeFileSync(resolve(doc, '原文执行证据.json'), JSON.stringify({ node: process.version, records }, null, 2) + '\n')
console.log('PASS: six original executions, ten real harness assertions')
