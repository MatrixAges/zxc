import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const doc = dirname(fileURLToPath(import.meta.url))
const upstream = process.argv[2]
assert.ok(upstream, 'Pass the extracted locked Test262 directory')
const samples = JSON.parse(readFileSync(join(doc, '上游输入清单.json'), 'utf8'))
const harness = ['sta.js', 'assert.js'].map(name => {
    const bytes = readFileSync(join(upstream, 'harness', name))

    return { name, source: bytes.toString('utf8'), sha256: createHash('sha256').update(bytes).digest('hex') }
})
const executions = []

for (const sample of samples) {
    const bytes = readFileSync(join(doc, '上游原文', sample.path + '.txt'))
    assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

    for (const strict of [false, true]) {
        const context = vm.createContext({})

        for (const item of harness) new vm.Script(item.source, { filename: item.name }).runInContext(context)

        const assertions = []
        const original = context.assert
        const same_value = original.sameValue
        original.sameValue = (actual, expected, message) => {
            assertions.push({ kind: 'sameValue', actual, expected, message })

            return same_value(actual, expected, message)
        }
        context.assert = new Proxy(original, {
            apply(target, receiver, arguments_list) {
                assertions.push({
                    kind: 'truthy',
                    actual: arguments_list[0],
                    expected: true,
                    message: arguments_list[1]
                })

                return Reflect.apply(target, receiver, arguments_list)
            }
        })

        const started_at = new Date().toISOString()
        new vm.Script((strict ? '"use strict";\n' : '') + bytes.toString('utf8'), {
            filename: sample.path
        }).runInContext(context, { timeout: 5000 })
        assert.ok(assertions.length > 0, sample.path)
        executions.push({
            path: sample.path,
            sha256: sample.sha256,
            strict,
            started_at,
            completed_at: new Date().toISOString(),
            assertions,
            status: 0
        })
    }
}

const record = {
    node: process.version,
    harness: harness.map(({ source, ...row }) => row),
    executions,
    actual_assertions: executions.reduce((sum, row) => sum + row.assertions.length, 0)
}
writeFileSync(join(doc, '上游执行结果.json'), JSON.stringify(record, null, 2) + '\n')
console.log(`${executions.length} original executions; ${record.actual_assertions} original assertions passed`)
