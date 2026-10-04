import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js', 'propertyHelper.js', 'compareArray.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
let descriptors = 0
for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString('utf8').split('---*/')[1].trim(), row.body)
  const context = vm.createContext({})
  vm.runInContext(harness, context, { timeout: 1000 })
  vm.runInContext('var checkedValues = []; var originalVerify = verifyProperty; verifyProperty = function(o,n,d,options) { checkedValues.push(d.value); return originalVerify(o,n,d,options); };', context)
  vm.runInContext(raw.toString('utf8'), context, { timeout: 1000 })
  descriptors += context.checkedValues.length
  if (row.kind === 'copy') assert.deepEqual(Array.from(context.checkedValues), [1,2,3,4])
}
assert.equal(rows.length, 18)
assert.equal(descriptors, 7)
console.log('18 original hashes/bodies executed with actual harness; 7 descriptor checks and copied values verified')
