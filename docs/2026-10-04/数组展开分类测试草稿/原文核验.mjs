import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const files = ['sta.js', 'assert.js', 'propertyHelper.js']
const harnesses = files.map(name => readFileSync(resolve(base, 'harness', name), 'utf8'))
const hashes = files.map((name, index) => ({ name, sha256: createHash('sha256').update(harnesses[index]).digest('hex') }))
writeFileSync(new URL('./参考辅助库哈希.json', import.meta.url), JSON.stringify(hashes, null, 2) + '\n')
const harness = harnesses.join('\n')
let property_checks = 0
for (const sample of rows) {
  const raw = readFileSync(resolve(base, sample.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), sample.sha256)
  const context = vm.createContext({})
  vm.runInContext(harness, context, { timeout: 1000 })
  vm.runInContext('var checkedValues = []; var originalVerify = verifyProperty; verifyProperty = function(o, n, d, options) { checkedValues.push(d.value); return originalVerify(o, n, d, options); };', context)
  vm.runInContext(raw.toString('utf8'), context, { timeout: 1000 })
  if (sample.kind === 'obj-ident') {
    assert.deepEqual(Array.from(context.checkedValues), [3, 4])
    property_checks += context.checkedValues.length
    const mutated = raw.toString('utf8').replace('enumerable: true', 'enumerable: false')
    assert.notEqual(mutated, raw.toString('utf8'))
    assert.throws(() => vm.runInNewContext(harness + '\n' + mutated, {}, { timeout: 1000 }), error => error.constructor.name === 'Test262Error')
  }
}
assert.equal(property_checks, 2)
console.log('5 original files verified with actual upstream harness; 2 property descriptors checked; incorrect enumerable expectation rejected')
