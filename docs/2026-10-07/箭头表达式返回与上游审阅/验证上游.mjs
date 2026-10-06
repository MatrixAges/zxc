import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { fileURLToPath } from 'node:url'
import { dirname, resolve } from 'node:path'
import { createContext, runInContext } from 'node:vm'

const doc = dirname(fileURLToPath(import.meta.url))
const manifest = JSON.parse(readFileSync(resolve(doc, '上游原文清单.json'), 'utf8'))
const harness = ['sta', 'assert'].map(name => readFileSync(resolve(doc, `上游原文/${name}.txt`), 'utf8')).join('\n')
const records = []

for (const sample of manifest.cases) {
    const source = readFileSync(resolve(doc, sample.raw_path), 'utf8')

    if (createHash('sha256').update(source).digest('hex') !== sample.sha256) throw new Error('stale upstream source')

    for (const strict of [false, true]) {
        const context = createContext({})

        runInContext(harness, context)
        runInContext(
            `const observed = []; const originalSameValue = assert.sameValue; assert.sameValue = (actual, expected, message) => { originalSameValue(actual, expected, message); observed.push({actual, expected}); };`,
            context
        )
        runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: sample.path, timeout: 1000 })

        const assertions = JSON.parse(runInContext('JSON.stringify(observed)', context))

        if (
            assertions.length !== 1 ||
            assertions[0].expected !== sample.expected ||
            assertions[0].actual !== sample.expected
        )
            throw new Error('original assertions changed')

        records.push({ path: sample.path, sha256: sample.sha256, strict, assertions, status: 'passed' })
    }
}

writeFileSync(
    resolve(doc, '上游执行结果.json'),
    JSON.stringify({ node: process.version, runs: records.length, records }, null, 2) + '\n'
)
console.log(`${records.length}/${records.length} original upstream runs passed`)
