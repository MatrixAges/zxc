import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
let checks = 0

for (const row of evidence) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  vm.runInNewContext(harness + '\n' + raw.toString(), {}, { timeout: 1000 })
  checks += [...row.body.matchAll(/\/\/CHECK#/g)].length
}

const root = resolve('packages/test/tests/language/expressions/object_construction/fields')
let values = 0

for (const file of readdirSync(root).filter(file => file.endsWith('.jsonl'))) {
  const rows = readFileSync(resolve(root, file), 'utf8').trim().split('\n').map(JSON.parse)
  const source = readFileSync(resolve(root, file.replace('.jsonl', '.zx')), 'utf8')
  const expression = source.match(/const object = (.*);/)[1]
  const field = source.match(/return object\.(\w+);/)[1]
  const factory = new vm.Script(`const prop = input; const object = ${expression.replace(/\bin\b/g, 'input')}; object.${field};`)

  for (const row of rows) {
    assert.deepEqual(factory.runInNewContext({ input: row.input }), row.expected.value)
    values++
  }
}

assert.equal(evidence.length, 9)
assert.equal(values, 24)
console.log(`9 original hashes and complete bodies passed (${checks} CHECK blocks); ${values} actual field readbacks independently verified`)
