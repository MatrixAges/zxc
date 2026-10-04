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

const rows = readFileSync('packages/test/tests/language/types/object_shorthand/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
let unbound = 0
let bound = 0

for (const row of rows.filter(row => row.phase !== 'parse' && row.diagnostic !== 'naming')) {
  const expression = row.source.match(/const object = (.*);/)[1]
  const declaration = row.id.endsWith('/bound') ? 'const missing = 2; ' : ''
  const script = new vm.Script(`${declaration}const object = ${expression}; object;`)

  if (row.diagnostic === 'name') {
    assert.throws(() => script.runInNewContext(), error => error.name === 'ReferenceError')
    unbound++
  } else {
    const result = script.runInNewContext()
    assert.equal(row.id.includes('/nested/') ? result.outer.missing : result.missing, row.id.includes('/overwritten/') || row.id.endsWith('explicit_label') ? 1 : 2)
    bound++
  }
}

const runtime = readFileSync('packages/test/tests/language/expressions/object_construction/shorthand_duplicate.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of runtime) {
  const result = vm.runInNewContext('const value = input; const object = { value, value, }; object.value;', { input: row.input })
  assert.equal(result, row.expected.value)
}

assert.equal(evidence.length, 15)
assert.equal(negatives, 12)
assert.equal(unbound, 4)
assert.equal(bound, 5)
assert.equal(runtime.length, 3)
console.log('15 originals: 12 parse SyntaxErrors and 3 successful executions; 4 missing bindings, 5 bound/label controls and 3 duplicate shorthand values verified')
