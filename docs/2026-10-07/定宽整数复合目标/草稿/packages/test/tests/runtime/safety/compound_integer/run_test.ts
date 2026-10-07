import type { Case } from '../../../../src/compound_integer/cases.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { writeFileSync } from 'node:fs'
import { basename } from 'node:path'
import { readRows, stringify } from '../../../../src/shared/json.ts'

const [binary, catalog, report] = process.argv.slice(2)
const rows = readRows<Case>(catalog)

assert.ok(rows.length > 0)
assert.equal(new Set(rows.map(row => row.id)).size, rows.length)

const results = rows.map(row => {
    const execution = spawnSync(binary, row.arguments, { encoding: 'utf8', timeout: 10_000, killSignal: 'SIGKILL' })
    const passed =
        !execution.error &&
        execution.signal === null &&
        execution.status === row.expected.status &&
        execution.stdout === '' &&
        execution.stderr === row.expected.stderr
    const result = {
        id: row.id,
        passed,
        status: execution.status,
        signal: execution.signal,
        stdout: execution.stdout,
        stderr: execution.stderr,
        error: execution.error?.message
    }

    if (!passed) console.error(stringify({ ...result, expected: row.expected }))

    return result
})
const passed = results.filter(result => result.passed).length

writeFileSync(report, results.map(result => stringify(result) + '\n').join(''))
console.log(`${basename(catalog, '.jsonl')} compound integer safety: ${passed}/${rows.length} passed`)
assert.equal(passed, rows.length)
