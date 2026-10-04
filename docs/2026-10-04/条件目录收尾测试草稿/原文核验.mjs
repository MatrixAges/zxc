import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
const tail_harness = readFileSync(resolve(base, 'harness/tcoHelper.js'), 'utf8')
const results = []

for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  const source = (row.strict ? '"use strict";\n' : '') + raw.toString()

  if (row.negative) {
    assert.throws(() => new vm.Script(source), SyntaxError)
    if (row.strict) new vm.Script(raw.toString())
    results.push({ path: row.path, result: 'parse SyntaxError', strict: row.strict })
  } else if (row.tail) {
    let outcome = 'passed'
    try { vm.runInNewContext('"use strict";\n' + harness + '\n' + tail_harness + '\n' + source, Object.create(null), { timeout: 2000 }) }
    catch (error) { assert.equal(error.name, 'RangeError'); outcome = 'reference environment RangeError; full tail-call requirement not verified' }
    results.push({ path: row.path, result: outcome })
  } else {
    vm.runInNewContext(harness + '\n' + source, Object.create(null), { timeout: 1000 })
    results.push({ path: row.path, result: 'passed' })
  }
}

assert.equal(rows.length, 32)
assert.equal(rows.filter(row => row.negative).length, 28)
assert.equal(rows.filter(row => row.strict && !row.tail).length, 8)
writeFileSync(new URL('./参考执行结果.json', import.meta.url), JSON.stringify(results, null, 2) + '\n')
console.log('32 hashes/bodies verified; 28 parse negatives (8 strict/sloppy contrast controls), 2 newline positives; 2 full-size TCO results recorded without lowering iteration count')
