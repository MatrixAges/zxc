import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
let assertions = 0
for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  function test(value) { assert.ok(value); assertions++ }
  test.sameValue = (actual, expected) => { assert.ok(Object.is(actual, expected)); assertions++ }
  vm.runInNewContext(raw.toString('utf8'), { assert: test }, { timeout: 1000 })
}
assert.equal(assertions, 5)
let checked = 0
for (const shape of ['flat', 'nested']) {
  const catalog = readFileSync(`packages/test/tests/runtime/evaluation_order/array/${shape}.jsonl`, 'utf8').trim().split('\n').map(JSON.parse)
  for (const row of catalog) {
    const trace = []
    let actual
    function left() { trace.push('L'); if (row.input.fail_left) throw 'LeftFailure'; return 2 }
    function right() { trace.push('R'); if (row.input.fail_right) throw 'RightFailure'; return 3 }
    try {
      const values = shape === 'flat' ? [left(), right()] : [[left()], [right()]]
      if (row.input.index >= values.length) throw 'IndexOutOfBounds'
      actual = { trace: trace.join(''), value: shape === 'flat' ? values[row.input.index] : values[row.input.index][0] }
    } catch (error) { actual = { trace: trace.join(''), error } }
    assert.deepEqual(actual, row.expected)
    checked++
  }
}
assert.equal(checked, 24)
console.log('3 upstream hashes / 5 original assertions / 24 independently executed trace expectations verified')
