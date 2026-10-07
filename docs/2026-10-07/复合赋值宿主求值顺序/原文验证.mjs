import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { createContext, Script } from 'node:vm'

const corpus = process.argv[2]
const manifest = JSON.parse(readFileSync(resolve(import.meta.dirname, '上游原文清单.json'), 'utf8'))
const harness = ['sta.js', 'assert.js'].map(name => ({ name, source: readFileSync(resolve(corpus, 'harness', name)) }))
const evidence = []

for (const row of manifest) {
    const source = readFileSync(resolve(corpus, row.path))
    const sha256 = createHash('sha256').update(source).digest('hex')

    assert.equal(sha256, row.sha256)

    for (const mode of ['sloppy', 'strict']) {
        const context = createContext({})

        for (const item of harness) new Script(item.source.toString(), { filename: item.name }).runInContext(context)

        new Script(`
var __original_assert = assert;
var __actual_assert_calls = 0;

assert = function (value, message) {
    __actual_assert_calls += 1;
    return __original_assert(value, message);
};

Object.assign(assert, __original_assert);

assert.throws = function (constructor, callback, message) {
    __actual_assert_calls += 1;
    return __original_assert.throws(constructor, callback, message);
};
`).runInContext(context)

        const prefix = mode === 'strict' ? '"use strict";\n' : ''
        let failure = null

        try {
            new Script(prefix + source.toString(), { filename: row.path }).runInContext(context, { timeout: 1000 })
        } catch (error) {
            failure = { name: error.constructor?.name ?? typeof error, message: String(error.message ?? error) }
        }

        const calls = new Script('__actual_assert_calls').runInContext(context)

        if (failure === null) assert.equal(calls, row.assertions)
        else {
            assert.equal(row.variant, 4)
            assert.equal(failure.name, 'Test262Error')
            assert.equal(failure.message, 'Expected true but got false')
            assert.equal(calls, 2)
        }

        evidence.push({
            path: row.path,
            sha256,
            mode,
            assertion_calls: calls,
            passed: failure === null,
            failure,
            ...(row.variant === 4
                ? {
                      extra_observation: {
                          final_prop_key_evaluated: new Script('propKeyEvaluated').runInContext(context)
                      }
                  }
                : {})
        })
    }
}

const engine = process.versions.bun ? 'Bun' : 'Node'

writeFileSync(
    resolve(import.meta.dirname, `上游原文执行证据-${engine}.json`),
    JSON.stringify(
        {
            engine,
            version: process.versions.bun ?? process.version,
            harness: harness.map(row => ({
                name: row.name,
                sha256: createHash('sha256').update(row.source).digest('hex')
            })),
            records: evidence
        },
        null,
        2
    ) + '\n'
)
console.log(
    JSON.stringify({
        engine,
        files: manifest.length,
        executions: evidence.length,
        failures: evidence.filter(row => !row.passed).length,
        assertion_calls: evidence.reduce((sum, row) => sum + row.assertion_calls, 0)
    })
)
