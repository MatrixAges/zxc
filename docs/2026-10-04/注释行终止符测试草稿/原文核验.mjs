import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
const results = []

for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString(), row.source)

  for (const strict of [false, true]) {
    const context = vm.createContext(Object.create(null))

    vm.runInContext(harness, context)
    const script = new vm.Script((strict ? '"use strict";\n' : '') + row.source)

    if (row.negative) {
      assert.equal(row.negative.phase, 'runtime')
      assert.equal(row.negative.type, 'Test262Error')
      const expected = vm.runInContext('Test262Error', context)

      assert.throws(() => script.runInContext(context, { timeout: 30000 }), expected)
    } else script.runInContext(context, { timeout: 30000 })

    results.push({ path: row.path, strict, check: row.negative ? 'expected runtime Test262Error' : 'original execution', passed: true })
  }
}

writeFileSync(new URL('./原文结果.json', import.meta.url), JSON.stringify({ node: process.version, results }, null, 2) + '\n')
console.log(JSON.stringify({ files: rows.length, expected_runtime_errors: results.filter(row => row.check === 'expected runtime Test262Error').length, ordinary_executions: results.filter(row => row.check === 'original execution').length }))
