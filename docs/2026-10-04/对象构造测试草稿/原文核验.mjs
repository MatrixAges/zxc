import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const readRows = path => readFileSync(path, 'utf8').trim().split('\n').map(JSON.parse)
const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
let assertions = 0
for (const sample of readRows('packages/test/src/data/object_construction.jsonl')) {
  const raw = readFileSync(resolve(base, sample.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), sample.sha256)
  const observed = []
  vm.runInNewContext(raw.toString('utf8'), { assert: { sameValue(actual, expected) {
    assert.ok(Object.is(actual, expected)); observed.push(actual); assertions++
  } } }, { timeout: 1000 })
  const values = sample.group === 'merge' ? observed.slice(0, 4) : [observed[0], observed[1], observed[3], observed[4]]
  assert.deepEqual(values, sample.values)
  const rows = readRows(`packages/test/tests/language/expressions/object_construction/${sample.group}.jsonl`)
  for (const row of rows) assert.equal(row.expected.value, values[row.input])
}
assert.equal(assertions, 12)
const factories = {
  forward: (left, right) => ({ a: left(), z: right() }),
  reverse: (left, right) => ({ z: left(), a: right() }),
  nested: (left, right) => ({ outer: { z: left(), a: right() } }),
  duplicate: (left, right) => ({ item: left(), item: right() }),
  spread_first: (left, right) => ({ ...{ item: left() }, item: right() }),
  spread_last: (left, right) => ({ item: left(), ...{ item: right() } }),
}
let checked = 0
for (const [name, create] of Object.entries(factories)) {
  for (const row of readRows(`packages/test/tests/runtime/evaluation_order/object/${name}.jsonl`)) {
    const trace = []
    function left() { trace.push('L'); if (row.input.fail_left) throw 'LeftFailure'; return 2 }
    function right() { trace.push('R'); if (row.input.fail_right) throw 'RightFailure'; return 3 }
    let actual
    try {
      const value = create(left, right)
      const fields = name === 'nested' ? value.outer : value
      const result = 'item' in fields ? fields.item : name === 'forward' ? fields[row.input.pick_left ? 'a' : 'z'] : fields[row.input.pick_left ? 'z' : 'a']
      actual = { trace: trace.join(''), value: result }
    } catch (error) { actual = { trace: trace.join(''), error } }
    assert.deepEqual(actual, row.expected)
    checked++
  }
}
assert.equal(checked, 36)
console.log('2 original hashes / 12 assertions; 6 ZX value expectations and 36 independent object call traces verified')
