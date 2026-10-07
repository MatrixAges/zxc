import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script } from 'node:vm'

const corpus = process.argv[2]
const manifest = JSON.parse(readFileSync(resolve(import.meta.dirname, '上游原文清单.json'), 'utf8'))
const evidence = []

class Test262Error extends Error {}

for (const row of manifest) {
    const source = readFileSync(resolve(corpus, row.path))
    const sha256 = createHash('sha256').update(source).digest('hex')

    assert.equal(sha256, row.sha256)

    for (const mode of ['sloppy', 'strict']) {
        const prefix = mode === 'strict' ? '"use strict";\n' : ''

        if (row.negative) {
            assert.throws(() => new Script(prefix + source.toString(), { filename: row.path }), { name: 'SyntaxError' })
            evidence.push({ path: row.path, sha256, mode, result: 'parse/SyntaxError', executed: false })
        } else {
            let calls = 0
            const context = {
                Test262Error,
                assert: {
                    sameValue(actual, expected) {
                        calls += 1
                        assert.ok(Object.is(actual, expected))
                    }
                }
            }

            new Script(prefix + source.toString(), { filename: row.path }).runInNewContext(context, { timeout: 1000 })
            evidence.push({
                path: row.path,
                sha256,
                mode,
                result: 'passed',
                checks: row.assertions,
                assert_calls: calls,
                executed: true
            })
        }
    }
}

writeFileSync(resolve(import.meta.dirname, '上游原文执行证据.json'), JSON.stringify(evidence, null, 2) + '\n')
console.log(
    JSON.stringify({
        files: manifest.length,
        executions: evidence.filter(row => row.executed).length,
        negative_parses: evidence.filter(row => !row.executed).length,
        checks: evidence.reduce((sum, row) => sum + (row.checks ?? 0), 0)
    })
)
