import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import vm from 'node:vm'

const directory = import.meta.dirname
const originals = JSON.parse(readFileSync(join(directory, '上游原文清单.json'), 'utf8'))
const corpus = JSON.parse(readFileSync(join(directory, '开始基线.json'), 'utf8')).corpus
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
            `var sameValueCount = 0; var throwsCount = 0; var savedSameValue = assert.sameValue; var savedThrows = assert.throws; assert.sameValue = function (...args) { sameValueCount++; return savedSameValue(...args); }; assert.throws = function (...args) { throwsCount++; return savedThrows(...args); };`
        ).runInContext(context)
        new vm.Script((strict ? '"use strict";\n' : '') + bytes.toString('utf8'), {
            filename: original.path
        }).runInContext(context, { timeout: 1000 })

        const same_value = new vm.Script('sameValueCount').runInContext(context)
        const throws = new vm.Script('throwsCount').runInContext(context)
        const sputnik = original.path.includes('S11.13.2_A2.1_')
        const expected_same_value = original.kind === 'resolved' ? 1 : 0
        const expected_throws = !sputnik && original.kind === 'lhs' ? 1 : 0
        let final_bits = null

        assert.equal(same_value, expected_same_value)
        assert.equal(throws, expected_throws)

        if (original.kind === 'resolved') {
            const final = new vm.Script(original.identifier).runInContext(context)
            const buffer = Buffer.alloc(8)

            buffer.writeDoubleBE(final)
            final_bits = buffer.toString('hex')
            assert.equal(final, original.expected)
        } else if (sputnik && original.kind === 'rhs') {
            assert.equal(new vm.Script('x').runInContext(context), 1)
            assert.equal(new vm.Script('typeof y').runInContext(context), 'undefined')
        } else if (sputnik) assert.equal(new vm.Script('typeof x').runInContext(context), 'undefined')

        executions.push({
            path: original.path,
            sha256: original.sha256,
            strict,
            same_value,
            throws,
            original_catch_check: sputnik,
            final_bits,
            passed: true
        })
    }
}

const engine = process.versions.bun ? 'Bun' : 'Node'
const evidence = {
    engine,
    version: process.versions.bun ?? process.version,
    harness: harness.map(file => ({ name: file.name, sha256: hash(file.bytes) })),
    executions
}

writeFileSync(join(directory, `上游原文执行证据-${engine}.json`), JSON.stringify(evidence, null, 2) + '\n')
console.log(
    JSON.stringify({
        engine,
        executions: executions.length,
        same_value: executions.reduce((sum, row) => sum + row.same_value, 0),
        throws: executions.reduce((sum, row) => sum + row.throws, 0),
        original_catch_checks: executions.filter(row => row.original_catch_check).length,
        passed: true
    })
)
