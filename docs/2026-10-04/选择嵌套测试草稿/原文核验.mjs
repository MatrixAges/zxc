import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
for (const row of evidence) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  if (row.negative) assert.throws(() => new vm.Script(raw.toString()), SyntaxError)
  else {
    const context = vm.createContext(Object.create(null))
    vm.runInContext(harness + '\n' + raw.toString(), context, { timeout: 1000 })
    assert.equal(context.SwitchTest(0), 6)
    assert.equal(context.SwitchTest(1), 32)
  }
}
const path = 'packages/test/tests/language/statements/switch/nested/cases'
const source = readFileSync(path + '.zx', 'utf8')
const body = source.match(/export default function \(in: Input\): Output \{([\s\S]*)\}\s*$/)[1].replace(/\bin\b/g, 'input')
const execute = new Function('input', body)
const rows = readFileSync(path + '.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of rows) assert.equal(execute(row.input), row.expected.value)
assert.equal(evidence.length, 4)
assert.equal(rows.length, 4)
console.log('4 original hashes/bodies verified (3 syntax errors, 1 complete execution); original diagonal 6/32 and 4 adapted nested outputs verified')
