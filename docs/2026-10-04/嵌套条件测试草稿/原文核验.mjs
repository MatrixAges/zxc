import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
let negatives = 0

for (const row of evidence) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)

  if (row.negative) {
    assert.throws(() => new vm.Script(raw.toString()), SyntaxError)
    negatives++
  } else {
    vm.runInNewContext(harness + '\n' + raw.toString(), Object.create(null), { timeout: 1000 })
  }
}

let count = 0
for (const shape of ['full', 'inner_partial', 'outer_partial', 'both_partial', 'else_if']) {
  const path = `packages/test/tests/runtime/evaluation_order/if_statement/nested_${shape}`
  const source = readFileSync(path + '.zx', 'utf8')
  const body = source.match(/export default function \(in: Input\): Output \{([\s\S]*)\}\s*$/)[1].replace(/\bin\b/g, 'input')
  const execute = new Function('input', 'readLeft', 'readRight', body)
  const rows = readFileSync(path + '.jsonl', 'utf8').trim().split('\n').map(JSON.parse)

  for (const row of rows) {
    let trace = ''
    const readLeft = fail => { trace += 'L'; if (fail) throw new Error('LeftFailure'); return 2 }
    const readRight = fail => { trace += 'R'; if (fail) throw new Error('RightFailure'); return 3 }
    let actual

    try {
      const value = execute(row.input, readLeft, readRight)
      actual = { trace, value }
    } catch (error) {
      actual = { trace, error: error.message }
    }

    assert.deepEqual(actual, row.expected, row.id)
    count++
  }
}

assert.equal(evidence.length, 7)
assert.equal(negatives, 1)
assert.equal(count, 80)
console.log('7 original hashes/bodies verified: 1 parse error, 6 executions; 80 nested/else-if exact traces and results independently executed')
