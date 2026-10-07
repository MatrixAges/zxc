import type { Operation } from './cases.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import cases from './cases.ts'
import expected from './expected.ts'

const [binary, mode, report] = process.argv.slice(2)

assert.match(mode, /^effects_(?:nested_)?(?:add|subtract|multiply|divide|remainder)$/)

const operation = mode.split('_').at(-1) as Operation
const nested = mode.includes('_nested_')
const rows = cases(operation)

assert.equal(new Set(rows.map(row => row.id)).size, rows.length)

const results = rows.map(row => {
    const argv = [
        row.left,
        row.right,
        row.outer,
        row.inner,
        row.selected,
        row.failure,
        row.occurrence,
        row.enabled,
        row.empty
    ].map(String)
    const actual = spawnSync(binary, argv, { encoding: 'utf8', timeout: 10_000, killSignal: 'SIGKILL' })
    const prediction = expected({ row, operation, nested })
    const passed =
        !actual.error &&
        actual.signal === null &&
        actual.status === prediction.status &&
        actual.stdout === '' &&
        actual.stderr === prediction.stderr
    const result = {
        id: row.id,
        argv,
        passed,
        expected: prediction,
        status: actual.status,
        signal: actual.signal,
        stdout: actual.stdout,
        stderr: actual.stderr,
        error: actual.error?.message
    }

    if (!passed) console.error(JSON.stringify(result))

    return result
})
const passed = results.filter(result => result.passed).length
const sha256 = createHash('sha256').update(readFileSync(binary)).digest('hex')

writeFileSync(report, JSON.stringify({ binary, sha256, mode, passed, total: rows.length, results }, null, 2) + '\n')
console.log(`${mode} isolated compound safety: ${passed}/${rows.length} passed`)

assert.equal(passed, rows.length)
