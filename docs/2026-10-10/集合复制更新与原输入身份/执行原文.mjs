import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const doc = import.meta.dirname
const root = '/Users/xiewendao/.codex/conformance/upstream/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const originals = JSON.parse(readFileSync(resolve(doc, '原文身份.json'), 'utf8'))
const records = []
const harness_names = ['sta.js', 'assert.js', 'compareArray.js']

for (const original of originals) {
    const source = readFileSync(resolve(root, original.path))

    assert.equal(createHash('sha256').update(source).digest('hex'), original.sha256)
    assert.deepEqual(source, readFileSync(resolve(doc, original.saved)))

    for (const strict of [false, true]) {
        const observed = []
        const context = vm.createContext({ observed })

        for (const name of harness_names) {
            vm.runInContext(readFileSync(resolve(root, 'harness', name), 'utf8'), context, { filename: name })
        }

        vm.runInContext(
            `
const originalCompare = assert.compareArray;
const originalNotSame = assert.notSameValue;
assert.compareArray = function (...args) {
    originalCompare(...args);
    observed.push({ kind: 'compareArray', actual: [...args[0]], expected: [...args[1]] });
};
assert.notSameValue = function (...args) {
    originalNotSame(...args);
    observed.push({ kind: 'notSameValue', distinct: args[0] !== args[1] });
};
`,
            context
        )
        vm.runInContext((strict ? '"use strict";\n' : '') + source.toString('utf8'), context, {
            filename: original.path,
            timeout: 1000
        })
        assert.equal(observed.length, original.assertion_count)
        records.push({ path: original.path, sha256: original.sha256, strict, observed })
    }
}

const harness = Object.fromEntries(
    harness_names.map(name => [
        name,
        createHash('sha256')
            .update(readFileSync(resolve(root, 'harness', name)))
            .digest('hex')
    ])
)

assert.equal(records.length, 8)
assert.equal(
    records.reduce((count, record) => count + record.observed.length, 0),
    20
)
const runner_sha256 = createHash('sha256')
    .update(readFileSync(import.meta.filename))
    .digest('hex')
const node_sha256 = createHash('sha256').update(readFileSync(process.execPath)).digest('hex')

writeFileSync(
    resolve(doc, '原文执行证据.json'),
    JSON.stringify({ node: process.version, node_sha256, runner_sha256, harness, records }, null, 2) + '\n'
)
console.log('PASS: eight original executions and twenty official harness assertions')
