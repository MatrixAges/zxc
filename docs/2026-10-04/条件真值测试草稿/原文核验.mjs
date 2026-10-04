import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
let conditions = 0

for (const row of evidence) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  const context = vm.createContext(Object.create(null))
  vm.runInContext(harness + '\n' + raw.toString(), context, { timeout: 1000 })
  if (row.alternative) assert.equal(context.c, row.expressions.length)

  for (const expression of row.expressions) {
    assert.ok(raw.toString().includes(`if(${expression})`))
    assert.equal(vm.runInNewContext(`Boolean(${expression})`, Object.create(null)), false)
    conditions++
  }
}

const cases = readFileSync('packages/test/tests/language/statements/if_truthiness/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of cases) {
  if (!row.id.includes('/typed/')) {
    const expression = row.source.match(/  if \((.*)\) \{/)[1]
    assert.equal(vm.runInNewContext(`Boolean(${expression})`, Object.create(null)), false)
  }
  if (row.span) assert.ok(row.source.slice(...row.span).length > 0)
}

assert.equal(evidence.length, 4)
assert.equal(conditions, 30)
assert.equal(cases.length, 38)
console.log('4 original hashes/bodies and two else counters verified; all 30 original conditions are JS false; 38 catalog rows checked without claiming JS equivalence for ZX types')
