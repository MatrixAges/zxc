import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { basename, dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const metadata = JSON.parse(readFileSync(resolve(directory, '原文metadata.json')))
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const harness = readFileSync(resolve(upstream, 'harness/sta.js'), 'utf8')
const digest = value => createHash('sha256').update(value).digest('hex')
const counts = [10, 52, 10, 9, 1, 3, 3, 4, 4, 11, 11, 2, 3, 3, 4, 4]
const results = []

for (const [index, entry] of metadata.entries()) {
    const operation = entry.path.split('/')[2]
    const source = readFileSync(resolve(directory, '原文', operation, basename(entry.path, '.js') + '.txt'), 'utf8')
    const modes = []

    assert.equal(digest(source), entry.sha256)

    for (const strict of [false, true]) {
        const script = (strict ? '"use strict";\n' : '') + source
        const unchanged = vm.createContext({})

        vm.runInContext(harness, unchanged, { filename: 'sta.js', timeout: 2000 })
        vm.runInContext(script, unchanged, { filename: entry.path, timeout: 5000 })

        const observed = vm.createContext({})
        const observations = []

        vm.runInContext(harness, observed, { filename: 'sta.js', timeout: 2000 })

        const intrinsic = vm.runInContext(operation, observed)

        observed[operation] = function (...args) {
            const value = Reflect.apply(intrinsic, this, args)

            assert.equal(args.length, 1)
            assert.equal(typeof args[0], 'string')
            assert.equal(typeof value, 'string')
            observations.push({ index: observations.length + 1, input: args[0], value })

            return value
        }

        vm.runInContext(script, observed, { filename: entry.path, timeout: 5000 })
        assert.equal(observations.length, counts[index])
        modes.push({ strict, unchanged_passed: true, observed_passed: true, observations })
    }

    assert.deepEqual(modes[0].observations, modes[1].observations)
    results.push({ path: entry.path, sha256: entry.sha256, operation, modes })
}

assert.equal(results.length, 16)
assert.equal(
    results.reduce((sum, row) => sum + row.modes[0].observations.length, 0),
    134
)
writeFileSync(
    resolve(directory, '原文结果.json'),
    JSON.stringify(
        {
            node: process.version,
            harness_sha256: digest(harness),
            script_sha256: digest(readFileSync(fileURLToPath(import.meta.url))),
            unchanged_executions: 32,
            observed_executions: 32,
            core_observations: 134,
            results
        },
        null,
        4
    ) + '\n'
)
console.log(
    '32 unchanged reference executions passed; 32 supplementary observer executions retained all 134 core observations'
)
