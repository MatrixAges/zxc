import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { basename, dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const metadata = JSON.parse(readFileSync(resolve(directory, '原文metadata.json')))
const digest = value => createHash('sha256').update(value).digest('hex')
const harnesses = {}
const results = []

for (const entry of metadata) {
    assert.ok(!entry.flags?.length && !entry.negative)

    const operation = entry.path.split('/').at(-2)
    const source = readFileSync(resolve(directory, '原文', operation, basename(entry.path, '.js') + '.txt'), 'utf8')
    const modes = []

    assert.equal(digest(source), entry.sha256)

    for (const strict of [false, true]) {
        const context = vm.createContext({})

        for (const name of ['sta.js', 'assert.js', ...(entry.includes ?? [])]) {
            const harness = readFileSync(resolve(upstream, 'harness', name), 'utf8')

            harnesses[name] = digest(harness)
            vm.runInContext(harness, context, { filename: name, timeout: 2000 })
        }

        vm.runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: entry.path, timeout: 5000 })

        let observation = null

        if (operation === 'map') {
            observation = Array.from(context.testResult)
            assert.deepEqual(observation, [true])
        } else if (operation === 'filter') {
            observation = Array.from(context.newArr)
            assert.deepEqual(observation, [11])
        } else if (basename(entry.path) === 'S15.5.4.6_A1_T4.js') {
            observation = vm.runInContext('"lego".concat()', context)
            assert.equal(observation, 'lego')
        }

        modes.push({ strict, unchanged_passed: true, supplementary_result_observation: observation })
    }

    results.push({ path: entry.path, sha256: entry.sha256, modes })
}

assert.equal(results.length, 24)
writeFileSync(
    resolve(directory, '原文结果.json'),
    JSON.stringify(
        {
            node: process.version,
            script_sha256: digest(readFileSync(fileURLToPath(import.meta.url))),
            harnesses,
            unchanged_original_executions: 48,
            adapted_original_files: 3,
            adapted_core_observations: 4,
            results
        },
        null,
        4
    ) + '\n'
)
console.log('48 unchanged original executions passed; three complete result mappings retained four core observations')
