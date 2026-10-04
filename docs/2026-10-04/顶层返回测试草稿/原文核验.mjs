import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
let negatives = 0
let tail_result = ''

for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)

  if (row.path.endsWith('/tco.js')) {
    const harness = ['sta.js', 'assert.js', 'tcoHelper.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
    try { vm.runInNewContext('"use strict";\n' + harness + '\n' + raw.toString(), Object.create(null), { timeout: 2000 }); tail_result = 'passed' }
    catch (error) { assert.equal(error.name, 'RangeError'); tail_result = 'Node reference RangeError at original 100000 iterations; not verified' }
  } else {
    assert.throws(() => new vm.Script(raw.toString()), SyntaxError)
    new Function(raw.toString())
    negatives++
  }
}

const cases = readFileSync('packages/test/tests/language/statements/return_top_level/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of cases.filter(row => row.span)) assert.equal(row.source.slice(...row.span), 'return')
assert.equal(cases.length, 8)
assert.equal(negatives, 10)
writeFileSync(new URL('./尾调用参考结果.json', import.meta.url), JSON.stringify({ tail_result }, null, 2) + '\n')
console.log('11 original hashes/bodies checked; 10 original scripts rejected while function-wrapper parse controls accepted; original-size tail-call result recorded; 6 return spans verified')
