import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const readRows = path => readFileSync(path, 'utf8').trim().split('\n').map(JSON.parse)
const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
let assertions = 0
for (const sample of readRows('packages/test/src/data/object_duplicate.jsonl')) {
  const raw = readFileSync(resolve(base, sample.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), sample.sha256)
  function check(value) { assert.ok(value); assertions++ }
  check.sameValue = (actual, expected) => { assert.ok(Object.is(actual, expected)); assertions++ }
  vm.runInNewContext(raw.toString('utf8'), { assert: check }, { timeout: 1000 })
}
assert.equal(assertions, 8)
const runtime = readRows('packages/test/tests/language/expressions/object_construction/duplicate.jsonl')
for (const row of runtime) {
  const actual = vm.runInNewContext('({ foo: first, foo: last }).foo', row.input)
  assert.equal(actual, row.expected.value)
}
assert.equal(runtime.length, 5)
const frontend = readRows('packages/test/tests/language/types/object_duplicate/cases.jsonl')
assert.equal(frontend.length, 32)
assert.equal(new Set(frontend.map(row => row.id)).size, 32)
assert.equal(frontend.filter(row => row.diagnostic === null).length, 20)
assert.equal(frontend.filter(row => row.diagnostic === 'type_mismatch').length, 12)
console.log('5 original hashes / 8 original assertions; 5 duplicate values and 32-case catalog integrity verified')
