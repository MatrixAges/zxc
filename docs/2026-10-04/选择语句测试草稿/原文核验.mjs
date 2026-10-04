import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  assert.throws(() => new vm.Script(raw.toString()), SyntaxError)
}

let count = 0
for (const shape of ['default_first', 'default_last', 'empty', 'default_only', 'no_fallthrough']) {
  const path = `packages/test/tests/runtime/evaluation_order/switch_statement/${shape}`
  const source = readFileSync(path + '.zx', 'utf8')
  let body = source.match(/export default function \(in: Input\): Output \{([\s\S]*)\}\s*$/)[1].replace(/\bin\b/g, 'input')
  const original = body
  if (shape === 'no_fallthrough') body = body.replace(/(const (?:first|second) = readRight\(input.fail_right\);)/g, '$1 break;')
  const execute = new Function('input', 'readLeft', 'readRight', body)
  const cases = readFileSync(path + '.jsonl', 'utf8').trim().split('\n').map(JSON.parse)

  for (const row of cases) {
    let trace = ''
    const readLeft = fail => { trace += 'L'; if (fail) throw new Error('LeftFailure'); return 2 }
    const readRight = fail => { trace += 'R'; if (fail) throw new Error('RightFailure'); return 3 }
    let actual
    try { const value = execute(row.input, readLeft, readRight); actual = { trace, value } }
    catch (error) { actual = { trace, error: error.message } }
    assert.deepEqual(actual, row.expected, row.id)
    if (shape === 'no_fallthrough' && row.input.match_value === 2 && !row.input.fail_left && !row.input.fail_right) {
      trace = ''
      new Function('input', 'readLeft', 'readRight', original)(row.input, readLeft, readRight)
      assert.equal(trace, 'LRR')
    }
    count++
  }
}
assert.equal(rows.length, 3)
assert.equal(count, 36)
console.log('3 original parse-negative hashes/bodies verified; 36 traces checked with explicit ZX no-fallthrough model; raw JS fallthrough LRR contrast confirmed')
