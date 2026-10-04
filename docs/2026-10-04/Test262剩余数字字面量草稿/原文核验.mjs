import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
const capabilities = vm.runInNewContext('[0b10 === 2, 0o10 === 8, 0x10 === 16, 1_0 === 10, 1.0e-10_0 === 1e-100, .1e1 === 1, 1.e1 === 10]')

assert.ok(capabilities.every(Boolean))
const results = []

for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)

  const modes = row.flags.includes('onlyStrict') ? [true] : row.flags.includes('noStrict') ? [false] : [false, true]

  for (const strict of modes) {
    const source = (strict ? '"use strict";\n' : '') + harness + '\n' + raw.toString()

    if (row.negative) assert.throws(() => new vm.Script(source), SyntaxError)
    else vm.runInNewContext(source, Object.create(null), { timeout: 30000 })

    results.push({ path: row.path, strict, check: row.negative ? 'parse-only rejection' : 'original execution', passed: true })
  }
}

writeFileSync(new URL('./原文结果.json', import.meta.url), JSON.stringify({ node: process.version, capabilities, results }, null, 2) + '\n')
console.log(JSON.stringify({ files: rows.length, executions: results.filter(row => row.check === 'original execution').length, parse_only: results.filter(row => row.check === 'parse-only rejection').length }))
