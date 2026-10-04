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
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)

  for (const strict of row.only_strict ? [true] : [false, true]) {
    const source = (strict ? '"use strict";\n' : '') + harness + '\n' + raw.toString()

    if (row.negative) assert.throws(() => new vm.Script(source), SyntaxError)
    else vm.runInNewContext(source, Object.create(null), { timeout: 2000 })

    results.push({ path: row.path, strict, check: row.negative ? 'parse-only rejection' : 'original execution' })
  }
}

assert.equal(results.length, 18)
assert.equal(results.filter(row => row.check === 'parse-only rejection').length, 2)
writeFileSync(new URL('./原文结果.json', import.meta.url), JSON.stringify(results, null, 2) + '\n')
console.log('10 original hashes and bodies verified; 2 strict parse-only rejections and 16 actual original executions passed')
