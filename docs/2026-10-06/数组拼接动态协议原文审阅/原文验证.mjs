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
let executions = 0
let failed_executions = 0

for (const entry of metadata) {
    assert.ok(!entry.negative)
    assert.ok((entry.flags ?? []).every(flag => flag === 'noStrict'))

    const source = readFileSync(resolve(directory, '原文', basename(entry.path, '.js') + '.txt'), 'utf8')
    const modes = []

    assert.equal(digest(source), entry.sha256)

    for (const strict of entry.flags?.includes('noStrict') ? [false] : [false, true]) {
        let realm_count = 0

        function createRealm() {
            const vm_context = vm.createContext({})
            const global_object = vm.runInContext('globalThis', vm_context)
            const realm = {
                global: global_object,
                createRealm,
                evalScript(code) {
                    return vm.runInContext(code, vm_context, { filename: entry.path, timeout: 10000 })
                }
            }

            global_object.$262 = realm
            realm_count += 1

            return realm
        }

        const realm = createRealm()
        const sanity_realm = createRealm()

        assert.notEqual(realm.global.Array, sanity_realm.global.Array)
        assert.notEqual(realm.global.Object, sanity_realm.global.Object)
        assert.equal(realm.evalScript('Object.getPrototypeOf([]) === Array.prototype'), true)

        const baseline_realms = realm_count

        for (const name of ['sta.js', 'assert.js', ...(entry.includes ?? [])]) {
            const harness = readFileSync(resolve(upstream, 'harness', name), 'utf8')

            harnesses[name] = digest(harness)
            realm.evalScript(harness)
        }

        let failure = null

        try {
            realm.evalScript((strict ? '"use strict";\n' : '') + source)
        } catch (error) {
            failed_executions += 1
            failure = { name: error.constructor?.name ?? null, message: error.message ?? String(error) }
            console.error(JSON.stringify({ path: entry.path, strict, failure }))
        }

        executions += 1
        modes.push({
            strict,
            unchanged_passed: failure === null,
            failure,
            additional_realms_created: realm_count - baseline_realms
        })
    }

    results.push({ path: entry.path, sha256: entry.sha256, modes })
}

assert.equal(results.length, 69)
assert.equal(executions, 137)

writeFileSync(
    resolve(directory, '原文结果.json'),
    JSON.stringify(
        {
            node: process.version,
            script_sha256: digest(readFileSync(fileURLToPath(import.meta.url))),
            harnesses,
            unchanged_original_files: 69,
            unchanged_original_executions: executions,
            unchanged_passed_executions: executions - failed_executions,
            unchanged_failed_executions: failed_executions,
            zxc_passes: 0,
            results
        },
        null,
        4
    ) + '\n'
)
console.log(
    JSON.stringify({
        unchanged_original_executions: executions,
        passed: executions - failed_executions,
        failed: failed_executions,
        zxc_passes: 0
    })
)
process.exitCode = failed_executions === 0 ? 0 : 1
