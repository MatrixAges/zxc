import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const corpus = process.argv[2]
const manifest = JSON.parse(readFileSync(resolve(import.meta.dirname, '上游原文清单.json'), 'utf8'))
const evidence = []

class Test262Error extends Error {}

for (const row of manifest) {
    const source = readFileSync(resolve(corpus, row.path))
    const sha256 = createHash('sha256').update(source).digest('hex')

    if (sha256 !== row.sha256) throw new Error(`stale source: ${row.path}`)
    if ((source.toString().match(/\/\/CHECK#/g) ?? []).length !== row.checks)
        throw new Error(`stale checks: ${row.path}`)

    for (const mode of ['sloppy', 'strict']) {
        const context = { Test262Error }
        const prefix = mode === 'strict' ? '"use strict";\n' : ''

        runInNewContext(prefix + source.toString(), context, { filename: row.path, timeout: 1000 })
        evidence.push({ path: row.path, sha256, mode, checks: row.checks, exit_code: 0 })
    }
}

writeFileSync(resolve(import.meta.dirname, '上游原文执行证据.json'), JSON.stringify(evidence, null, 2) + '\n')
console.log(
    JSON.stringify({
        files: manifest.length,
        executions: evidence.length,
        checks: evidence.reduce((sum, row) => sum + row.checks, 0)
    })
)
