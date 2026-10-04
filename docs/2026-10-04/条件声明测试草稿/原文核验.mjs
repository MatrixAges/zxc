import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
let negatives = 0
const values = []

for (const row of evidence) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)

  if (row.negative) {
    assert.throws(() => new vm.Script(raw.toString()), SyntaxError)
    negatives++
  } else {
    const context = vm.createContext(Object.create(null))
    vm.runInContext(harness, context)
    vm.runInContext('var checkedValues = []; var originalSame = assert.sameValue; assert.sameValue = function(a,b,m) { checkedValues.push(b); return originalSame(a,b,m); };', context)
    vm.runInContext(raw.toString(), context, { timeout: 1000 })
    values.push(...context.checkedValues)
  }
}

const cases = readFileSync('packages/test/tests/language/statements/if_declarations/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of cases) {
  const body = row.source.match(/export default function \(in: Input\): Output \{([\s\S]*)\}\s*$/)[1].replace(/: u64\?/g, '')
  if (row.id.includes('/block/')) assert.equal(new Function(body)(), 1)
  else if (row.id.includes('empty-statement')) assert.equal(new Function(body)(), 1)
  else assert.throws(() => new Function(body), SyntaxError)
}

assert.equal(evidence.length, 17)
assert.equal(negatives, 8)
assert.equal(values.length, 33)
assert.equal(values.filter(value => value === undefined).length, 26)
assert.equal(cases.length, 16)
console.log('17 original hashes/bodies: 8 parse negatives, 9 executions; 33 actual completion assertions (26 undefined, 7 numeric); 16 original/isolated/block cases independently checked')
