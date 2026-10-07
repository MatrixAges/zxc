import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { resolve } from 'node:path'
import vm from 'node:vm'

const require = createRequire(new URL('../../../packages/test/package.json', import.meta.url))
const { parse } = require('yaml')
const inventory = JSON.parse(readFileSync(new URL('./原文核对.json', import.meta.url), 'utf8'))
const results = []
const metadata_rows = []

for (const item of inventory.files) {
    const raw = readFileSync(resolve(inventory.source_root, item.path))
    const sha256 = createHash('sha256').update(raw).digest('hex')
    const metadata = parse(raw.toString().match(/\/\*---([\s\S]*?)---\*\//)[1])
    const flags = metadata.flags ?? []
    const includes = metadata.includes ?? []

    assert.equal(sha256, item.sha256)
    assert.equal(metadata.negative, undefined)
    assert.equal(
        flags.some(flag => ['async', 'module', 'raw'].includes(flag)),
        false
    )
    metadata_rows.push({ path: item.path, sha256, flags, includes, description: metadata.description })

    for (const strict of flags.includes('onlyStrict') ? [true] : flags.includes('noStrict') ? [false] : [false, true]) {
        const harness = ['sta.js', 'assert.js', ...includes]
            .map(name => readFileSync(resolve(inventory.source_root, 'harness', name), 'utf8'))
            .join('\n')
        const context = vm.createContext({})
        const source = (strict ? '"use strict";\n' : '') + harness + '\n' + raw.toString()

        try {
            new vm.Script(source, { filename: item.path }).runInContext(context, { timeout: 10000 })
            results.push({ path: item.path, strict, passed: true, sha256 })
        } catch (error) {
            results.push({ path: item.path, strict, passed: false, sha256, error: String(error) })
        }
    }
}

writeFileSync(new URL('./原文元数据.json', import.meta.url), JSON.stringify(metadata_rows, null, 2) + '\n')
writeFileSync(
    new URL('./原文结果.json', import.meta.url),
    JSON.stringify(
        {
            node: process.version,
            revision: inventory.revision,
            files: metadata_rows.length,
            executions: results.length,
            results
        },
        null,
        2
    ) + '\n'
)
console.log(
    JSON.stringify({
        files: metadata_rows.length,
        executions: results.length,
        failures: results.filter(row => !row.passed)
    })
)
assert.equal(metadata_rows.length, 3)
assert.ok(results.every(row => row.passed))
